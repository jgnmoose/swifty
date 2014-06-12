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
var touchEnabled:Bool!

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    
    var state:GameState = .Tutorial
    
    override func didMoveToView(view: SKView) {
        viewSize = self.frame.size
        
        if kDebug {
            println("GameScene size: \(self.frame.size)")
        }
        
        self.physicsWorld.contactDelegate = self
        // No gravity at game start. Set to 5 in switchToPlay()
        self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 )
        
        state = GameState.Tutorial
        
        self.scene.userInteractionEnabled = false
        
        self.setupWorld()
        self.setupPlayer()
        self.runCountDown()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if self.scene.userInteractionEnabled {
            for touch:AnyObject in touches {
                switch state {
                case GameState.Tutorial:
                    self.switchToPlay()
                    if kDebug {
                        println("Tutorial Touch")
                    }
                case GameState.Play:
                    player.fly()
                    if kDebug {
                        println("Play Touch")
                    }
                case GameState.GameOver:
                    println("Game Over")
                    if kDebug {
                        println("Game Over Touch")
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
                println("Game Over")
            }
        }
    }
    
    func setupWorld () {
        var viewSize = self.frame.size
        
        // Sky
        self.backgroundColor = SKColor.whiteColor()
        
        // Clouds
        let clouds = SKSpriteNode(imageNamed: "cloudmonster")
        clouds.anchorPoint = CGPointMake(0.5, 0.5)
        //clouds.position = CGPointMake(viewSize.width * 0.8, viewSize.height * 0.8)
        clouds.position = kCloudPosition
        clouds.zPosition = GameLayer.Sky
        self.addChild(clouds)
        
        // Moon
        let moon = SKSpriteNode(imageNamed: "moon")
        moon.anchorPoint = CGPointMake(0.5, 0.5)
        //moon.position = CGPointMake(viewSize.width * 0.3, viewSize.height * 0.85)
        moon.position = kMoonPosition
        moon.zPosition = GameLayer.Sky
        self.addChild(moon)
        
        // Ground
        ground = SKSpriteNode(imageNamed: "ground")
        ground.anchorPoint = CGPointZero
        ground.position = CGPointZero
        ground.zPosition = GameLayer.Ground
        self.addChild(ground)
        
        // City
        let city = SKSpriteNode(imageNamed: "city")
        city.anchorPoint = CGPointZero
        city.position = CGPointMake(0, ground.position.y)
        city.zPosition = GameLayer.City
        self.addChild(city)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, ground.size.height, viewSize.width, (viewSize.height - ground.size.height)))
    }
    
    func setupPlayer () {
        player = Player(imageNamed: "player0")
        player.anchorPoint = CGPointMake(0.5, 0.5)
        player.position = CGPointMake(viewSize.width * 0.3, viewSize.height * 0.5)
        player.zPosition = GameLayer.Game
        self.addChild(player)
    }
    
    func switchToPlay () {
        self.physicsWorld.gravity = CGVectorMake(0, -5.0)
        state = GameState.Play
        self.scene.userInteractionEnabled = true
    }
    
    func runCountDown () {
        var tutorial = SKLabelNode(fontNamed: kGameFont)
        tutorial.text = "Tap to fly Swifty!"
        tutorial.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.7)
        tutorial.zPosition = GameLayer.UI
        tutorial.fontSize = 36
        tutorial.fontColor = SKColor.blackColor()
        self.addChild(tutorial)
        
        self.runAction(SKAction.waitForDuration(1.0), completion: {
            tutorial.removeFromParent()
            
            var count = SKLabelNode(fontNamed: kGameFont)
            count.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.6)
            count.zPosition = GameLayer.UI
            count.text = "3"
            count.fontSize = 72
            count.fontColor = SKColor.blackColor()
            count.name = "Count"
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
    
    func flashBackground () {
    }
}
