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

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    
    // Build errors with this declared here...
    //var player:Player!
    
    override func didMoveToView(view: SKView) {
        viewSize = self.frame.size
        
        if kDebug {
            println("GameScene size: \(self.frame.size)")
        }
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        
        self.setupWorld()
        self.setupPlayer()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            player.fly()
        }

    }
   
    override func update(currentTime: CFTimeInterval) {
        player.update()
    }
    
    func setupWorld () {
        var viewSize = self.frame.size
        
        // Sky
        self.backgroundColor = SKColor.whiteColor()
        
        // Clouds
        let clouds = SKSpriteNode(imageNamed: "cloudmonster")
        clouds.anchorPoint = CGPointMake(0.5, 0.5)
        clouds.position = CGPointMake(viewSize.width * 0.8, viewSize.height * 0.8)
        clouds.zPosition = GameLayer.Sky
        self.addChild(clouds)
        
        // Moon
        let moon = SKSpriteNode(imageNamed: "moon")
        moon.anchorPoint = CGPointMake(0.5, 0.5)
        moon.position = CGPointMake(viewSize.width * 0.3, viewSize.height * 0.85)
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
    
    func flashBackground () {
    }
}
