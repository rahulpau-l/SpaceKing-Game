//
//  MainMenu.swift
//  SpaceKing
//
//  Created by rahul on 2020-06-18.
//  Copyright © 2020 rahul. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene, SKPhysicsContactDelegate {
    
    private var transition: SKTransition!
    private var spaceShip: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        background()
        titleLabel()
        tapAnyWhereToPlay()
        physics()
        bouncingSpaceShip()
        //Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(applyImpulse), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        movingStars()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loadGame()
    }
    
    
  @objc func applyImpulse() {
        spaceShip.physicsBody?.applyImpulse(CGVector(dx: 500, dy: 750))
    }
    
    func bouncingSpaceShip() {
        let spaceTexture = SKTexture(imageNamed: "spaceship.png")
        spaceTexture.filteringMode = .nearest
        spaceShip = SKSpriteNode(texture: spaceTexture)
        spaceShip.zPosition = 5
        spaceShip.name = "spaceship"
        spaceShip.position = CGPoint(x: size.width/2, y: 70)
        spaceShip.size = CGSize(width: 192, height: 192)
        spaceShip.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 192, height: 192))
        spaceShip.physicsBody?.pinned = false
        spaceShip.physicsBody?.affectedByGravity = false
        spaceShip.physicsBody?.isDynamic = true
        spaceShip.physicsBody?.angularVelocity = CGFloat.pi/2
        addChild(spaceShip)
        spaceShip.physicsBody?.velocity = CGVector(dx: 250, dy: 500)
        
    }
    
    func physics() {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame )
        self.physicsBody?.isDynamic = true
        self.physicsBody?.pinned = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 1.0
       
    }
    
    func titleLabel() {
        let title = SKLabelNode(fontNamed: "8-Bit Madness")
        title.text = "SpaceKing"
        title.color = .white
        title.fontSize = 50
        title.position = CGPoint(x: size.width/2, y: size.height/2)
        title.horizontalAlignmentMode = .center
        title.zPosition = 10
        addChild(title)
    }
    
    func tapAnyWhereToPlay() {
        let tap = SKLabelNode(fontNamed: "8-Bit Madness")
        tap.text = "Tap anywhere to play!"
        tap.color = .white
        tap.fontSize = 30
        tap.horizontalAlignmentMode = .center
        tap.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        addChild(tap)
    }
    
    
    func loadGame() {
        let scene = GameScene(fileNamed: "GameScene")!
        transition = SKTransition.moveIn(with: .right, duration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
    
    
    func background() {
        
        for i in 0...2 {
            
            let stars = SKSpriteNode(imageNamed: "bg.png")
            stars.name = "stars"
            stars.zPosition = -1
            stars.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            stars.position = CGPoint(x:(stars.size.width/2) , y: CGFloat(i) * (self.frame.size.height))
            addChild(stars)
            
        }
    }
    
    func movingStars(){
        self.enumerateChildNodes(withName: "stars", using: ({
            (node, error) in
            node.position.y -= 4
            if node.position.y < -(self.scene?.size.height)! {
                node.position.y += (self.scene?.size.height)! * 3
            }
        }))
    }
    
    
    
}
