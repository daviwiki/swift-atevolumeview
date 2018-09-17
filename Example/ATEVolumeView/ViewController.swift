
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

        let volumeView = ATEVolumeRectangleViewBuilder.create()
        volumeView.bind(inside: self.view)

        // Display future MPVolumeView
//        let volumeView = MPVolumeView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        volumeView.isHidden = false
//        volumeView.alpha = 0.01
//        view.addSubview(volumeView)
    }

    @IBAction func onLess(button: UIButton) {
        let volumeToSend = max(GetVolumeChangesEmulator.shared.volume - 0.05, 0)
        GetVolumeChangesEmulator.shared.send(volume: volumeToSend)
    }
    
    @IBAction func onMore(button: UIButton) {
        let volumeToSend = min(GetVolumeChangesEmulator.shared.volume + 0.05, 1)
        GetVolumeChangesEmulator.shared.send(volume: volumeToSend)
    }
}

