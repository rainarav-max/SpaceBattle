
//  Scene for the actual game
//

import SpriteKit
import AVFoundation

//functions to help with physics directions
func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

//functions to help for shoot direction calculations
extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {
    
    weak var gameVC : GameViewController?
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var soundPlayer : AVAudioPlayer?
    var difficultyString : [String] = ["Easy", "Medium", "Hard"]

    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let enemy   : UInt32 = 0b1       // 1
        static let projectile: UInt32 = 0b10      // 2
    }
   // let shooterImage = UIImage(named: "Images/shooter.png")
   // let texture = SKTexture(image: shooterImage!)
    let player = SKSpriteNode(texture: SKTexture(imageNamed: "shooter.png"),size: CGSize(width: 82, height: 50))
    let lblScore = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    let lblDifficulty = SKLabelNode(fontNamed: "ChalkboardSE-Bold")

    var enemyDestroyed = 0
    
    //the main function to add the player and labels to gamescene
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        
        lblScore.text = "Score:0"
        lblScore.fontSize = 20
        lblScore.fontColor = SKColor.black
        lblScore.position = CGPoint(x: size.width-320, y: size.height-30)
        
    
        lblDifficulty.text = "Difficulty: \(difficultyString[mainDelegate.difficultyLevel])"
        lblDifficulty.fontSize = 20
        lblDifficulty.fontColor = SKColor.black
        lblDifficulty.position = CGPoint(x: size.width-470, y: size.height-30)
        
        addChild(lblScore)
        addChild(lblDifficulty)
        addChild(player)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addEnemy),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        let backgroundMusic = SKAudioNode(fileNamed: "backgroundMusic.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        backgroundMusic.run(SKAction.changeVolume(to: (mainDelegate.volumeLevel/100), duration: 0))

    }
    
    //two methods to properly randomize the random number generation
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //adds enemy ships to the screen
    func addEnemy() {
        let enemy = SKSpriteNode(texture: SKTexture(imageNamed: "enemy.png"),size: CGSize(width: 98, height: 50))

        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size) // 1
        enemy.physicsBody?.isDynamic = true // 2
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy // 3
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: enemy.size.height/2, max: size.height - enemy.size.height/2-50)
        
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: actualY)
        
        // Add the enemy ship to the scene
        addChild(enemy)
        
        // set the speed of the enemy ship
        var actualDuration = CGFloat(4.0)
        switch mainDelegate.difficultyLevel {
        case 0: actualDuration = random(min: CGFloat(3.0), max: CGFloat(4.0))
        case 1: actualDuration = random(min: CGFloat(2.2), max: CGFloat(3.0))
        case 2: actualDuration = random(min: CGFloat(1.2), max: CGFloat(2.2))
        default: print("No case matched for enemy speed calculation")
                 actualDuration = random(min: CGFloat(3.0), max: CGFloat(4.0))
        }
        
        
        // Create the actions for enemy ship
        let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() { [weak self] in
            guard let `self` = self else { return }
            self.mainDelegate.mainScore = self.enemyDestroyed
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            gameOverScene.gameVC2 = self.gameVC
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        enemy.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
    }
    
    //to shoot when the user clicks on the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        //run the shoot sound
        //used AVAudioPlayer as SKAction.playSound method didn't give volume option
        let soundURL = Bundle.main.path(forResource: "shootSound", ofType: "mp3")
        let url = URL(fileURLWithPath: soundURL!)
        soundPlayer = try! AVAudioPlayer.init(contentsOf: url)
        soundPlayer?.currentTime = 0
        soundPlayer?.volume = (mainDelegate.volumeLevel/100)
        soundPlayer?.play()
        
//      run(SKAction.playSoundFileNamed("shootSound.mp3", waitForCompletion: false))
        
        let touchLocation = touch.location(in: self)
        
        let projectile = SKSpriteNode(texture: SKTexture(imageNamed: "projectile.png"),size: CGSize(width: 30, height: 30))
        projectile.position = CGPoint(x: player.position.x + 40, y: player.position.y)
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        //Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        //dont't shoot if you are shooting down or backwards
        if offset.x < 0 { return }
        
        addChild(projectile)
        
        //Get the direction of where to shoot as a unit vector
        let direction = offset.normalized()
        
        //shootAmount is a vector with high magnitude to make sure bullet goes off screen
        let shootAmount = direction * 1000
        
        //Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        //Actions for projectile
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, enemy: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        enemy.removeFromParent()
        enemyDestroyed += 1
        lblScore.text = "Score:\(enemyDestroyed)"
        
        //Uncomment the code below to enable win scenario for game
//        if enemyDestroyed >= 8 {
//            mainDelegate.mainScore = enemyDestroyed
//            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//            let gameOverScene = GameOverScene(size: self.size, won: true)
//            gameOverScene.gameVC2 = gameVC
//            view?.presentScene(gameOverScene, transition: reveal)
//        }
    }
}

//to take care of the collisions of bulltet and the enemy ship
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.enemy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let enemy = firstBody.node as? SKSpriteNode,
                let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, enemy: enemy)
            }
        }
    }
}
