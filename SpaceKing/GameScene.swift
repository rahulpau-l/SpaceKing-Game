//
//  GameScene.swift
//  SpaceKing
//
//  Created by rahul on 2020-06-01.
//  Copyright © 2020 rahul. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    private let monsters:  [String] = ["octo", "yellow", "blue"]
    private let motion = CMMotionManager()
    private var scoreLabel: SKLabelNode!
    private var missle:     SKSpriteNode!
    private var spaceShip: SKSpriteNode!
    private var scores: Int = 0
    private var pLo: CGFloat = 0
    private var lifeCount: Int = 0
    private let preloadSound = SKAction.playSoundFileNamed("shootingSound.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        motion.startAccelerometerUpdates()
        physicsWorld.contactDelegate = self
        background()
        spaceShips()
        score()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        timerSpawn()
        barriers()
        puppyStitch()
        top()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        movingStars()
        scoreLabel.text = "Score: \(scores)"
        guard let data = motion.accelerometerData else { return }
        pLo = CGFloat(100 * data.acceleration.x)
        spaceShip.physicsBody?.applyForce(CGVector(dx: pLo, dy: 0))
        if lifeCount > 3 {
            gameOver()
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let touchCount = event?.allTouches?.count else {return}
        
        let location    = touch.location(in: self)
        let x           = (location.x - spaceShip.position.x) * 0.1
        let y           = (location.y - (122)) * 0.1
        let vector      = CGVector(dx: x, dy: y)
        
        if touchCount == 1 {
            fireMissle(vector)
            playSound(preloadSound)
        }
        
    }
    
    func playSound(_ sound: SKAction){
        run(sound)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "spaceship" || contact.bodyB.node?.name == "spaceship" {return}
        
        if contact.bodyA.node?.name == "missle" && contact.bodyB.node?.name == "enemy" {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            scores += 1
            return
        }
        
        if contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "missle" {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            scores += 1
            return
        }
        
        
        if contact.bodyA.node?.name == "bottomEdge" || contact.bodyB.node?.name == "enemy" {
            contact.bodyB.node?.removeFromParent()
        }
        
        
        if contact.bodyA.node?.name == "top" && contact.bodyB.node?.name == "missle" {
            contact.bodyB.node?.removeFromParent()
        }
        
        
        
        
        if contact.bodyA.node?.name == "stitch" && contact.bodyB.node?.name == "missle" {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            for child in self.children {
                if child.name == "enemy" {
                    child.removeFromParent()
                }
            }
        }
        
        if contact.bodyA.node?.name == "missle" && contact.bodyB.node?.name == "stitch" {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            for child in self.children {
                if child.name == "enemy" {
                    child.removeFromParent()
                }
            }
        }
        
        
    }
    
    
    
    func fireMissle(_ v: CGVector) {
        let fire = SKTexture(imageNamed: "fireball.png")
        fire.filteringMode = .nearest
        missle = SKSpriteNode(texture: fire)
        missle.zPosition = 10
        missle.name = "missle"
        missle.position = CGPoint(x: spaceShip.position.x, y: 122)
        missle.size = CGSize(width: 32, height: 32)
        missle.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        missle.physicsBody?.affectedByGravity = false
        missle.physicsBody?.allowsRotation = true
        missle.physicsBody?.categoryBitMask = Collision.missle
        missle.physicsBody?.contactTestBitMask = Collision.enemey
        missle.physicsBody?.collisionBitMask = Collision.enemey
        missle.addGlow()
        addChild(missle)
        missle.physicsBody?.angularDamping = 0.0
        missle.physicsBody?.applyImpulse(v)
    }
    
    @objc func destoryMissle(){
        missle.removeFromParent()
    }
    
    @objc func spawnYellow(){
        let yellowT = SKTexture(imageNamed: monsters.randomElement()!)
        yellowT.filteringMode = .nearest
        let yellowEnemy = SKSpriteNode(texture: yellowT)
        yellowEnemy.name = "enemy"
        yellowEnemy.zPosition = 10
        yellowEnemy.position = CGPoint(x: Int.random(in: 0...240), y: Int.random(in: 600...900))
        let rand = randomSize()
        yellowEnemy.size = CGSize(width: rand , height: rand )
        yellowEnemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rand/2, height: rand/2))
        yellowEnemy.physicsBody?.affectedByGravity = true
        yellowEnemy.physicsBody?.allowsRotation = true
        yellowEnemy.physicsBody?.angularVelocity =  CGFloat.pi/4
        yellowEnemy.physicsBody?.categoryBitMask = Collision.enemey
        yellowEnemy.physicsBody?.contactTestBitMask = Collision.missle | Collision.bottomEdge
        yellowEnemy.physicsBody?.collisionBitMask = Collision.missle
        addChild(yellowEnemy)
        let randomY = Int.random(in: 300...600)
        yellowEnemy.physicsBody?.velocity = CGVector(dx: 0, dy: -randomY)
        
    }
    
    func timerSpawn() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(spawnYellow), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(puppyStitch), userInfo: nil, repeats: true)
        
    }
    
    func spaceShips() {
        let spaceTexture = SKTexture(imageNamed: "spaceship.png")
        spaceTexture.filteringMode = .nearest
        spaceShip = SKSpriteNode(texture: spaceTexture)
        spaceShip.zPosition = 5
        spaceShip.name = "spaceship"
        spaceShip.position = CGPoint(x: size.width/2, y: 70)
        spaceShip.size = CGSize(width: 192, height: 192)
        spaceShip.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 192/4, height: 192/4))
        spaceShip.physicsBody?.contactTestBitMask = Collision.leftAndRightEdge
        spaceShip.physicsBody?.collisionBitMask = Collision.leftAndRightEdge
        spaceShip.physicsBody?.categoryBitMask = Collision.ship
        addChild(spaceShip)
    }
    
    @objc func puppyStitch() {
        let doggo = SKTexture(imageNamed: "stitch.png")
        doggo.filteringMode = .nearest
        let pup = SKSpriteNode(texture: doggo)
        pup.name = "stitch"
        pup.position = CGPoint(x: Int.random(in: 200...300), y: Int.random(in: 200...300))
        pup.size = CGSize(width: 64, height: 64)
        pup.physicsBody = SKPhysicsBody(circleOfRadius: 32)
        pup.physicsBody?.pinned = false
        pup.physicsBody?.isDynamic = true
        pup.physicsBody?.collisionBitMask = Collision.missle
        pup.physicsBody?.contactTestBitMask = Collision.missle
        pup.physicsBody?.categoryBitMask = Collision.ship
        pup.physicsBody?.angularVelocity = CGFloat.pi/6
        
        
        pup.physicsBody?.velocity = CGVector(dx: 0, dy: -15)
        addChild(pup)
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
            node.position.y -= 10
            if node.position.y < -(self.scene?.size.height)! {
                node.position.y += (self.scene?.size.height)! * 3
            }
        }))
    }
    
    func score() {
        scoreLabel = SKLabelNode(fontNamed: "8-Bit Madness")
        scoreLabel.position = CGPoint(x: 60, y: size.height - 50)
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 30
        scoreLabel.zPosition = 5
        addChild(scoreLabel)
    }
    
    
    
    /*func shootingStars() {
     guard let stars = SKEmitterNode(fileNamed: "MyParticle.sks") else { return }
     stars.advanceSimulationTime(10)
     stars.zPosition = 10
     stars.position = spaceShip.position
     addChild(stars)
     }*/
    
    func barriers() {
        let leftEdge = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: size.height))
        leftEdge.name = "leftEdge"
        leftEdge.position = CGPoint(x: -20, y: size.height/2)
        leftEdge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: size.height))
        leftEdge.physicsBody?.pinned = true
        leftEdge.physicsBody?.isDynamic = false
        leftEdge.physicsBody?.restitution = 0.5
        leftEdge.physicsBody?.categoryBitMask = Collision.leftAndRightEdge
        addChild(leftEdge)
        
        let rightEdge = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: size.height))
        rightEdge.name = "rightEdge"
        rightEdge.position = CGPoint(x: 380, y: size.height/2)
        rightEdge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: size.height))
        rightEdge.physicsBody?.pinned = true
        rightEdge.physicsBody?.isDynamic = false
        rightEdge.physicsBody?.restitution = 0.5
        rightEdge.physicsBody?.categoryBitMask = Collision.leftAndRightEdge
        addChild(rightEdge)
        
        let bottomEdge = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: 10))
        bottomEdge.name = "bottomEdge"
        bottomEdge.position = CGPoint(x: size.width/2, y: -100)
        bottomEdge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 10))
        bottomEdge.physicsBody?.isDynamic = false
        bottomEdge.physicsBody?.pinned = true
        bottomEdge.physicsBody?.affectedByGravity = false
        bottomEdge.physicsBody?.collisionBitMask = Collision.enemey
        bottomEdge.physicsBody?.contactTestBitMask = Collision.enemey
        bottomEdge.physicsBody?.categoryBitMask = Collision.bottomEdge
        addChild(bottomEdge)
    }
    
    func randomSize() -> Int {
        return Int.random(in: 64...256)
    }
    
    func top() {
        let top = SKSpriteNode(color: .black, size: CGSize(width: size.width, height: 10))
        top.position = CGPoint(x: size.width/2, y: size.height)
        top.name = "top"
        
        top.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 10))
        top.physicsBody?.affectedByGravity = false
        top.physicsBody?.isDynamic = false
        top.physicsBody?.pinned = true
        top.physicsBody?.categoryBitMask = Collision.top
        top.physicsBody?.collisionBitMask = Collision.missle
        top.physicsBody?.contactTestBitMask = Collision.missle
        
        self.addChild(top)
    }
    
    func atomizer() {
        //let sucker = SKFieldNode.magneticField()
        //sucker.texture = SKTexture(imageNamed: <#T##String#>)
    }
    
    func gameOver(){
        
    }
    
    
}
