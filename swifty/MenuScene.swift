//
//  MenuScene.swift
//  swifty
//
//  Created by Jeremy Novak on 6/11/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene {
    
    var playButton:SKLabelNode!
    var bounceTimer:NSTimer!
  
    override func didMoveToView(view: SKView) {
        viewSize = self.frame.size
        
        if kDebug {
            println("MenuScene size: \(viewSize)")
        }
        
        self.setupMenu()

        bounceTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("animatePlay"), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch:UITouch = touches.anyObject() as UITouch
        var touchLocation = touch.locationInNode(self)
        
        if (playButton.containsPoint(touchLocation)) {
            self.switchToPlay()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
    
    func setupMenu () {
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
        moon.position = CGPointMake(viewSize.width * 0.3, viewSize.height * 0.7)
        moon.zPosition = GameLayer.Sky
        self.addChild(moon)
        
        // Ground
        let ground = SKSpriteNode(imageNamed: "ground")
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
        
        // Game Label
        let gameLabel = SKLabelNode(fontNamed: kGameFont)
        gameLabel.text = "Swifty"
        gameLabel.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.65)
        gameLabel.fontSize = 64
        gameLabel.fontColor = SKColor.blackColor()
        gameLabel.zPosition = GameLayer.UI
        self.addChild(gameLabel)
        
        // Play Button
        playButton = SKLabelNode(fontNamed: kGameFont)
        playButton.text = "Play"
        playButton.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.45)
        playButton.fontSize = 48
        playButton.fontColor = SKColor.blackColor()
        playButton.zPosition = GameLayer.UI
        self.addChild(playButton)
    }
    
    func animatePlay () {
        var bounceLarger = SKAction.scaleTo(1.25, duration: 0.25)
        var bounceNormal = SKAction.scaleTo(1.0, duration: 0.25)
        var bounceSound = SKAction.playSoundFileNamed(kSoundPop, waitForCompletion: false)
        var bounceSequence = SKAction.sequence([bounceLarger, bounceSound, bounceNormal])
        playButton.runAction(SKAction.repeatAction(bounceSequence, count: 3))
    }
    
    func switchToPlay () {
        self.runAction(SKAction.playSoundFileNamed(kSoundPop, waitForCompletion: false))
        
        bounceTimer.invalidate()
        
        var gameScene = GameScene(size: viewSize)
        gameScene.scaleMode = .AspectFill
        var gameTransition = SKTransition.fadeWithColor(SKColor.blackColor(), duration: 0.1)
        self.view.presentScene(gameScene, transition: gameTransition)
    }
}