
import UIKit

public class ATEVolumeRectangleViewBuilder {

    private var configuration: ATEVolumeRectangleConfiguration
    private var parentView: UIView?
    
    public init() {
        configuration = ATEVolumeRectangleConfiguration(
            backgroundColor: UIColor.gray.withAlphaComponent(0.4),
            foregroundColor: UIColor.purple,
            timeDisplayedAfterVolumeChange: 3
        )
        parentView = nil
    }
    
    public func set(configuration: ATEVolumeRectangleConfiguration) -> ATEVolumeRectangleViewBuilder {
        self.configuration = configuration
        return self
    }
    
    public func set(parentView: UIView) -> ATEVolumeRectangleViewBuilder {
        self.parentView = parentView
        return self
    }
    
    public func build() -> ATEVolumeView {
        let view = getRectangleVolumeView()
        
        if let parentView = self.parentView {
            defaultAutolayoutLink(volumeView: view, intoParentView: parentView)
        }
        
        return view
    }
    
    private func getRectangleVolumeView() -> ATEVolumeRectangleView {
        let view = ATEVolumeRectangleView(frame: .zero)
        
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
    
    private func defaultAutolayoutLink(volumeView: ATEVolumeView, intoParentView parentView: UIView) {
        volumeView.view.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(volumeView.view)

        if #available(iOS 11.0, *) {
            volumeView.view.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            volumeView.view.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        }
        volumeView.view.leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        volumeView.view.rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
        volumeView.view.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
}
