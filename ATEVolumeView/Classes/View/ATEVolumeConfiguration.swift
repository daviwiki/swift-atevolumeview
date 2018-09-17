
import Foundation

// Protocol that all ATEVolume views must conform
public protocol ATEVolumeConfiguration {

    // Time (in seconds) that volume control will be displayed after user change the device volume
    var timeDisplayedAfterVolumeChange: TimeInterval { get }

}
