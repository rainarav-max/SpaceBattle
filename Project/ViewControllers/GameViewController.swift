
//  This page controls the game.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentGameScene: GameScene?
    @IBOutlet var resultBtn : UIButton?
    
//    @IBAction func unwindResultToGameVC(sender: UIButton){
//        //self.performSegue(withIdentifier: "unwindHomeToGameSegue", sender: self)
//    }
//    
    @IBAction func unwindResultToGameVC(sender : UIStoryboardSegue){}

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //let sceneSize = CGSize(width: 400, height: 400)
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        currentGameScene = scene
        currentGameScene?.gameVC = self
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
