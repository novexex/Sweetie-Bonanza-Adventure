//
//  GuideScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 07.05.2023.
//

import SpriteKit

class GuideScene: BaseScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let node = atPoint(touch.location(in: self)) as? SKSpriteNode {
                switch node.name {
                case Resources.Buttons.menu:
                    gameController.menuButtonPressed()
                case Resources.Buttons.sound:
                    gameController.soundButtonPressed()
                case Resources.Buttons.dismiss:
                    gameController.dismissButtonPressed()
                case Resources.Buttons.shop:
                    gameController.shopButtonPressed()
                default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.guide)
        
        let menuButton = SKSpriteNode(imageNamed: Resources.Buttons.menu)
        menuButton.name = Resources.Buttons.menu
        menuButton.size = CGSize(width: 51, height: 51)
        menuButton.position = CGPoint(x: frame.minX + 90, y: frame.maxY - 60)
        addChild(menuButton)
        
        soundButton = SKSpriteNode(imageNamed: gameController.isSoundMuted ? Resources.Buttons.unmuteSound : Resources.Buttons.sound)
        soundButton.name = Resources.Buttons.sound
        soundButton.size = menuButton.size
        soundButton.position = CGPoint(x: menuButton.position.x + 55, y: menuButton.position.y)
        addChild(soundButton)
        
        let dismissButton = SKSpriteNode(imageNamed: Resources.Buttons.dismiss)
        dismissButton.name = Resources.Buttons.dismiss
        dismissButton.size = menuButton.size
        dismissButton.position = CGPoint(x: frame.maxX - 120, y: menuButton.position.y)
        addChild(dismissButton)
        
        let shopButton = SKSpriteNode(imageNamed: Resources.Buttons.shop)
        shopButton.name = Resources.Buttons.shop
        shopButton.position = CGPoint(x: frame.midX + 100, y: frame.minY + 60)
        addChild(shopButton)
    }
}
