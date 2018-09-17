
import Foundation

public protocol ATEVolumeView: class {

    /**
     Return the main view for the ATEVolumeView piece
     */
    var view: UIView { get }
    
    /**
     Bind the ATEVolumeView to the UIView given
     */
    func bind(inside parentView: UIView)
    
    /**
     Set the volume value for the control (without request a UI display)
     - Parameter volume: volume in range [0, 1]
    */
    func set(volume: Float)
    
    /**
     Order to display the volume control into screen for the volume given
     - Parameter volume: volume in range [0, 1]
    */
    func showVolumeControl(volume: Float)

    /**
     Hide the volume control
    */
    func hideVolumeControl()

}
