
import UIKit

public class ATEVolumeNotchViewBuilder {
    
    private var configuration: ATEVolumeNotchConfiguration
    private var parentView: UIView?
    
    public init() {
        configuration = ATEVolumeNotchConfiguration(
            foregroundColor: UIColor.purple,
            timeDisplayedAfterVolumeChange: 3
        )
        parentView = nil
    }
    
    public func set(configuration: ATEVolumeNotchConfiguration) -> ATEVolumeNotchViewBuilder {
        self.configuration = configuration
        return self
    }
    
    public func set(parentView: UIView) -> ATEVolumeNotchViewBuilder {
        self.parentView = parentView
        return self
    }
    
    public func build() -> ATEVolumeView {
        let view = getNotchVolumeView()
        
        if let parentView = self.parentView {
            defaultAutolayoutLink(volumeView: view, intoParentView: parentView)
        }
        
        return view
    }
    
    private func getNotchVolumeView() -> ATEVolumeNotchView {
        let view = ATEVolumeNotchView(frame: .zero)
        
        // Due to simulator not display the MPVolumeView we perform a volume control
        // emulator to avoid the use into real devices. See example for more information
        #if (arch(i386) || arch(x86_64))
        let getVolume = GetVolumeEmulator()
        let onVolume = GetVolumeChangesEmulator.shared
        #else
        let getVolume = GetVolumeInteractor()
        let onVolume = GetVolumeChangesInteractor()
        #endif
        
        let presenter = ATEVolumeViewPresenterDefault(
            configuration: configuration,
            onVolumeInteractor: onVolume,
            onAlarmInteractor: GetAlarmInteractor(),
            getVolume: getVolume)
        
        // Binding
        presenter.view = view
        view.presenter = presenter
        view.configuration = configuration
        
        return view
    }

    private func defaultAutolayoutLink(volumeView: ATEVolumeNotchView, intoParentView parentView: UIView) {
        volumeView.view.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(volumeView.view)
        
        volumeView.view.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        if #available(iOS 11.0, *) {
            volumeView.view.leftAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leftAnchor).isActive = true
            volumeView.view.rightAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            volumeView.view.leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
            volumeView.view.rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
        }
        
        volumeView.view.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
}
