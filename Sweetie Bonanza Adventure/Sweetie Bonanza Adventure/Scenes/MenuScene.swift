//
//  MenuScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

import SpriteKit

class MenuScene: Scene {
    var lifesCount = SKLabelNode()
    var coinsCount = SKLabelNode()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let node = atPoint(touch.location(in: self)) as? SKSpriteNode {
                switch node.name {
                case Resources.Buttons.giftButton:
                    if let bonusTime = gameController.lastPickupBonus {
                        if !Calendar.current.isDateInToday(bonusTime) {
                            gameController.giftButtonPressed()
                        } else {
                            print("Daily bonus is picked up")
                        }
                    } else {
                        gameController.giftButtonPressed()
                    }
                case Resources.Buttons.soundButton:
                    gameController.soundButtonPressed()
                case Resources.Buttons.newGameButton:
                    gameController.newGameButtonPressed()
                case Resources.Buttons.continueButton:
                    gameController.continueButtonPressed()
                case Resources.Buttons.shopButton:
                    gameController.shopButtonPressed()
                default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.menuBackground)
        
        let coinsLabel = SKSpriteNode(imageNamed: Resources.Labels.coinsLabel)
        coinsLabel.position = CGPoint(x: frame.maxX - 140, y: frame.maxY - 60)
        addChild(coinsLabel)
        
        let giftButton = SKSpriteNode(imageNamed: Resources.Buttons.giftButton)
        giftButton.name = Resources.Buttons.giftButton
        giftButton.size = CGSize(width: coinsLabel.size.height, height: coinsLabel.size.height)
        giftButton.position = CGPoint(x: frame.minX + 90, y: frame.maxY - 60)
        addChild(giftButton)
        
        soundButton = SKSpriteNode(imageNamed: gameController.isSoundMuted ? Resources.Buttons.unmuteSoundButton : Resources.Buttons.soundButton)
        soundButton.name = Resources.Buttons.soundButton
        soundButton.size = giftButton.size
        soundButton.position = CGPoint(x: giftButton.position.x + 55, y: giftButton.position.y)
        addChild(soundButton)
        
        let lifesLabel = SKSpriteNode(imageNamed: Resources.Labels.lifesLabel)
        lifesLabel.size = CGSize(width: giftButton.size.width * 2 + 6, height: giftButton.size.height)
        lifesLabel.position = CGPoint(x: giftButton.frame.maxX + 3, y: giftButton.position.y - 55)
        addChild(lifesLabel)
        
        lifesCount = SKLabelNode(text: String(gameController.lifesCount))
        lifesCount.fontName = Resources.Fonts.RifficFree_Bold
        lifesCount.fontSize = 35
        lifesCount.horizontalAlignmentMode = .right
        lifesCount.position = CGPoint(x: lifesLabel.frame.maxX - 12, y: lifesLabel.frame.midY - 15)
        lifesCount.zPosition = 1
        addChild(lifesCount)
        
        coinsCount = SKLabelNode(text: String(gameController.coinsCount))
        coinsCount.fontName = Resources.Fonts.RifficFree_Bold
        coinsCount.fontSize = 35
        coinsCount.horizontalAlignmentMode = .right
        coinsCount.position = CGPoint(x: coinsLabel.frame.maxX - 12, y: coinsLabel.frame.midY - 15)
        coinsCount.zPosition = 1
        addChild(coinsCount)
        
        let shopButton = SKSpriteNode(imageNamed: Resources.Buttons.shopButton)
        shopButton.name = Resources.Buttons.shopButton
        shopButton.position = CGPoint(x: frame.midX, y: frame.minY + 70)
        addChild(shopButton)
        
        let newGameButton = SKSpriteNode(imageNamed: Resources.Buttons.newGameButton)
        newGameButton.name = Resources.Buttons.newGameButton
        newGameButton.size = shopButton.size
        newGameButton.position = CGPoint(x: shopButton.frame.midX - 110, y: shopButton.position.y + shopButton.size.height + 7)
        addChild(newGameButton)
        
        let continueButton = SKSpriteNode(imageNamed: Resources.Buttons.continueButton)
        continueButton.name = Resources.Buttons.continueButton
        continueButton.size = shopButton.size
        continueButton.position = CGPoint(x: shopButton.frame.midX + 110, y: newGameButton.position.y)
        addChild(continueButton)
    }
    
}
