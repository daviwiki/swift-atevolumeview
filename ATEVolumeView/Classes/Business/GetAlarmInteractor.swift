
import Foundation

protocol GetAlarm {
    typealias OnAlarm = () -> ()
    func execute(fireAt seconds: TimeInterval, onAlarm: @escaping OnAlarm)
}

class GetAlarmInteractor: GetAlarm {
    
    private var displayTimer: Timer?
    private var callback: OnAlarm?
    
    func execute(fireAt seconds: TimeInterval, onAlarm: @escaping OnAlarm) {
        callback = onAlarm
        displayTimer?.invalidate()
        displayTimer = Timer.scheduledTimer(timeInterval: seconds,
                                            target: self, selector: #selector(onDisplayTimerEnds(timer:)),
                                            userInfo: nil, repeats: false)
    }
    
    @objc func onDisplayTimerEnds(timer: Timer) {
        displayTimer = nil
        callback?()
    }
    
    deinit {
        displayTimer?.invalidate()
        displayTimer = nil
    }
}
