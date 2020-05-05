
//  Note: Code developed with the help of tutorials at www.raywenderlich.com/71-spritekit-tutorial-for-beginners
//  Shows the gameover scene


import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    //connection to GameViewController to enable performSegue method invocation inside GameOverScene
    weak var gameVC2: GameViewController?
    
    //mainDelegate to access the mainScore of the user
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //initialize the gameover scene with two labels 
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let message = "Game Over!"
        
        let label = SKLabelNode(fontNamed: "GillSans-UltraBold")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        let label2 = SKLabelNode(fontNamed: "Arial")
        label2.text = "Tap to see results"
        label2.fontSize = 20
        label2.fontColor = SKColor.black
        label2.position = CGPoint(x: size.width/2, y: size.height/2 - 70)
        addChild(label2)
        
        //Players get Pro image for 25 or more points
        //Intermediate image for 15 or more points
        //Noobie image for points below 15
        var playerImage: String
        if(mainDelegate.mainScore >= 25){
            playerImage = "Pro.png"
        }else if(mainDelegate.mainScore >= 15){
            playerImage = "Intermediate.png"
        }else if(mainDelegate.mainScore >= 0){
            playerImage = "Noobie.png"
        }else{
            print("PLAYER IMAGE NOT IN ANY RANGE")
            playerImage = "Noobie.png"
        }
        let scoreData = ScoreData()
        scoreData.initWithData(theRow: -1, theScore: mainDelegate.mainScore, theDate: dateAsString(), theImage: playerImage)
        if(mainDelegate.insertIntoDatabase(player: scoreData)){
            print("Score saved to database: \(String(describing: scoreData.score))")
        }
    }
    
    //to take care of going to results when the user taps on the gameover screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("mainScore:  \(mainDelegate.mainScore)")
        gameVC2?.performSegue(withIdentifier: "GameToResultSegue", sender: gameVC2)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
