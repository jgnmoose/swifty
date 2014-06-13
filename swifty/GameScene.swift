//
//  GameScene.swift
//  swifty
//
//  Created by Jeremy Novak on 6/11/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import SpriteKit
import AVFoundation

var player:Player!
var ground:SKSpriteNode!
var retry:SKLabelNode!

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    
    var state:GameState = .Tutorial
    var pipeGap:CGFloat = 175.0
    
    override func didMoveToView(view: SKView) {
        viewSize = self.frame.size
        
        if kDebug {
            println("GameScene size: \(self.frame.size)")
        }
        
        self.physicsWorld.contactDelegate = self
        // No gravity at game start. Set in switchToPlay()
        self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 )
        
        state = GameState.Tutorial
        
        self.scene.userInteractionEnabled = false
        
        self.setupWorld()
        self.setupPlayer()
        self.runCountDown()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch:UITouch = touches.anyObject() as UITouch
        var touchLocation = touch.locationInNode(self)

        if self.scene.userInteractionEnabled {
            for touch:AnyObject in touches {
                switch state {
                case GameState.Tutorial:
                    self.switchToPlay()
                    
                case GameState.Play:
                    player.fly()
                    
                case GameState.GameOver:
                    if retry.containsPoint(touchLocation) {
                        self.switchToNewGame()
                    }
                    
                }
            }

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if self.scene.userInteractionEnabled {
            switch state {
            case GameState.Tutorial:
                self.switchToPlay()
                
            case GameState.Play:
                player.update()
                
            case GameState.GameOver:
                return
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var other:SKPhysicsBody = contact.bodyA.categoryBitMask == Contact.Player ? contact.bodyB : contact.bodyA
        
        if state == GameState.GameOver {
            return
        } else {
            if other.categoryBitMask == Contact.Scene {
                // Player hit the ground or edge of the scene
                if kDebug {
                    println("Player Hit Ground")
                }
                
                self.runAction(SKAction.playSoundFileNamed(kSoundBounce, waitForCompletion: false))
                
                self.switchToGameOver()
                
            } else if other.categoryBitMask == Contact.Object {
                // Playr hit some spikes
                if kDebug {
                    println("Player Hit Spikes")
                }
                
                self.runAction(SKAction.playSoundFileNamed(kSoundWhack, waitForCompletion: false))
                
                self.switchToGameOver()
            }
        }
    }
    
    // Setup functions
    func setupWorld () {
        // Sky
        self.backgroundColor = SKColor.whiteColor()
        
        // Moon
        let moon = SKSpriteNode(imageNamed: "moon")
        moon.anchorPoint = CGPointMake(0.5, 0.5)
        //moon.position = CGPointMake(viewSize.width * 0.3, viewSize.height * 0.85)
        moon.position = kMoonPosition
        moon.zPosition = GameLayer.Sky
        moon.name = kNameMoon
        self.addChild(moon)
        
        // Ground
        ground = SKSpriteNode(imageNamed: "ground")
        ground.anchorPoint = CGPointZero
        ground.position = CGPointZero
        ground.zPosition = GameLayer.Ground
        ground.name = kNameGround
        
        let groundCopy = SKSpriteNode(imageNamed: "ground")
        groundCopy.anchorPoint = CGPointZero
        groundCopy.position = CGPointMake(ground.size.width, 0)
        groundCopy.zPosition = GameLayer.Ground
        groundCopy.name = kNameGround
        ground.addChild(groundCopy)
        self.addChild(ground)
        
        // City
        let city = SKSpriteNode(imageNamed: "city")
        city.anchorPoint = CGPointZero
        city.position = CGPointMake(0, ground.size.height)
        city.zPosition = GameLayer.City
        city.name = kNameCity
        self.addChild(city)
        
        // Bounding box of playable area
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, ground.size.height, viewSize.width, (viewSize.height - ground.size.height)))
        self.physicsBody.categoryBitMask = Contact.Scene
    }
    
    func setupPlayer () {
        player = Player(imageNamed: "player0")
        player.anchorPoint = CGPointMake(0.5, 0.5)
        player.position = CGPointMake(viewSize.width * 0.3, viewSize.height * 0.5)
        player.zPosition = GameLayer.Game
        self.addChild(player)
    }
    
    
    // Play States
    func switchToPlay () {
        self.physicsWorld.gravity = CGVectorMake(0, -5.0)
        state = GameState.Play
        self.scene.userInteractionEnabled = true
        self.scrollForeground()
        self.startSpawningSpikes()
    }
    
    func switchToGameOver () {
        state = GameState.GameOver
        
        self.stopSpawningSpikes()
        self.stopScrollingForeground()
        
        self.runAction(SKAction.playSoundFileNamed(kSoundFalling, waitForCompletion: false))
        
        let gameOverLabel = SKLabelNode(fontNamed: kGameFont)
        gameOverLabel.text = "Game Over"
        gameOverLabel.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.7)
        gameOverLabel.zPosition = GameLayer.UI
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = SKColor.blackColor()
        gameOverLabel.setScale(0)
        gameOverLabel.name = kNameGameLabel
        self.addChild(gameOverLabel)
        
        gameOverLabel.runAction(SKAction.scaleTo(1.0, duration: 1.0))
        
        retry = SKLabelNode(fontNamed: kGameFont)
        retry.text = "Retry"
        retry.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.5)
        retry.zPosition = GameLayer.UI
        retry.fontSize = 60
        retry.fontColor = SKColor.blackColor()
        retry.name = kNameRetry
        self.addChild(retry)
    }
    
    func switchToNewGame () {
        let gameScene = GameScene(size: viewSize)
        gameScene.scaleMode = .AspectFill
        var gameTransition = SKTransition.fadeWithColor(SKColor.blackColor(), duration: 0.1)
        self.view.presentScene(gameScene, transition: gameTransition)
    }
    
    func runCountDown () {
        let tutorial = SKLabelNode(fontNamed: kGameFont)
        tutorial.text = "Tap to fly Swifty!"
        tutorial.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.7)
        tutorial.zPosition = GameLayer.UI
        tutorial.fontSize = 36
        tutorial.fontColor = SKColor.blackColor()
        tutorial.name = kNameTutorial
        self.addChild(tutorial)
        
        self.runAction(SKAction.waitForDuration(1.0), completion: {
            tutorial.removeFromParent()
            
            let count = SKLabelNode(fontNamed: kGameFont)
            count.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.6)
            count.zPosition = GameLayer.UI
            count.text = "3"
            count.fontSize = 72
            count.fontColor = SKColor.blackColor()
            count.name = kNameCount
            self.addChild(count)
            
            count.setScale(0)
            count.runAction(SKAction.scaleTo(1.0, duration: 1.0), completion:{
                count.text = "2"
                count.setScale(0)
                count.runAction(SKAction.scaleTo(1.0, duration: 1.0), completion: {
                    count.text = "1"
                    count.setScale(0)
                    count.runAction(SKAction.scaleTo(1.0, duration: 1.0), completion: {
                        count.text = "Go!"
                        count.setScale(0)
                        count.runAction(SKAction.scaleTo(1.0, duration: 1.0), completion: {
                            count.removeFromParent()
                            self.switchToPlay()
                            })
                        })
                    })
                })
        })
    }
    
    // Scrolling
    func scrollForeground () {
        self.enumerateChildNodesWithName(kNameGround, usingBlock: { node, stop in
            let moveLeft = SKAction.moveByX(-ground.frame.size.width, y: 0, duration: 3.0)
            let reset = SKAction.moveTo(CGPointMake(0, 0), duration: 0)
            let sequence = SKAction.sequence([moveLeft, reset])
            node.runAction(SKAction.repeatActionForever(sequence))
        })
    }
    
    func stopScrollingForeground () {
        self.enumerateChildNodesWithName(kNameGround, usingBlock: { node, stop in
            node.removeAllActions()
        })
    }
    
    // Obstacles
    func createSpike (type: String) -> SKSpriteNode {
        var spike:SKSpriteNode!
        
        switch type {
            case "top":
                spike = SKSpriteNode(imageNamed: "spiketop")
                spike.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "spiketop"), size: spike.frame.size)
            case "bottom":
                spike = SKSpriteNode(imageNamed: "spikebottom")
                spike.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "spikebottom"), size: spike.frame.size)
            default:
                spike = SKSpriteNode(imageNamed: "spikebottom")
                spike.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "spikebottom"), size: spike.frame.size)
        }
        
        spike.zPosition = GameLayer.Spikes
        
        //spike.physicsBody = SKPhysicsBody(rectangleOfSize: spike.size)
        spike.physicsBody.dynamic = false
        spike.physicsBody.categoryBitMask = Contact.Object
        spike.physicsBody.contactTestBitMask = Contact.Player
        
        return spike
    }
    
    func spawnSpikes () {
        // Bottom spike
        var bottomSpike = self.createSpike("bottom")
        bottomSpike.name = "BottomSpike"
        var startX = viewSize.width + bottomSpike.size.width / 2
        
        var bottomHeight = UInt32(viewSize.height / 4)
        var bottomY = arc4random() % bottomHeight + bottomHeight
        
        bottomSpike.position = CGPointMake(startX, CGFloat(bottomHeight))
        
        self.addChild(bottomSpike)
        
        
        // Top spike
        var topSpike = self.createSpike("top")
        topSpike.name = "TopSpike"
        topSpike.position = CGPointMake(startX, CGFloat(bottomHeight) + topSpike.size.height + pipeGap)
        
        self.addChild(topSpike)
        
        //var moveX = -viewSize.width + bottomSpike.size.width
        //var moveDuration = moveX / kGroundSpeed
        
        var scroll = SKAction.moveToX(0 - bottomSpike.size.width, duration: 3.0)
        var remove = SKAction.removeFromParent()
        var sequence = SKAction.sequence([scroll, remove])
        
        bottomSpike.runAction(sequence)
        topSpike.runAction(sequence)
    }
    
    func startSpawningSpikes () {
        var delay = SKAction.waitForDuration(1.5)
        var spawn = SKAction.runBlock({
            self.spawnSpikes()
        })
        var sequence = SKAction.sequence([delay, spawn])
        var repeat = SKAction.repeatActionForever(sequence)
        var spawnSequence = SKAction.sequence([delay, repeat])
        
        self.runAction(spawnSequence, withKey: "Spawn")
    }
    
    func stopSpawningSpikes () {
        self.removeActionForKey("Spawn")
        
        self.enumerateChildNodesWithName("TopSpike", usingBlock: { node, stop in
            node.removeAllActions()
        })
        
        self.enumerateChildNodesWithName("BottomSpike", usingBlock: { node, stop in
            node.removeAllActions()
        })
    }
    
    func flashBackground () {
    }
}
