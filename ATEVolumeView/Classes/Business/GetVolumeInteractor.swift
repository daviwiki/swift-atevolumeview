
import Foundation
import AVFoundation

protocol GetVolume {
    /**
     Return the AVAudioSession volume in range [0, 1]
    */
    func execute() -> Float
}

class GetVolumeInteractor: GetVolume {
    func execute() -> Float {
        return AVAudioSession.sharedInstance().outputVolume
    }
}

class GetVolumeEmulator: GetVolume {
    func execute() -> Float {
        return GetVolumeChangesEmulator.shared.volume
    }
}