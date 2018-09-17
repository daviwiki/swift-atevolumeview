
import Foundation

public struct ATEVolumeNotchConfiguration: ATEVolumeConfiguration {
    
    // Volume slider color
    public let foregroundColor: UIColor
    
    // Time (in seconds) that volume control will be displayed after user change the device volume
    public let timeDisplayedAfterVolumeChange: TimeInterval
    
    public init(foregroundColor: UIColor,
                timeDisplayedAfterVolumeChange: TimeInterval) {
        self.foregroundColor = foregroundColor
        self.timeDisplayedAfterVolumeChange = timeDisplayedAfterVolumeChange
    }
}
