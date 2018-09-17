
import UIKit
import MediaPlayer

class ATEVolumeRectangleView: UIView, ATEVolumeView {

    var presenter: ATEVolumeViewPresenter!
    var configuration: ATEVolumeRectangleConfiguration!

    private weak var systemVolumeView: MPVolumeView?
    private weak var sliderView: SliderVolumeView?

    // MARK: ATEVolumeView

    public func set(volume: Float) {
        sliderView?.set(value: volume, animated: false)
    }
    
    public func showVolumeControl(volume: Float) {
        sliderView?.set(value: volume, animated: true)
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
        
        let sliderView = SliderVolumeView(frame: .zero)
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
