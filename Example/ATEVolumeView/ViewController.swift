
import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import ATEVolumeView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Display a streaming video
        let url = URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = false

        addChildViewController(playerController)
        playerController.view.frame = view.bounds
        view.addSubview(playerController.view)
        self.view.sendSubview(toBack: playerController.view)
        playerController.didMove(toParentViewController: self)
        player.play()
        
        // ATEVolumeView configuration
        let configuration = ATEVolumeRectangleConfiguration(backgroundColor: .yellow,
                                                            foregroundColor: .brown,
                                                            timeDisplayedAfterVolumeChange: 2)
        let volumeView = ATEVolumeRectangleViewBuilder.create(configuration: configuration)
        volumeView.bind(inside: self.view)
    }

    // MARK: Controls for simulator
    
    @IBAction func onLess(button: UIButton) {
        let volumeToSend = max(GetVolumeChangesEmulator.shared.volume - 0.05, 0)
        GetVolumeChangesEmulator.shared.send(volume: volumeToSend)
    }
    
    @IBAction func onMore(button: UIButton) {
        let volumeToSend = min(GetVolumeChangesEmulator.shared.volume + 0.05, 1)
        GetVolumeChangesEmulator.shared.send(volume: volumeToSend)
    }
}

