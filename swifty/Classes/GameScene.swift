//
//  GameScene.swift
//  swifty
//
//  Created by Jeremy Novak on 6/11/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

/*****************************************************************************
    Using the iCloud code in this project requires some additional steps.

    More information provided in the official doc here:
    https://developer.apple.com/library/ios/documentation/General/Conceptual/iCloudDesignGuide/Chapters/Introduction.html
 ******************************************************************************/

import SpriteKit
import AVFoundation

var player:Player!

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    
    // Game Basics
    var state:GameState = GameState.Tutorial
    let textures = GameTexturesSharedInstance
    let sounds = GameSoundsSharedInstance
    
    // Scoring
    var score = 0
    let keyBestScore = "BestScore"
    
    // Class Nodes
    var worldNode = SKNode()
    var cityFar = SKNode()
    var cityNear = SKNode()
    var ground = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var retry = SKLabelNode()
    let spike = Spike()
    
    // Scrolling speeds
    let cityFarSpeed = 7.0
    let cityNearSpeed = 6.0
    let foregroundSpeed = 3.0
    
    // Defaults
    let defaults = NSUserDefaults.standardUserDefaults()
    // Uncomment for sync with iCloud
    //let iCloud = NSUbiquitousKeyValueStore.defaultStore()
    
    override func didMoveToView(view: SKView) {
        viewSize = self.frame.size
        
        self.physicsWorld.contactDelegate = self
        
        // No gravity at game start. Set in switchToPlay()
        self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 )
        
        state = GameState.Tutorial
        
        self.scene.userInteractionEnabled = false
        
        self.setupData()
        self.setupWorld()
        self.setupPlayer()
        self.runCountDown()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch:UITouch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)

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
        if state == GameState.GameOver || state == GameState.Tutorial {
            return
        } else {
            var other:SKPhysicsBody = contact.bodyA.categoryBitMask == Contact.Player ? contact.bodyB : contact.bodyA
            
            if other.categoryBitMask == Contact.Scene {
                self.runAction(sounds.bounce)
                self.runAction(sounds.hitGround)
                
                self.switchToGameOver()
                
            } else if other.categoryBitMask == Contact.Object {
                self.runAction(sounds.whack)
                
                self.switchToGameOver()
                
            } else if other.categoryBitMask == Contact.Score {
                self.updateScore()
            }
        }
    }
    
    func setupData () {
        // Uncomment for sync with iCloud
        
        // Compare the local and cloud values to resolve if different.
        //let localScore = defaults.integerForKey(keyBestScore)
        //let cloudScore = Int(iCloud.valueForKey(keyBestScore) as NSNumber)
        
        //if localScore == cloudScore {
        //    return
        //} else {
        //    iCloud.setValue(localScore, forKey: keyBestScore)
        //}
    }
    
    // Setup functions
    func setupWorld() {
        self.addChild(worldNode)
        
        // Sky
        self.backgroundColor = SKColor.whiteColor()
        
        // Moon
        let moon = SKSpriteNode(texture: textures.texMoon)
        moon.position = kMoonPosition
        moon.zPosition = GameLayer.Sky
        moon.name = kNameMoon
        worldNode.addChild(moon)
        
        // Ground
        ground = SKSpriteNode(texture: textures.texGround)
        ground.anchorPoint = CGPointZero
        ground.position = CGPointZero
        ground.zPosition = GameLayer.Ground
        ground.name = kNameGround
        
        let groundCopy = SKSpriteNode(texture: textures.texGround)
        groundCopy.anchorPoint = CGPointZero
        groundCopy.position = CGPoint(x: ground.size.width, y: 0)
        groundCopy.zPosition = ground.zPosition
        groundCopy.name = kNameGround
        ground.addChild(groundCopy)
        worldNode.addChild(ground)
        
        
        // City Back
        cityFar.position = CGPointZero
        cityFar.name = kNameCityFar
        
        let cityBack = SKSpriteNode(texture: textures.texCityBack)
        cityBack.anchorPoint = CGPointZero
        cityBack.position = CGPoint(x: 0, y: ground.size.height)
        cityBack.zPosition = GameLayer.CityBack
        cityBack.name = kNameCityFar
        cityFar.addChild(cityBack)
        
        let cityBackCopy = SKSpriteNode(texture: cityBack.texture)
        cityBackCopy.anchorPoint = CGPointZero
        cityBackCopy.position = CGPoint(x: cityBack.size.width, y: cityBack.position.y)
        cityBackCopy.zPosition = GameLayer.CityBack
        cityBackCopy.name = kNameCityFar
        cityFar.addChild(cityBackCopy)
        worldNode.addChild(cityFar)
        
        // City Front
        cityNear.position = CGPointZero
        cityNear.name = kNameCityNear
        
        let cityFront = SKSpriteNode(texture: textures.texCityFront)
        cityFront.anchorPoint = CGPointZero
        cityFront.position = CGPoint(x: 0, y: ground.size.height)
        cityFront.zPosition = GameLayer.CityFront
        cityFront.name = kNameCityNear
        cityNear.addChild(cityFront)
        
        let cityFrontCopy = SKSpriteNode(texture: cityFront.texture)
        cityFrontCopy.anchorPoint = CGPointZero
        cityFrontCopy.position = CGPoint(x: cityFront.size.width, y: cityFront.position.y)
        cityFrontCopy.zPosition = GameLayer.CityFront
        cityFrontCopy.name = kNameCityNear
        cityNear.addChild(cityFrontCopy)
        worldNode.addChild(cityNear)
        
        // Score Label
        scoreLabel = SKLabelNode(fontNamed: kGameFont)
        scoreLabel.text = String(score)
        scoreLabel.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.8)
        scoreLabel.fontColor = kFontColor
        scoreLabel.fontSize = 60
        scoreLabel.name = kNameScoreLabel
        scoreLabel.hidden = true
        worldNode.addChild(scoreLabel)
        
        // Bounding box of playable area
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, ground.size.height, viewSize.width, (viewSize.height - ground.size.height)))
        self.physicsBody.categoryBitMask = Contact.Scene
    }
    
    func setupPlayer() {
        player = Player()
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: viewSize.width * 0.3, y: viewSize.height * 0.5)
        player.zPosition = GameLayer.Game
        worldNode.addChild(player)
    }
    
    
    // Play States
    func switchToPlay() {
        self.physicsWorld.gravity = CGVectorMake(0, -5.0)
        state = GameState.Play
        self.scene.userInteractionEnabled = true
        self.scrollBackground()
        self.scrollForeground()
        self.startSpawningSpikes()
        scoreLabel.hidden = false
    }
    
    func switchToGameOver() {
        state = GameState.GameOver
        
        self.flashBackground()
        self.runAction(sounds.falling)
        
        // Cleanup for showing Score
        scoreLabel.removeFromParent()
        self.stopSpawningSpikes()
        self.stopScrollingBackground()
        self.stopScrollingForeground()
        
        
        // Game Over Label
        let gameOverLabel = SKLabelNode(fontNamed: kGameFont)
        gameOverLabel.text = "Game Over"
        gameOverLabel.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.7)
        gameOverLabel.zPosition = GameLayer.UI
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = kFontColor
        gameOverLabel.setScale(0)
        gameOverLabel.name = kNameGameLabel
        worldNode.addChild(gameOverLabel)
        
        // SKAction
        gameOverLabel.runAction(SKAction.scaleTo(1.0, duration: 1.0))
        
        // Score Labels
        if score > self.bestScore() {
            self.newHighScore(score)
        }
        
        // Score Title
        let currentScoreTitle = SKLabelNode(fontNamed: kGameFont)
        currentScoreTitle.fontColor = kFontColor
        currentScoreTitle.fontSize = 16
        currentScoreTitle.position = CGPoint(x: viewSize.width * 0.35, y: viewSize.height * 0.6)
        currentScoreTitle.text = "Score:"
        currentScoreTitle.zPosition = GameLayer.UI
        worldNode.addChild(currentScoreTitle)
        
        // Current Score
        let currentScore = SKLabelNode(fontNamed: kGameFont)
        currentScore.fontColor = kFontColor
        currentScore.fontSize = 60
        currentScore.position = CGPoint(x: viewSize.width * 0.35, y: viewSize.height * 0.5)
        currentScore.text = String(score)
        currentScore.zPosition = GameLayer.UI
        currentScore.setScale(0)
        worldNode.addChild(currentScore)
        
        // Best Score Title
        let bestScoreTitle = SKLabelNode(fontNamed: kGameFont)
        bestScoreTitle.fontColor = kFontColor
        bestScoreTitle.fontSize = 16
        bestScoreTitle.position = CGPoint(x: viewSize.width * 0.65, y: viewSize.height * 0.6)
        bestScoreTitle.text = "Best Score:"
        bestScoreTitle.zPosition = GameLayer.UI
        worldNode.addChild(bestScoreTitle)
        
        // Best Score
        let bestScore = SKLabelNode(fontNamed: kGameFont)
        bestScore.fontColor = kFontColor
        bestScore.fontSize = 60
        bestScore.position = CGPoint(x: viewSize.width * 0.65, y: viewSize.height * 0.5)
        bestScore.text = String(self.bestScore())
        bestScore.zPosition = GameLayer.UI
        bestScore.setScale(0)
        worldNode.addChild(bestScore)
        
        // SKAction
        let scoreScale = SKAction.scaleTo(1.0, duration: 0.75)
        //scoreScale.timingFunction = SKTTimingFunctionElasticEaseIn
        currentScore.runAction(scoreScale)
        bestScore.runAction(scoreScale)
        
        // Retry Button
        retry = SKLabelNode(fontNamed: kGameFont)
        retry.text = "Retry"
        retry.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.3)
        retry.zPosition = GameLayer.UI
        retry.fontSize = 60
        retry.fontColor = kFontColor
        retry.name = kNameRetry
        worldNode.addChild(retry)
        
        // Guard against accidental tap through
        self.scene.userInteractionEnabled = false
        self.runAction(SKAction.waitForDuration(1.0), completion: {
            self.scene.userInteractionEnabled = true
        })
    }
    
    func switchToNewGame() {
        let gameScene = GameScene(size: viewSize)
        gameScene.scaleMode = .AspectFill
        var gameTransition = SKTransition.fadeWithColor(SKColor.blackColor(), duration: 0.1)
        self.view.presentScene(gameScene, transition: gameTransition)
    }
    
    func runCountDown() {
        let tutorial = SKLabelNode(fontNamed: kGameFont)
        tutorial.text = "Tap to fly Swifty!"
        tutorial.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.7)
        tutorial.zPosition = GameLayer.UI
        tutorial.fontSize = 36
        tutorial.fontColor = kFontColor
        tutorial.name = kNameTutorial
        worldNode.addChild(tutorial)
        
        self.runAction(SKAction.waitForDuration(1.5), completion: {
            tutorial.removeFromParent()
            
            let count = SKLabelNode(fontNamed: kGameFont)
            count.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.6)
            count.zPosition = GameLayer.UI
            count.text = "3"
            count.fontSize = 72
            count.fontColor = kFontColor
            count.name = kNameCount
            self.worldNode.addChild(count)
            
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
    
    
    // Scrolling Background
    func scrollBackground() {
        worldNode.enumerateChildNodesWithName(kNameCityFar, usingBlock: { node, stop in
            let moveLeft = SKAction.moveByX(-viewSize.width, y: 0, duration: self.cityFarSpeed)
            let reset = SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 0)
            let sequence = SKAction.sequence([moveLeft, reset])
            node.runAction(SKAction.repeatActionForever(sequence), withKey: "City Far Scroll")
        })
        
        worldNode.enumerateChildNodesWithName(kNameCityNear, usingBlock: { node, stop in
            let moveLeft = SKAction.moveByX(-viewSize.width, y: 0, duration: self.cityNearSpeed)
            let reset = SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 0)
            let sequence = SKAction.sequence([moveLeft, reset])
            node.runAction(SKAction.repeatActionForever(sequence), withKey: "City Near Scroll")
        })
    }
    
    func stopScrollingBackground() {
        worldNode.enumerateChildNodesWithName(kNameCityFar, usingBlock: { node, stop in
            node.removeAllActions()
        })
        
        worldNode.enumerateChildNodesWithName(kNameCityNear, usingBlock: { node, stop in
            node.removeAllActions()
        })
    }
    
    // Scrolling Foreground
    func scrollForeground() {
        worldNode.enumerateChildNodesWithName(kNameGround, usingBlock: { node, stop in
            let moveLeft = SKAction.moveByX(-self.ground.size.width, y: 0, duration: self.foregroundSpeed)
            let reset = SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 0)
            let sequence = SKAction.sequence([moveLeft, reset])
            node.runAction(SKAction.repeatActionForever(sequence), withKey: "Foreground Scroll")
        })
    }
    
    func stopScrollingForeground() {
        worldNode.enumerateChildNodesWithName(kNameGround, usingBlock: { node, stop in
            node.removeAllActions()
        })
    }

    // Spawning
    func startSpawningSpikes() {
        let delay = SKAction.waitForDuration(1.0)
        let spawn = SKAction.runBlock({
            let obstacle = self.spike.creatSpikes()
           self.worldNode.addChild(obstacle)
        })
        let sequence = SKAction.sequence([delay, spawn])
        let spawnSequence = SKAction.repeatActionForever(sequence)
        
        self.runAction(spawnSequence, withKey: kNameSpikeSpawn)
    }
    
    func stopSpawningSpikes() {
        self.removeActionForKey(kNameSpikeSpawn)
        
        worldNode.enumerateChildNodesWithName(kNameSpikeTop, usingBlock: { node, stop in
            node.removeAllActions()
        })
        
        worldNode.enumerateChildNodesWithName(kNameSpikeBottom, usingBlock: { node, stop in
            node.removeAllActions()
        })
    }
    

    // Scoring
    func updateScore() {
        score++
        scoreLabel.text = String(score)
        self.runAction(sounds.score)
    }
    
    func bestScore() -> Int {
        return defaults.integerForKey(keyBestScore)
    }
    
    func newHighScore(newScore: Int) {
        defaults.setInteger(newScore, forKey: keyBestScore)
        defaults.synchronize()
        
        // Uncomment for sync with iCloud
        //iCloud.setValue(newScore, forKey: keyBestScore)
        //iCloud.synchronize()
    }
    
    // Game Effects
    func flashBackground() {
        let shake = SKAction.screenShakeWithNode(worldNode, amount: CGPoint(x: 20, y: 15), oscillations: 10, duration: 0.75)
        let colorBackground = SKAction.runBlock({
            self.backgroundColor = SKColor.redColor()
            self.runAction(SKAction.waitForDuration(0.5), completion: {
                self.backgroundColor = SKColor.whiteColor()
            })
        })
        let flashGroup = SKAction.group([shake, colorBackground])
        self.runAction(flashGroup)
    }
}
