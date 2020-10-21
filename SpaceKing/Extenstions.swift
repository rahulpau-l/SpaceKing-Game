//
//  Extenstions.swift
//  SpaceKing
//
//  Created by rahul on 2020-06-17.
//  Copyright © 2020 rahul. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {

    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
    }
}
