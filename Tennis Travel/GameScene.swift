//
//  GameScene.swift
//  Tennis Travel
//
//  Created by Sephiroth Rivera on 6/29/17.
//  Copyright © 2017 Sephiroth Rivera. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
  var randomizer = SKSpriteNode(imageNamed: "Cartoon\(arc4random_uniform(4))")
    var tennisPlayerArray = [#imageLiteral(resourceName: "Cartoon Man"), #imageLiteral(resourceName: "Cartoon Alien"), #imageLiteral(resourceName: "Cartoon Penguin"), #imageLiteral(resourceName: "Cartoon Flower")]
    var tennisBall = SKShapeNode()
    var tennisRacket1 = SKSpriteNode()
    var tennisRacket2 = SKSpriteNode()
    var loseZone = SKSpriteNode()
    var loseZone2 = SKSpriteNode()
    var scoreBoard = SKLabelNode(fontNamed: "Arial")
    var scoreBoard2 = SKLabelNode(fontNamed: "Arial")
    var topPlayerScore = 0
    var bottomPlayerScore = 0
    var bottomPlayerScoreText = "0"
    var topPlayerScoreText = "0"
    var game = 1
    var topPlayerScoreBoard = SKLabelNode(fontNamed: "Arial")
    var bottomPlayerScoreBoard = SKLabelNode(fontNamed: "Arial")
    var topPlayerGamesWon = 0
    var bottomPlayerGamesWon = 0
    var startOver = false
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        createBackground()
        makeTennisBall()
        makeRacket1()
        makeRacket2()
        makeLoseZone()
        makeLoseZone2()
        makeScoreBoard()
        makeScoreBoard2()
        makeTopPlayerScoreBoard()
        makeBottomPlayerScoreBoard()
        self.view?.isPaused = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            if self.view?.isPaused == true || startOver == true
            {
                if startOver == true
                {
                    makeTennisBall()
                    resetGame()
                }
                tennisBall.position = CGPoint(x: frame.midX, y: frame.midY)
                self.view?.isPaused = false
                startOver = false
                bottomPlayerScoreText = "0"
                topPlayerScoreText = "0"
                scoreBoard2.text = "Score: \(bottomPlayerScoreText)"
                scoreBoard.text = "Score: \(topPlayerScoreText)"
                
                
                if loseZone2.contains(location)
                {
                    tennisRacket1.position.x = location.x
                    tennisBall.physicsBody?.isDynamic = true
                    tennisBall.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
                }
                
                if loseZone.contains(location)
                {
                    tennisRacket2.position.x = location.x
                    tennisBall.physicsBody?.isDynamic = true
                    tennisBall.physicsBody?.applyImpulse(CGVector(dx: -5, dy: -5))
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            if loseZone2.contains(location)
            {
                tennisRacket1.position.x = location.x
            }
            if loseZone.contains(location)
            {
                tennisRacket2.position.x = location.x
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        let bodyAName = contact.bodyA.node?.name
        let bodyBName = contact.bodyB.node?.name
        if (bodyAName == "tennisBall" && bodyBName == "loseZone") || (bodyAName == "loseZone" && bodyBName == "tennisBall")
        {
            bottomPlayerScore += 1
            if bottomPlayerScore == 1
            {
                if topPlayerScore == 0
                {
                    topPlayerScoreText = "0"
                    bottomPlayerScoreText = "15"
                } else
                {
                    bottomPlayerScoreText = "15"
                }
            }
            if bottomPlayerScore == 2
            {
                bottomPlayerScoreText = "30"
            }
            if bottomPlayerScore == 3
            {
                bottomPlayerScoreText = "40"
            }
            if bottomPlayerScore >= 4 && bottomPlayerScore == topPlayerScore
            {
                bottomPlayerScoreText = "Deuce"
                topPlayerScoreText = "Deuce"
            }
            if bottomPlayerScore >= 4 && bottomPlayerScore > topPlayerScore
            {
                bottomPlayerScoreText = "Advantage"
                topPlayerScoreText = " -- "
            }
            if bottomPlayerScore >= 4 && bottomPlayerScore > (topPlayerScore + 1)
            {
                bottomPlayerScoreText = "WON GAME \(game)!!!"
                game += 1
                bottomPlayerGamesWon += 1
                bottomPlayerScoreBoard.text = "Player 2: " + String(bottomPlayerGamesWon)
                if bottomPlayerGamesWon >= 6 && (bottomPlayerGamesWon == 7 || bottomPlayerGamesWon - 1 > topPlayerGamesWon) {
//                  WINNING ROUTINE!!!
                    run(SKAction.playSoundFileNamed("winning.wav", waitForCompletion: true))
                    tennisBall.removeFromParent()
//                  resetGame()
                    startOver = true
                }
                bottomPlayerScore = 0
                topPlayerScore = 0
                run(SKAction.playSoundFileNamed("tada.mp3", waitForCompletion: true))
                //self.view?.isPaused = true
            }
            if startOver == true
            {
                scoreBoard.text = "Player 2 Has Won the Set!!!"
                scoreBoard2.text = "Click to Reset Game and Start Over"
            } else
            {
                scoreBoard2.text = "Score: \(bottomPlayerScoreText)"
                scoreBoard.text = "Score: \(topPlayerScoreText)"
                run(SKAction.playSoundFileNamed("miss.wav", waitForCompletion: false))
            }
        }
        if (bodyAName == "tennisBall" && bodyBName == "loseZone2") || (bodyAName == "loseZone2" && bodyBName == "tennisBall")
        {
            topPlayerScore += 1
            if topPlayerScore == 1
            {
                if bottomPlayerScore == 0
                {
                    bottomPlayerScoreText = "0"
                    topPlayerScoreText = "15"
                } else
                {
                    topPlayerScoreText = "15"
                }
            }
            if topPlayerScore == 2
            {
                topPlayerScoreText = "30"
            }
            if topPlayerScore == 3
            {
                topPlayerScoreText = "40"
            }
            if topPlayerScore >= 4 && bottomPlayerScore == topPlayerScore
            {
                bottomPlayerScoreText = "Deuce"
                topPlayerScoreText = "Deuce"
            }
            if topPlayerScore >= 4 && topPlayerScore > bottomPlayerScore
            {
                topPlayerScoreText = "Advantage"
                bottomPlayerScoreText = " -- "
            }
            if topPlayerScore >= 4 && topPlayerScore > (bottomPlayerScore + 1)
            {
                topPlayerScoreText = "WON GAME \(game)!!!"
                game += 1
                topPlayerGamesWon += 1
                topPlayerScoreBoard.text = "Player 1: " + String(topPlayerGamesWon)
                if topPlayerGamesWon >= 6 && (topPlayerGamesWon == 7 || topPlayerGamesWon - 1 > bottomPlayerGamesWon) {
//                  WINNING ROUTINE!!!
                    run(SKAction.playSoundFileNamed("winning.wav", waitForCompletion: true))
                    tennisBall.removeFromParent()
//                  resetGame()
                    startOver = true
                }
                topPlayerScore = 0
                bottomPlayerScore = 0
                run(SKAction.playSoundFileNamed("tada.mp3", waitForCompletion: true))
                //self.view?.isPaused = true
            }
            if startOver == true
            {
                scoreBoard.text = "Player 1 Has Won the Set!!!"
                scoreBoard2.text = "Click to Reset Game and Start Over"
            } else {
                scoreBoard.text = "Score: \(topPlayerScoreText)"
                scoreBoard2.text = "Score: \(bottomPlayerScoreText)"
                run(SKAction.playSoundFileNamed("miss.wav", waitForCompletion: false))
            }
        }
        if (bodyAName == "tennisRacket1" || bodyBName == "tennisRacket1") || (bodyAName == "tennisRacket2" || bodyBName == "tennisRacket2")
        {
            if topPlayerScoreText == "WON GAME \(game - 1)!!!" || bottomPlayerScoreText == "WON GAME \(game - 1)!!!"
            {
                topPlayerScoreText = "0"
                bottomPlayerScoreText = "0"
                scoreBoard.text = "Score: \(topPlayerScoreText)"
                scoreBoard2.text = "Score: \(bottomPlayerScoreText)"
            }
            run(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false))
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        let maxSpeed: CGFloat = 400.0
        
        let xSpeed = sqrt(tennisBall.physicsBody!.velocity.dx * tennisBall.physicsBody!.velocity.dx)
        let ySpeed = sqrt(tennisBall.physicsBody!.velocity.dy * tennisBall.physicsBody!.velocity.dy)
        
        let speed = sqrt(tennisBall.physicsBody!.velocity.dx * tennisBall.physicsBody!.velocity.dx + tennisBall.physicsBody!.velocity.dy * tennisBall.physicsBody!.velocity.dy)
        
        if xSpeed <= 10.0
        {
            tennisBall.physicsBody!.applyImpulse(CGVector(dx: 5.0, dy: 0.0))
        }
        if ySpeed <= 10.0
        {
            tennisBall.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 5.0))
        }
        
        if speed > maxSpeed
        {
            tennisBall.physicsBody!.linearDamping = 0.4
        }
        else
        {
            tennisBall.physicsBody!.linearDamping = 0.0
        }
    }
    
    func createBackground()
    {
        let tennisCourt = SKTexture(imageNamed: "court")
        let tennisCourtBackground = SKSpriteNode(texture: tennisCourt)
        tennisCourtBackground.zPosition = -1
        tennisCourtBackground.position = CGPoint(x: 0, y: 0)
        tennisCourtBackground.setScale(1.45)
        addChild(tennisCourtBackground)
    }
    
    func makeTennisBall()
    {
        tennisBall = SKShapeNode(circleOfRadius: 10)
        tennisBall.position = CGPoint(x: frame.midX, y: frame.midY)
        tennisBall.strokeColor = UIColor.white
        tennisBall.fillColor = UIColor.green
        tennisBall.name = "tennisBall"
        tennisBall.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        tennisBall.physicsBody?.isDynamic = false   //ignores all forces and impulses
        tennisBall.physicsBody?.usesPreciseCollisionDetection = true
        tennisBall.physicsBody?.friction = 0
        tennisBall.physicsBody?.affectedByGravity = false
        tennisBall.physicsBody?.restitution = 1
        tennisBall.physicsBody?.angularDamping = 0
        tennisBall.physicsBody?.linearDamping = 0
        tennisBall.physicsBody?.contactTestBitMask = (tennisBall.physicsBody?.collisionBitMask)!
        tennisBall.physicsBody?.velocity = CGVector(dx: 20, dy: 20)   // sets the ball speed to a lower speed initially
        addChild(tennisBall)
    }
    
    func makeRacket1()
    {
        tennisRacket1 = SKSpriteNode(color: UIColor.blue, size: CGSize(width: frame.width/4, height: 10))
        tennisRacket1.position = CGPoint(x: frame.minX, y: frame.minY + 80)
        tennisRacket1.name = "tennisRacket1"
        tennisRacket1.physicsBody = SKPhysicsBody(rectangleOf: tennisRacket1.size)
        tennisRacket1.physicsBody?.isDynamic = false
        addChild(tennisRacket1)
    }
    
    func makeRacket2()
    {
        tennisRacket2 = SKSpriteNode(color: UIColor.blue, size: CGSize(width: frame.width/4, height: 10))
        tennisRacket2.position = CGPoint(x: frame.minX, y: frame.maxY - 80)   // moved to maxY - 125 to move higher on screen
        tennisRacket2.name = "tennisRacket2"
        tennisRacket2.physicsBody = SKPhysicsBody(rectangleOf: tennisRacket2.size)
        tennisRacket2.physicsBody?.isDynamic = false
        addChild(tennisRacket2)
    }
    
    func makeLoseZone()
    {
        loseZone = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 840, height: 140))   // made width 840 to fill screen
        loseZone.position = CGPoint(x: frame.minX, y: frame.maxY)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    func makeLoseZone2()
    {
        loseZone2 = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 840, height: 140))   // made width 840 to fill screen
        loseZone2.position = CGPoint(x: frame.maxX, y: frame.minY)
        loseZone2.name = "loseZone2"
        loseZone2.physicsBody = SKPhysicsBody(rectangleOf: loseZone2.size)
        loseZone2.physicsBody?.isDynamic = false
        addChild(loseZone2)
    }
    
    func makeScoreBoard()
    {
        scoreBoard.fontSize = 20
        scoreBoard.fontColor = SKColor.blue
        scoreBoard.position = CGPoint(x: frame.midX, y: frame.maxY - 30)
        scoreBoard.text = "Score: " + String(topPlayerScore)
        addChild(scoreBoard)
    }
    
    func makeScoreBoard2()
    {
        scoreBoard2.fontSize = 20
        scoreBoard2.fontColor = SKColor.blue
        scoreBoard2.position = CGPoint(x: frame.midX, y: frame.minY + 10)
        scoreBoard2.text = "Score: " + String(bottomPlayerScore)
        addChild(scoreBoard2)
    }
    
    func makeTopPlayerScoreBoard()
    {
        topPlayerScoreBoard.fontSize = 15
        topPlayerScoreBoard.fontColor = SKColor.red
        topPlayerScoreBoard.position = CGPoint(x: frame.minX + 45, y: frame.maxY - 30)
        topPlayerScoreBoard.text = "Player 1: " + String(topPlayerGamesWon)
        addChild(topPlayerScoreBoard)
    }
    
    func makeBottomPlayerScoreBoard()
    {
        bottomPlayerScoreBoard.fontSize = 15
        bottomPlayerScoreBoard.fontColor = SKColor.red
        bottomPlayerScoreBoard.position = CGPoint(x: frame.minX + 45, y: frame.maxY - 50)
        bottomPlayerScoreBoard.text = "Player 2: " + String(bottomPlayerGamesWon)
        addChild(bottomPlayerScoreBoard)
    }
    
    func resetGame()
    {
        topPlayerScore = 0
        bottomPlayerScore = 0
        bottomPlayerScoreText = "0"
        topPlayerScoreText = "0"
        game = 1
        topPlayerGamesWon = 0
        bottomPlayerGamesWon = 0
        scoreBoard2.text = "Score: \(bottomPlayerScoreText)"
        scoreBoard.text = "Score: \(topPlayerScoreText)"
        bottomPlayerScoreBoard.text = "Player 2: " + String(bottomPlayerGamesWon)
        topPlayerScoreBoard.text = "Player 1: " + String(topPlayerGamesWon)
    }
    
   func randomImage()
    {
        let image: NSArray = [UIImage(named: "Cartoon Man")!, UIImage(named: "Cartoon Alien")!, UIImage(named: "Cartoon Flower")!, UIImage(named: "Cartoon Penguin")!]
        
        let imageRange: UInt32 = UInt32(image.count)
        
        let randomImage = Int(arc4random_uniform(imageRange))
        
        let generatedImage = image[randomImage]
    }
}

