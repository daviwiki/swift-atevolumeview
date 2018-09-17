
import Foundation
import AVFoundation

public protocol ATEVolumeViewPresenter: class {
    func start()
}

public class ATEVolumeViewPresenterDefault: NSObject, ATEVolumeViewPresenter {

    struct Configuration {
        var displayTimerDuration: TimeInterval = 3 /* seconds */
    }
    
    weak var view: ATEVolumeView?
    
    private var configuration: Configuration
    private var onVolumeInteractor: GetVolumeChanges
    private var onAlarmInteractor: GetAlarm
    private var getVolume: GetVolume
    
    init(configuration: Configuration, onVolumeInteractor: GetVolumeChanges,
         onAlarmInteractor: GetAlarm, getVolume: GetVolume) {
        self.configuration = configuration
        self.onVolumeInteractor = onVolumeInteractor
        self.onAlarmInteractor = onAlarmInteractor
        self.getVolume = getVolume
        super.init()
    }

    public func start() {
        view?.set(volume: getVolume.execute())
        self.registerForVolumeChangesEvents()
    }
    
    private func registerForVolumeChangesEvents() {
        onVolumeInteractor.execute(listener: self)
    }
    
}

extension ATEVolumeViewPresenterDefault: GetVolumeChangesDelegate {
    func onVolumeChange(volume: Float) {
        view?.showVolumeControl(volume: volume)
        onAlarmInteractor.execute(fireAt: configuration.displayTimerDuration) { [weak self] in
            self?.view?.hideVolumeControl()
        }
    }
}
