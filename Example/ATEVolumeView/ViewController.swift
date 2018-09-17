
import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import ATEVolumeView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        mountDemoPlayer()
        mountVolumeControl()
    }

    private func mountVolumeControl() {
        // ATEVolumeView configuration
        let configuration = ATEVolumeNotchConfiguration(foregroundColor: UIColor.white.withAlphaComponent(0.75),
                                                        timeDisplayedAfterVolumeChange: 2)
        let volumeView = ATEVolumeNotchViewBuilder.create(configuration: configuration)

//        let configuration = ATEVolumeRectangleConfiguration(backgroundColor: .gray,
//                                                            foregroundColor: .purple,
//                                                            timeDisplayedAfterVolumeChange: 2)
//        let volumeView = ATEVolumeRectangleViewBuilder.create(configuration: configuration)
        
        // Add to your view tree
        volumeView.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(volumeView.view)
        
        volumeView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        volumeView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        volumeView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        volumeView.view.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        volumeView.bind(inside: self.view)
    }
    
    private func mountDemoPlayer() {
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

