
import UIKit
import ATEVolumeView

class VolumeNotchViewController: VolumeViewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        mountVolumeControl()
    }

    private func mountVolumeControl() {
        let configuration = ATEVolumeNotchConfiguration(foregroundColor: UIColor.white.withAlphaComponent(0.75),
                                                        timeDisplayedAfterVolumeChange: 2)
        let volumeView = ATEVolumeNotchViewBuilder()
            .set(configuration: configuration)
            .set(parentView: self.view)
            .build()
        
        volumeView.bind(inside: self.view)
    }
    
}
