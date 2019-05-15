//
//  GameScene.swift
//  Project11
//
//  Created by margaret on 2019-05-15.
//  Copyright © 2019 margaret. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // equivalent of SpriteKit's viewDidLoad() method
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        // just draw it, ignoring any alpha values
        background.blendMode = .replace
        // draw this behind everything else
        background.zPosition = -1
        // add node to the current screen
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    // This method gets called (in UIKit and SpriteKit) whenever someone starts touching their device
    // It's possible they started touching with multiple fingers at the same time, so we get passed a new data type called Set. This is just like an array, except each object can appear only once
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // We want to know where the screen was touched, so we use a conditional typecast plus if let to pull out any of the screen touches from the touches set
        if let touch = touches.first {
            // use its location(in:) method to find out where the screen was touched in relation to self
            // UITouch is a UIKit class that is also used in SpriteKit, and provides information about a touch such as its position and when it happened
            let location = touch.location(in: self)
            // generates a node filled with a color (red) at a size (64x64)
            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
            // The code sets the new box's position to be where the tap happened
            box.position = location
            // then adds it to the scene
            addChild(box)
        }
    }
    
}
