
import UIKit
import MediaPlayer

class ATEVolumeRectangleView: UIView, ATEVolumeView {

    var presenter: ATEVolumeViewPresenter!
    var configuration: ATEVolumeRectangleConfiguration!

    private weak var systemVolumeView: MPVolumeView?
    private weak var sliderView: SliderVolumeView?
    private var isFirstExecution: Bool = true

    // MARK: ATEVolumeView

    public var view: UIView {
        return self
    }
    
    public func set(volume: Float) {
        sliderView?.set(value: volume, animated: false)
    }
    
    public func showVolumeControl(volume: Float) {
        sliderView?.set(value: volume, animated: true)
        
        guard isHidden else { return }
        self.alpha = 0.01
        self.isHidden = false
        
        // This hack is implemented to avoid that, in the first execution,
        // the strokEnd comes from 1 -> initial value (i don't know way, but
        // i will try to investigate the reason) that provokes an strange UI.
        // Try to remove the delay to see the problem
        let delay = isFirstExecution ? 0.15 : 0.0
        isFirstExecution = false
            
        UIView.animate(withDuration: 0.15, delay: delay, options: .curveEaseOut, animations: { [unowned self]  in
            self.alpha = 1.0
        })
    }

    public func hideVolumeControl() {
        UIView.animate(withDuration: 0.15, animations: { [unowned self] in
            self.alpha = 0.01
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
        self.backgroundColor = configuration.backgroundColor
        addSystemVolumeView(inside: parentView)
        createVolumeView(inside: parentView)
        presenter.start()
    }

    /**
    Mount all views and layers to display the volume control and anchor them to the view passed as parameter
    */
    private func createVolumeView(inside parentView: UIView) {
        self.isHidden = true
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: SliderVolumeView.lineWidth/2))
        path.addLine(to: CGPoint(x: self.frame.width, y: SliderVolumeView.lineWidth/2))
        
        let sliderView = SliderVolumeView(bezierPath: path)
        sliderView.foregroundColor = configuration.foregroundColor
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
