
import UIKit
import MediaPlayer

class ATEVolumeRectangleView: UIView, ATEVolumeView {

    var presenter: ATEVolumeViewPresenter!
    private weak var systemVolumeView: MPVolumeView?

    public func set(volume: Float) {
        
    }
    
    public func showVolumeControl(volume: Float) {
        print("Showing volume control")
    }

    public func hideVolumeControl() {
        print("Hidding volume control")
    }

    /**
     Bind the ATEVolumeView instance with the view given by parameter.
     - Note: This method add the ATEVolumeView into the view tree so you mustn't added too
     - Parameter parentView: parent view where ATEVolumeView will be displayed
    */
    func bind(inside parentView: UIView) {
        addSystemVolumeView(inside: parentView)
        createVolumeView(inside: parentView)
        presenter.start()
    }

    private func createVolumeView(inside parentView: UIView) {
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        let sliderView = UIView(frame: .zero)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sliderView)
        
        let margin: CGFloat = 16
        sliderView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        sliderView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1, constant: -2*margin).isActive = true
        sliderView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sliderView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sliderView.backgroundColor = UIColor.white
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
