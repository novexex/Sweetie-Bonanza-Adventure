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
        
        let menu = SKSpriteNode(imageNamed: Resources.Buttons.menuButton)
        menu.name = Resources.Buttons.menuButton
        menu.size = CGSize(width: 69.3, height: 69.3)
        menu.position = CGPoint(x: frame.minX + 100, y: frame.maxY - 60)
        addChild(menu)
        
        soundButton = SKSpriteNode(imageNamed: gameController.isSoundMuted ? Resources.Buttons.unmuteSoundButton : Resources.Buttons.soundButton)
        soundButton.name = Resources.Buttons.soundButton
        soundButton.size = menu.size
        soundButton.position = CGPoint(x: menu.position.x + 75, y: menu.position.y)
        addChild(soundButton)
        
        let lifesLabel = SKSpriteNode(imageNamed: Resources.Labels.lifesLabel)
        lifesLabel.size = CGSize(width: menu.size.width * 2 + 6, height: menu.size.height)
        lifesLabel.position = CGPoint(x: menu.frame.maxX + 6, y: menu.position.y - 75)
        addChild(lifesLabel)
        
        lifesCount = SKLabelNode(text: String(gameController.lifesCount))
        lifesCount.fontName = Resources.Fonts.RifficFree_Bold
        lifesCount.fontSize = 45
        lifesCount.horizontalAlignmentMode = .right
        lifesCount.position = CGPoint(x: lifesLabel.frame.maxX - 15, y: lifesLabel.frame.midY - 18)
        lifesCount.zPosition = 1
        addChild(lifesCount)
        
        let coinsLabel = SKSpriteNode(imageNamed: Resources.Labels.coinsLabel)
        coinsLabel.size = CGSize(width: lifesLabel.size.width * 1.6, height: lifesLabel.size.height)
        coinsLabel.position = CGPoint(x: frame.maxX - 180, y: menu.position.y)
        addChild(coinsLabel)
        
        coinsCount = SKLabelNode(text: String(gameController.coinsCount))
        coinsCount.fontName = Resources.Fonts.RifficFree_Bold
        coinsCount.fontSize = 45
        coinsCount.horizontalAlignmentMode = .right
        coinsCount.position = CGPoint(x: coinsLabel.frame.maxX - 15, y: coinsLabel.frame.midY - 18)
        coinsCount.zPosition = 1
        addChild(coinsCount)
        
        let threeLifesLabel = SKSpriteNode(imageNamed: Resources.Labels.threeLifesLabel)
        threeLifesLabel.position = CGPoint(x: frame.midX, y: frame.midY - 60)
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
