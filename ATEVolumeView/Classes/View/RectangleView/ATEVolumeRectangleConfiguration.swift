
import Foundation

public struct ATEVolumeRectangleConfiguration: ATEVolumeConfiguration {

    // Color to be displayed at bottom of the view
    public let backgroundColor: UIColor

    // Volume slider color
    public let foregroundColor: UIColor

    // Time (in seconds) that volume control will be displayed after user change the device volume
    public let timeDisplayedAfterVolumeChange: TimeInterval

    public init(backgroundColor: UIColor, foregroundColor: UIColor,
                timeDisplayedAfterVolumeChange: TimeInterval) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.timeDisplayedAfterVolumeChange = timeDisplayedAfterVolumeChange
    }
}
