//
//  GameViewController.swift
//  swifty
//
//  Created by Jeremy Novak on 6/11/14.
//  Copyright (c) 2014 Jeremy Novak. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as SKView
        skView.ignoresSiblingOrder = true
        
        if kDebug {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsDrawCount = true
            skView.showsPhysics = true
        }
        
        let menuScene = MenuScene(size: skView.bounds.size)
        menuScene.scaleMode = SKSceneScaleMode.AspectFill
        skView.presentScene(menuScene)
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
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
