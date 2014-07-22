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
    
    let textures = GameTexturesSharedInstance
    let sounds = GameSoundsSharedInstance
    
    init(size: CGSize) {
        super.init(size: size)
    }
  
    override func didMoveToView(view: SKView) {
        viewSize = self.frame.size
        
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
        let moon = SKSpriteNode(texture: textures.texMoon)
        moon.position = kMoonPosition
        moon.zPosition = GameLayer.Sky
        moon.name = kNameMoon
        self.addChild(moon)
        
        // Ground
        let ground = SKSpriteNode(texture: textures.texGround)
        ground.anchorPoint = CGPointZero
        ground.position = CGPointZero
        ground.zPosition = GameLayer.Ground
        ground.name = kNameGround
        self.addChild(ground)
        
        // City Back
        let cityBack = SKSpriteNode(texture: textures.texCityBack)
        cityBack.anchorPoint = CGPointZero
        cityBack.position = CGPoint(x: 0, y: ground.size.height)
        cityBack.zPosition = GameLayer.CityBack
        cityBack.name = kNameCity
        self.addChild(cityBack)
        
        // City Front
        let cityFront = SKSpriteNode(texture: textures.texCityFront)
        cityFront.anchorPoint = CGPointZero
        cityFront.position = CGPoint(x: 0, y: ground.size.height)
        cityFront.zPosition = GameLayer.CityFront
        cityFront.name = kNameCity
        self.addChild(cityFront)
        
        // Character
        let character = SKSpriteNode(texture: textures.texPlayer0)
        character.position = CGPoint(x: viewSize.width / 2, y: viewSize.height / 2)
        character.zRotation = 0
        character.zPosition = GameLayer.Game
        character.setScale(2.0)
        character.name = kNamePlayer
        self.addChild(character)
        
        // Game Label
        let gameLabel = SKLabelNode(fontNamed: kGameFont)
        gameLabel.text = "Swifty"
        gameLabel.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.65)
        gameLabel.fontSize = 96
        gameLabel.fontColor = kFontColor
        gameLabel.zPosition = GameLayer.UI
        gameLabel.name = kNameGameLabel
        self.addChild(gameLabel)
        
        // Play Button
        playButton = SKLabelNode(fontNamed: kGameFont)
        playButton.text = "Play"
        playButton.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.3)
        playButton.fontSize = 72
        playButton.fontColor = kFontColor
        playButton.zPosition = GameLayer.UI
        playButton.name = kNamePlayButton
        self.addChild(playButton)
    }
    
    func animatePlay () {
        let bounceLarger = SKAction.scaleTo(1.25, duration: 0.15)
        let bounceNormal = SKAction.scaleTo(1.0, duration: 0.15)
        let bounceSequence = SKAction.sequence([bounceLarger, sounds.pop, bounceNormal])
        playButton.runAction(SKAction.repeatAction(bounceSequence, count: 3))
    }
    
    func switchToPlay () {
        self.runAction(sounds.pop)
        
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