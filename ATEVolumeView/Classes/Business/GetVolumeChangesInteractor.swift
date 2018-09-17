
import Foundation
import AVFoundation

protocol GetVolumeChangesDelegate: class {
    /**
     This method is called each time the media volume of the device changes
    */
    func onVolumeChange(volume: Float)
}

protocol GetVolumeChanges {
    func execute(listener: GetVolumeChangesDelegate?)
}

class GetVolumeChangesInteractor: GetVolumeChanges {
    
    private weak var listener: GetVolumeChangesDelegate?
    private var kvoVolumeObserver: NSKeyValueObservation?
    
    func execute(listener: GetVolumeChangesDelegate?) {
        self.listener = listener
        guard listener != nil else { return }
        registerForKVONotifications()
    }
    
    private func registerForKVONotifications() {
        let audioSession = AVAudioSession.sharedInstance()
        kvoVolumeObserver = audioSession.observe(\AVAudioSession.outputVolume) { [unowned self] (audioSesssion, change) in
            self.onVolumeChange(to: audioSession.outputVolume)
        }
    }
    
    private func onVolumeChange(to volume: Float) {
        listener?.onVolumeChange(volume: volume)
    }
    
    deinit {
        kvoVolumeObserver = nil
    }
    
}

public class GetVolumeChangesEmulator: GetVolumeChanges {
    
    public static let shared: GetVolumeChangesEmulator = GetVolumeChangesEmulator()
    private init() {}
    
    private weak var listener: GetVolumeChangesDelegate?

    private(set) public var volume: Float = 0.5

    /**
     Send the volume you want to emit in range [0, 1]
    */
    public func send(volume: Float) {
        self.volume = volume
        listener?.onVolumeChange(volume: min(max(0, volume), 1))
    }
    
    func execute(listener: GetVolumeChangesDelegate?) {
        self.listener = listener
    }
}
