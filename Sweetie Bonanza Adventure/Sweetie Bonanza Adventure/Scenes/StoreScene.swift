//
//  StoreScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

import SpriteKit

class StoreScene: Scene {
    var lifesCount = SKLabelNode()
    var coinsCount = SKLabelNode()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let node = atPoint(touch.location(in: self)) as? SKSpriteNode {
                switch node.name {
                    case Resources.Buttons.menuButton:
                        gameController.menuButtonPressed()
                    case Resources.Buttons.soundButton:
                        gameController.soundButtonPressed()
                    case "buyOneLifeButton":
                        buyLifes(amount: 1)
                    case "buyThreeLifesButton":
                        buyLifes(amount: 3)
                    case "buyFiveLifesButton":
                        buyLifes(amount: 5)
                    default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.storeBackground)
        
        let coinsLabel = SKSpriteNode(imageNamed: Resources.Labels.coinsLabel)
        coinsLabel.position = CGPoint(x: frame.maxX - 140, y: frame.maxY - 60)
        addChild(coinsLabel)
        
        let menuButton = SKSpriteNode(imageNamed: Resources.Buttons.menuButton)
        menuButton.name = Resources.Buttons.menuButton
        menuButton.size = CGSize(width: coinsLabel.size.height, height: coinsLabel.size.height)
        menuButton.position = CGPoint(x: frame.minX + 90, y: frame.maxY - 60)
        addChild(menuButton)
        
        soundButton = SKSpriteNode(imageNamed: gameController.isSoundMuted ? Resources.Buttons.unmuteSoundButton : Resources.Buttons.soundButton)
        soundButton.name = Resources.Buttons.soundButton
        soundButton.size = menuButton.size
        soundButton.position = CGPoint(x: menuButton.position.x + 55, y: menuButton.position.y)
        addChild(soundButton)
        
        let lifesLabel = SKSpriteNode(imageNamed: Resources.Labels.lifesLabel)
        lifesLabel.size = CGSize(width: menuButton.size.width * 2 + 6, height: menuButton.size.height)
        lifesLabel.position = CGPoint(x: menuButton.frame.maxX + 3, y: menuButton.position.y - 55)
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
        
        let threeLifesLabel = SKSpriteNode(imageNamed: Resources.Labels.threeLifesLabel)
        threeLifesLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        addChild(threeLifesLabel)
        
        let oneLifeLabel = SKSpriteNode(imageNamed: Resources.Labels.oneLifeLabel)
        oneLifeLabel.position = CGPoint(x: threeLifesLabel.position.x - 150, y: threeLifesLabel.position.y)
        addChild(oneLifeLabel)
        
        let fiveLifesLabel = SKSpriteNode(imageNamed: Resources.Labels.fiveLifesLabel)
        fiveLifesLabel.position = CGPoint(x: threeLifesLabel.position.x + 150, y: threeLifesLabel.position.y)
        addChild(fiveLifesLabel)
        
        let buyThreeLifesButton = SKSpriteNode(imageNamed: Resources.Buttons.buyButton)
        buyThreeLifesButton.name = "buyThreeLifesButton"
        buyThreeLifesButton.position = CGPoint(x: threeLifesLabel.frame.midX, y: threeLifesLabel.frame.midY - 80)
        addChild(buyThreeLifesButton)
        
        let buyOneLifeButton = SKSpriteNode(imageNamed: Resources.Buttons.buyButton)
        buyOneLifeButton.name = "buyOneLifeButton"
        buyOneLifeButton.position = CGPoint(x: oneLifeLabel.frame.midX, y: oneLifeLabel.frame.midY - 80)
        addChild(buyOneLifeButton)
        
        let buyFiveLifesButton = SKSpriteNode(imageNamed: Resources.Buttons.buyButton)
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
                    print("Not enough coins")
                }
            case 3:
                if gameController.coinsCount >= 250 {
                    gameController.coinsCount -= 250
                    gameController.lifesCount += amount
                } else {
                    print("Not enough coins")
                }
            case 5:
                if gameController.coinsCount >= 400 {
                    gameController.coinsCount -= 400
                    gameController.lifesCount += amount
                } else {
                    print("Not enough coins")
                }
            default: break
        }
        gameController.saveGameSetup()
    }
}
