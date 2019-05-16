//
//  GameScene.swift
//  Project11
//
//  Created by margaret on 2019-05-15.
//  Copyright © 2019 margaret. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
        
        physicsWorld.contactDelegate = self

        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    // This method gets called (in UIKit and SpriteKit) whenever someone starts touching their device
    // It's possible they started touching with multiple fingers at the same time, so we get passed a new data type called Set. This is just like an array, except each object can appear only once
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // We want to know where the screen was touched, so we use a conditional typecast plus if let to pull out any of the screen touches from the touches set
        if let touch = touches.first {
            // use its location(in:) method to find out where the screen was touched in relation to self
            // UITouch is a UIKit class that is also used in SpriteKit, and provides information about a touch such as its position and when it happened
            let location = touch.location(in: self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            
            ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
            ball.physicsBody?.restitution = 0.4
            ball.position = location
            ball.name = "ball"
            addChild(ball)
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        // centered horizontally on the bottom edge of the scene
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        // When this is true, the object will be moved by the physics simulator based on gravity and collisions. When it's false (as we're setting it) the object will still collide with other things, but it won't ever be moved as a result
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            // for general use, Apple recommends assigning names to your nodes, then checking the name to see what node it is
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        // Add rectangle physics to our slots
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        // slot base needs to be non-dynamic because we don't want it to move out of the way when a player ball hits
        slotBase.physicsBody?.isDynamic = false
        
        slotGlow.position = position
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
    }
    
    //  called when a ball collides with something else
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        }
    }
    
    // called when we're finished with the ball and want to get rid of it
    func destroy(ball: SKNode) {
        // removes a node from your node tree
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node  else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
}
