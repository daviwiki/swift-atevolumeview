
import UIKit
import MediaPlayer

class ATEVolumeNotchView: UIView, ATEVolumeView {
    
    var presenter: ATEVolumeViewPresenter!
    var configuration: ATEVolumeNotchConfiguration!
    
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
        self.backgroundColor = UIColor.clear
        addSystemVolumeView(inside: parentView)
        createVolumeView(inside: parentView)
        presenter.start()
    }
    
    /**
     Mount all views and layers to display the volume control and anchor them to the view passed as parameter
     */
    private func createVolumeView(inside parentView: UIView) {
        self.isHidden = true
        redrawSlider()
    }
    
    private func redrawSlider() {
        self.sliderView?.removeFromSuperview()
        
        let sliderView = SliderVolumeView(bezierPath: getBezierPath())
        sliderView.foregroundColor = configuration.foregroundColor
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sliderView)
        
        sliderView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        sliderView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10).isActive = true
        sliderView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sliderView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sliderView.backgroundColor = UIColor.clear
        
        self.sliderView = sliderView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redrawSlider()
    }
    
    private func getBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        // Notch Left
        path.move(to: CGPoint(x: 0.758066174, y: 31.734375))
        path.addCurve(to:CGPoint(x: 10, y: 10.8324323), controlPoint1: CGPoint(x: 1.45610116, y: 23.387861), controlPoint2: CGPoint(x: 4.53674577, y: 16.4205467))
        path.addCurve(to: CGPoint(x: 23.301766, y: 2.27999878), controlPoint1: CGPoint(x: 12.3348421, y: 8.44422835), controlPoint2: CGPoint(x: 16.8746303, y: 4.60457531))
        path.addCurve(to: CGPoint(x: 35.5949748, y: 0.2734375), controlPoint1: CGPoint(x: 27.1357057, y: 0.893333435), controlPoint2: CGPoint(x: 31.233442, y: 0.224479675))
        path.addLine(to: CGPoint(x: 73.1181587, y: 0.2734375))
        path.addCurve(to: CGPoint(x: 75.0950343, y: 0.60411616), controlPoint1: CGPoint(x: 74.1943325, y: 0.308176082), controlPoint2: CGPoint(x: 74.853291, y: 0.418402302))
        path.addCurve(to: CGPoint(x: 75.598523, y: 2.57539296), controlPoint1: CGPoint(x: 75.8507914, y: 1.18470962), controlPoint2: CGPoint(x: 75.6003348, y: 2.23342543))
        path.addCurve(to: CGPoint(x: 78.9439692, y: 17.6978846), controlPoint1: CGPoint(x: 75.5695471, y: 8.04458566), controlPoint2: CGPoint(x: 76.6846958, y: 13.0854162))
        path.addCurve(to: CGPoint(x: 96.7203732, y: 30.734375), controlPoint1: CGPoint(x: 82.8032248, y: 25.5768313), controlPoint2: CGPoint(x: 90.8637184, y: 29.7370489))
        
        // Notch Middle
        path.addCurve(to: CGPoint(x: 272.279999, y: 30.7334423), controlPoint1: CGPoint(x: 102.577028, y: 31.7307684), controlPoint2: CGPoint(x: 266.419983, y: 31.7268829))
        
        // Notch Right
        path.addCurve(to: CGPoint(x: 290.059998, y: 17.7000008), controlPoint1: CGPoint(x: 278.140015, y: 29.7400017), controlPoint2: CGPoint(x: 285.656245, y: 25.5800018))
        path.addCurve(to: CGPoint(x: 293.399994, y: 2.57446027), controlPoint1: CGPoint(x: 292.640799, y: 13.0819572), controlPoint2: CGPoint(x: 292.962715, y: 9.00188021))
        path.addCurve(to: CGPoint(x: 293.899994, y: 0.599998474), controlPoint1: CGPoint(x: 293.486326, y: 1.30548775), controlPoint2: CGPoint(x: 293.380618, y: 1.48294139))
        path.addCurve(to: CGPoint(x: 295.880005, y: 0.270000458), controlPoint1: CGPoint(x: 294.029404, y: 0.379999797), controlPoint2: CGPoint(x: 294.689408, y: 0.270000458))
        path.addLine(to: CGPoint(x: 332.410004, y: 0.272504808))
        path.addCurve(to: CGPoint(x: 342.700012, y: 2.27999878), controlPoint1: CGPoint(x: 334.990339, y: 0.272504808), controlPoint2: CGPoint(x: 339.087008, y: 0.941669465))
        path.addCurve(to: CGPoint(x: 356, y: 10.8300018), controlPoint1: CGPoint(x: 345.681327, y: 3.38433773), controlPoint2: CGPoint(x: 352.47143, y: 6.61606893))
        path.addCurve(to: CGPoint(x: 363.23999, y: 31.7300034), controlPoint1: CGPoint(x: 360.178026, y: 15.8195357), controlPoint2: CGPoint(x: 363.258023, y: 22.7862028))
        
        return path
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
