
import UIKit
import MediaPlayer

class ATEVolumeRectangleView: UIView, ATEVolumeView {

    var presenter: ATEVolumeViewPresenter!
    private weak var systemVolumeView: MPVolumeView?
    private weak var sliderView: SliderView?

    public func set(volume: Float) {
        sliderView?.set(value: volume, animated: false)
    }
    
    public func showVolumeControl(volume: Float) {
        defer {
            sliderView?.set(value: volume, animated: true)
        }

        guard isHidden else { return }
        self.alpha = 0.0
        self.isHidden = false
        UIView.animate(withDuration: 0.15) { [unowned self] () -> Void in
            self.alpha = 1.0
        }
    }

    public func hideVolumeControl() {
        UIView.animate(withDuration: 0.15, animations: { [unowned self] in
            self.alpha = 0.0
        }, completion: { [unowned self] finished in
            self.isHidden = true
            self.alpha = 1.0
        })
    }

    /**
     Bind the ATEVolumeView instance with the view given by parameter.
     - Note: This method add the ATEVolumeView into the view tree so you mustn't added too
     - Parameter parentView: parent view where ATEVolumeView will be displayed
    */
    func bind(inside parentView: UIView) {
        self.backgroundColor = UIColor.gray
        addSystemVolumeView(inside: parentView)
        createVolumeView(inside: parentView)
        presenter.start()
    }

    /**
    Mount all views and layers to display the volume control and anchor them to the view passed as parameter
    */
    private func createVolumeView(inside parentView: UIView) {
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        
        if #available(iOS 11.0, *) {
            topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        }
        leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        let sliderView = SliderView(frame: .zero)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sliderView)
        
        let margin: CGFloat = 16
        sliderView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        sliderView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1, constant: -2*margin).isActive = true
        sliderView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sliderView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sliderView.backgroundColor = UIColor.clear

        self.sliderView = sliderView
    }

    deinit {
        systemVolumeView?.removeFromSuperview()
    }

    /**
    Include an 'non visible' MPVolumeView to avoid present the native one when user touches the volume control
    */
    private func addSystemVolumeView(inside parentView: UIView) {
        #if (arch(i386) || arch(x86_64))
        #else
        let volumeView = MPVolumeView()
        volumeView.isHidden = false
        volumeView.alpha = 0.01
        parentView.addSubview(volumeView)
        systemVolumeView = volumeView
        #endif
    }

}

private class SliderView: UIView {

    // Percent painted in range [0, 1]
    private var sliderLayer: CAShapeLayer!
    private var currentValue: CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        createLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createLayers()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        createLayers()
    }

    private func createLayers() {
        layer.sublayers?.forEach({ $0.removeFromSuperlayer() })

        let path = UIBezierPath()
        let lineHeight: CGFloat = 4
        path.move(to: CGPoint(x: 0, y: lineHeight/2))
        path.addLine(to: CGPoint(x: self.frame.width, y: lineHeight/2))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = lineHeight
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = currentValue

        layer.addSublayer(shapeLayer)
        sliderLayer = shapeLayer
    }

    /**
    Set value between [0, 1]
    */
    func set(value: Float, animated: Bool = false) {
        let cgValue = min(max(0, CGFloat(value)), 1)
        self.currentValue = cgValue
        sliderLayer.strokeEnd = cgValue
    }

}

public class ATEVolumeRectangleViewBuilder {
    
    /**
     Create a new RectangleVolumeView
     */
    public static func create() -> ATEVolumeView {
        let view = ATEVolumeRectangleView(frame: .zero)
        let configuration = ATEVolumeViewPresenterDefault.Configuration(displayTimerDuration: 3)
        
        // Due to simulator not display the MPVolumeView we perform a volume control
        // emulator to avoid the use into real devices. See example for more information
        #if (arch(i386) || arch(x86_64))
        let onVolume = GetVolumeChangesEmulator.shared
        #else
        let onVolume = GetVolumeChangesInteractor()
        #endif
        
        let presenter = ATEVolumeViewPresenterDefault(
            configuration: configuration,
            onVolumeInteractor: onVolume,
            onAlarmInteractor: GetAlarmInteractor(),
            getVolume: GetVolumeInteractor())
        
        // Binding
        presenter.view = view
        view.presenter = presenter
        
        return view
    }
    
}
