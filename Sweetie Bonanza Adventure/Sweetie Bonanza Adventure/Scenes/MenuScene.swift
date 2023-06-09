//
//  MenuScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

import SpriteKit

class MenuScene: BaseScene {
    var lifesCountLabel = SKLabelNode()
    var coinsCountLabel = SKLabelNode()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let node = atPoint(touch.location(in: self)) as? SKSpriteNode {
                switch node.name {
                case Resources.Buttons.gift:
                    if let bonusTime = gameController.lastPickupBonus {
                        if !Calendar.current.isDateInToday(bonusTime) {
                            gameController.giftButtonPressed()
                        } else {
                            createAlert(title: "", message: "Daily bonus is picked up")
                        }
                    } else {
                        gameController.giftButtonPressed()
                    }
                case Resources.Buttons.sound:
                    gameController.soundButtonPressed()
                case Resources.Buttons.newGame:
                    gameController.newGameButtonPressed()
                case Resources.Buttons.`continue`:
                    gameController.continueButtonPressed()
                case Resources.Buttons.shop:
                    gameController.shopButtonPressed()
                default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.menu)
        
        let coinsLabel = SKSpriteNode(imageNamed: Resources.Labels.coins)
        coinsLabel.position = CGPoint(x: frame.maxX - 140, y: frame.maxY - 60)
        addChild(coinsLabel)
        
        let giftButton = SKSpriteNode(imageNamed: Resources.Buttons.gift)
        giftButton.name = Resources.Buttons.gift
        giftButton.size = CGSize(width: coinsLabel.size.height, height: coinsLabel.size.height)
        giftButton.position = CGPoint(x: frame.minX + 90, y: frame.maxY - 60)
        addChild(giftButton)
        
        soundButton = SKSpriteNode(imageNamed: gameController.isSoundMuted ? Resources.Buttons.unmuteSound : Resources.Buttons.sound)
        soundButton.name = Resources.Buttons.sound
        soundButton.size = giftButton.size
        soundButton.position = CGPoint(x: giftButton.position.x + 55, y: giftButton.position.y)
        addChild(soundButton)
        
        let lifesLabel = SKSpriteNode(imageNamed: Resources.Labels.lifes)
        lifesLabel.size = CGSize(width: giftButton.size.width * 2 + 6, height: giftButton.size.height)
        lifesLabel.position = CGPoint(x: giftButton.frame.maxX + 3, y: giftButton.position.y - 55)
        addChild(lifesLabel)
        
        lifesCountLabel = SKLabelNode(text: String(gameController.lifesCount))
        lifesCountLabel.fontName = Resources.Fonts.RifficFree_Bold
        lifesCountLabel.fontSize = 35
        lifesCountLabel.horizontalAlignmentMode = .right
        lifesCountLabel.position = CGPoint(x: lifesLabel.frame.maxX - 12, y: lifesLabel.frame.midY - 15)
        lifesCountLabel.zPosition = 1
        addChild(lifesCountLabel)
        
        coinsCountLabel = SKLabelNode(text: String(gameController.coinsCount))
        coinsCountLabel.fontName = Resources.Fonts.RifficFree_Bold
        coinsCountLabel.fontSize = 35
        coinsCountLabel.horizontalAlignmentMode = .right
        coinsCountLabel.position = CGPoint(x: coinsLabel.frame.maxX - 12, y: coinsLabel.frame.midY - 15)
        coinsCountLabel.zPosition = 1
        addChild(coinsCountLabel)
        
        let shopButton = SKSpriteNode(imageNamed: Resources.Buttons.shop)
        shopButton.name = Resources.Buttons.shop
        shopButton.position = CGPoint(x: frame.midX, y: frame.minY + 70)
        addChild(shopButton)
        
        let newGameButton = SKSpriteNode(imageNamed: Resources.Buttons.newGame)
        newGameButton.name = Resources.Buttons.newGame
        newGameButton.size = shopButton.size
        newGameButton.position = CGPoint(x: shopButton.frame.midX - 110, y: shopButton.position.y + shopButton.size.height + 7)
        addChild(newGameButton)
        
        let continueButton = SKSpriteNode(imageNamed: Resources.Buttons.`continue`)
        continueButton.name = Resources.Buttons.`continue`
        continueButton.size = shopButton.size
        continueButton.position = CGPoint(x: shopButton.frame.midX + 110, y: newGameButton.position.y)
        addChild(continueButton)
    }
    
}
