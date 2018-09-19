
import UIKit
import AVKit
import ATEVolumeView

class VolumeViewViewController: UIViewController {

    @IBOutlet weak var emulatorControlsView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mountDemoPlayer()
        #if (arch(i386) || arch(x86_64))
        emulatorControlsView.isHidden = false
        #else
        emulatorControlsView.isHidden = true
        #endif
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
    
    @IBAction func onDismiss(button: UIButton) {
        dismiss(animated: true, completion: nil)
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
