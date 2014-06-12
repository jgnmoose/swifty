//
//  GameViewController.swift
//  swifty
//
//  Created by Jeremy Novak on 6/11/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
        var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as MenuScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var deviceType:String?
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            deviceType = "GameSceneiPad"
        } else {
            deviceType = "GameSceneiPhone"
        }
        
        if let scene = MenuScene.unarchiveFromFile(deviceType!) as? MenuScene  {
            // Configure the view.
            let skView = self.view as SKView
            if kDebug {
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsDrawCount = true
            }
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    // Auto rotate the view
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    // Hide the status bar
    override func prefersStatusBarHidden() -> Bool  {
        return true
    }
    
    // Supported Interface Orientations
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            // iPad can be Portrait or Portrait Upsidedown
            return Int(UIInterfaceOrientationMask.Portrait.toRaw() | UIInterfaceOrientationMask.PortraitUpsideDown.toRaw())
        } else {
            // iPhone/iPod only support Portrait
            return Int(UIInterfaceOrientationMask.Portrait.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
