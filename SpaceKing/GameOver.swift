//
//  GameOver.swift
//  SpaceKing
//
//  Created by rahul on 2020-10-23.
//  Copyright © 2020 rahul. All rights reserved.
//

import Foundation
import SpriteKit

class GameOver: SKScene {
    
    var score: Int = 0
    
    
    override func didMove(to view: SKView) {
        background()
        gameOverLabel()
        scoreLabel()
    }
    
    override func update(_ currentTime: TimeInterval) {
        movingStars()
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
    
    func gameOverLabel(){
        let over = SKLabelNode(fontNamed: "8-Bit Madness")
        over.text = "GAME OVER"
        over.fontColor = .red
        over.fontSize = 75
        over.position = CGPoint(x: size.width/2, y: size.height/2)
        over.horizontalAlignmentMode = .center
        over.zPosition = 10
        addChild(over)
    }
    
    func scoreLabel(){
        let currentScore = SKLabelNode(fontNamed:  "8-Bit Madness")
        currentScore.text = ("Current Score: \(score)")
        currentScore.fontColor = .green
        currentScore.fontSize = 40
        currentScore.position = CGPoint(x: size.width/2, y: size.height/2 - 80)
        currentScore.horizontalAlignmentMode = .center
        addChild(currentScore)
    }
    
    
    
    
}
    

