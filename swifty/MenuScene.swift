//
//  MenuScene.swift
//  swifty
//
//  Created by Jeremy Novak on 6/11/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene, AVAudioPlayerDelegate {
    
    var playButton:SKLabelNode!
    var bounceTimer:NSTimer!
  
    override func didMoveToView(view: SKView) {
        viewSize = self.frame.size
        
        if kDebug {
            println("MenuScene size: \(viewSize)")
        }
        
        self.setupMenu()
        
        self.playBackgrounMusic(kMusicGame, fileType: kMusicType)

        bounceTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("animatePlay"), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch:UITouch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        
        if (playButton.containsPoint(touchLocation)) {
            self.switchToPlay()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
    
    // Setup Methods
    func setupMenu () {
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
        let ground = SKSpriteNode(imageNamed: "ground")
        ground.anchorPoint = CGPointZero
        ground.position = CGPointZero
        ground.zPosition = GameLayer.Ground
        ground.name = kNameGround
        self.addChild(ground)
        
        // City
        let city = SKSpriteNode(imageNamed: "city")
        city.anchorPoint = CGPointZero
        city.position = CGPointMake(0, ground.size.height)
        city.zPosition = GameLayer.City
        city.name = kNameCity
        self.addChild(city)
        
        // Game Label
        let gameLabel = SKLabelNode(fontNamed: kGameFont)
        gameLabel.text = "Swifty"
        gameLabel.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.65)
        gameLabel.fontSize = 64
        gameLabel.fontColor = SKColor.blackColor()
        gameLabel.zPosition = GameLayer.UI
        gameLabel.name = kNameGameLabel
        self.addChild(gameLabel)
        
        // Play Button
        playButton = SKLabelNode(fontNamed: kGameFont)
        playButton.text = "Play"
        playButton.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.45)
        playButton.fontSize = 48
        playButton.fontColor = SKColor.blackColor()
        playButton.zPosition = GameLayer.UI
        playButton.name = kNamePlayButton
        self.addChild(playButton)
    }
    
    func animatePlay () {
        let bounceLarger = SKAction.scaleTo(1.25, duration: 0.15)
        let bounceNormal = SKAction.scaleTo(1.0, duration: 0.15)
        let bounceSound = SKAction.playSoundFileNamed(kSoundPop, waitForCompletion: false)
        let bounceSequence = SKAction.sequence([bounceLarger, bounceSound, bounceNormal])
        playButton.runAction(SKAction.repeatAction(bounceSequence, count: 3))
    }
    
    func switchToPlay () {
        self.runAction(SKAction.playSoundFileNamed(kSoundPop, waitForCompletion: false))
        
        bounceTimer.invalidate()
        
        let gameScene = GameScene(size: viewSize)
        gameScene.scaleMode = .AspectFill
        let gameTransition = SKTransition.fadeWithColor(SKColor.blackColor(), duration: 0.1)
        self.view.presentScene(gameScene, transition: gameTransition)
    }
    
    // Sound Methods
    func playBackgrounMusic(fileName: String, fileType: String) {
        let gameMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: fileType))
        var playerError:NSError?
        musicPlayer = AVAudioPlayer(contentsOfURL: gameMusic, error: &playerError)
        musicPlayer.delegate = self
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = 0.75
        musicPlayer.prepareToPlay()
        musicPlayer.play()
    }

}