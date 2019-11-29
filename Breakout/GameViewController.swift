//
//  GameViewController.swift
//  Pinball
//
//  Created by Alex Shubin on 07.10.16.
//  Copyright © 2016 Alex Shubin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let skView = self.view as? SKView,
            skView.scene == nil else {
                return

        }

        skView.showsFPS = true
        skView.showsNodeCount = true

        let gameScene = GameScene(size: skView.bounds.size)
        gameScene.scaleMode = .aspectFill

        skView.presentScene(gameScene)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
