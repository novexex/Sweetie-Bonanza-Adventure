//
//  StoreScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

import SpriteKit

class StoreScene: BaseScene {
    var lifesCountLabel = SKLabelNode()
    var coinsCountLabel = SKLabelNode()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let node = atPoint(touch.location(in: self)) as? SKSpriteNode {
                switch node.name {
                case Resources.Buttons.menu:
                    gameController.menuButtonPressed()
                case Resources.Buttons.sound:
                    gameController.soundButtonPressed()
                case "buyOneLifeButton":
                    gameController.makeSound()
                    buyLifes(amount: 1)
                case "buyThreeLifesButton":
                    gameController.makeSound()
                    buyLifes(amount: 3)
                case "buyFiveLifesButton":
                    gameController.makeSound()
                    buyLifes(amount: 5)
                default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.store)
        
        let coinsLabel = SKSpriteNode(imageNamed: Resources.Labels.coins)
        coinsLabel.position = CGPoint(x: frame.maxX - 140, y: frame.maxY - 60)
        addChild(coinsLabel)
        
        let menuButton = SKSpriteNode(imageNamed: Resources.Buttons.menu)
        menuButton.name = Resources.Buttons.menu
        menuButton.size = CGSize(width: coinsLabel.size.height, height: coinsLabel.size.height)
        menuButton.position = CGPoint(x: frame.minX + 90, y: frame.maxY - 60)
        addChild(menuButton)
        
        soundButton = SKSpriteNode(imageNamed: gameController.isSoundMuted ? Resources.Buttons.unmuteSound : Resources.Buttons.sound)
        soundButton.name = Resources.Buttons.sound
        soundButton.size = menuButton.size
        soundButton.position = CGPoint(x: menuButton.position.x + 55, y: menuButton.position.y)
        addChild(soundButton)
        
        let lifesLabel = SKSpriteNode(imageNamed: Resources.Labels.lifes)
        lifesLabel.size = CGSize(width: menuButton.size.width * 2 + 6, height: menuButton.size.height)
        lifesLabel.position = CGPoint(x: menuButton.frame.maxX + 3, y: menuButton.position.y - 55)
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
        
        let threeLifesLabel = SKSpriteNode(imageNamed: Resources.Labels.threeLifes)
        threeLifesLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        addChild(threeLifesLabel)
        
        let oneLifeLabel = SKSpriteNode(imageNamed: Resources.Labels.oneLife)
        oneLifeLabel.position = CGPoint(x: threeLifesLabel.position.x - 150, y: threeLifesLabel.position.y)
        addChild(oneLifeLabel)
        
        let fiveLifesLabel = SKSpriteNode(imageNamed: Resources.Labels.fiveLifes)
        fiveLifesLabel.position = CGPoint(x: threeLifesLabel.position.x + 150, y: threeLifesLabel.position.y)
        addChild(fiveLifesLabel)
        
        let buyThreeLifesButton = SKSpriteNode(imageNamed: Resources.Buttons.buy)
        buyThreeLifesButton.name = "buyThreeLifesButton"
        buyThreeLifesButton.position = CGPoint(x: threeLifesLabel.frame.midX, y: threeLifesLabel.frame.midY - 80)
        addChild(buyThreeLifesButton)
        
        let buyOneLifeButton = SKSpriteNode(imageNamed: Resources.Buttons.buy)
        buyOneLifeButton.name = "buyOneLifeButton"
        buyOneLifeButton.position = CGPoint(x: oneLifeLabel.frame.midX, y: oneLifeLabel.frame.midY - 80)
        addChild(buyOneLifeButton)
        
        let buyFiveLifesButton = SKSpriteNode(imageNamed: Resources.Buttons.buy)
        buyFiveLifesButton.name = "buyFiveLifesButton"
        buyFiveLifesButton.position = CGPoint(x: fiveLifesLabel.frame.midX, y: fiveLifesLabel.frame.midY - 80)
        addChild(buyFiveLifesButton)
    }
    
    private func buyLifes(amount: Int) {
        switch amount {
        case 1:
            if gameController.coinsCount >= 100 {
                gameController.coinsCount -= 100
                gameController.lifesCount += amount
            } else {
                createAlert(title: "", message: "You don't have enough points")
            }
        case 3:
            if gameController.coinsCount >= 250 {
                gameController.coinsCount -= 250
                gameController.lifesCount += amount
            } else {
                createAlert(title: "", message: "You don't have enough points")
            }
        case 5:
            if gameController.coinsCount >= 400 {
                gameController.coinsCount -= 400
                gameController.lifesCount += amount
            } else {
                createAlert(title: "", message: "You don't have enough points")
            }
        default: break
        }
        gameController.saveGameSetup()
    }
}
