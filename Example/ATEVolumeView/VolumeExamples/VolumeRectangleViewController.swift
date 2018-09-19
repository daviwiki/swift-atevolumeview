
import UIKit
import ATEVolumeView

class VolumeRectangleViewController: VolumeViewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        mountVolumeControl()
    }

    private func mountVolumeControl() {
        let configuration = ATEVolumeRectangleConfiguration(backgroundColor: .gray,
                                                            foregroundColor: .purple,
                                                            timeDisplayedAfterVolumeChange: 2)
        let volumeView = ATEVolumeRectangleViewBuilder()
            .set(configuration: configuration)
            .set(parentView: self.view)
            .build()
        
        volumeView.bind(inside: self.view)
    }
}
