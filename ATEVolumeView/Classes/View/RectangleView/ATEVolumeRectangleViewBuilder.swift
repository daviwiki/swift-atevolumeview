
import UIKit

public class ATEVolumeRectangleViewBuilder {

    /**
     Create a new RectangleVolumeView
     */
    public static func create() -> ATEVolumeView {
        let configuration = ATEVolumeRectangleConfiguration(
                backgroundColor: UIColor.gray.withAlphaComponent(0.4),
                foregroundColor: UIColor.purple,
                timeDisplayedAfterVolumeChange: 3
        )
        return create(configuration: configuration)
    }

    public static func create(configuration: ATEVolumeRectangleConfiguration) -> ATEVolumeView {
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

}