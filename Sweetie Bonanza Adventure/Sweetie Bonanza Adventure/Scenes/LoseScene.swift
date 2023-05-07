//
//  LoseScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

import SpriteKit

class LoseScene: BaseScene {
    let level: Int
    
    init(size: CGSize, gameController: GameViewController, level: Int) {
        self.level = level
        super.init(size: size, gameController: gameController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let node = atPoint(touch.location(in: self)) as? SKSpriteNode {
                switch node.name {
                case Resources.Buttons.menuButton:
                    gameController.menuButtonPressed()
                case Resources.Buttons.soundButton:
                    gameController.soundButtonPressed()
                case Resources.Buttons.buyButton:
                    gameController.makeSound()
                    buyProcessing()
                default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.loseBackground)
        
        let menuButton = SKSpriteNode(imageNamed: Resources.Buttons.menuButton)
        menuButton.name = Resources.Buttons.menuButton
        menuButton.size = CGSize(width: 51, height: 51)
        menuButton.position = CGPoint(x: frame.minX + 90, y: frame.maxY - 60)
        addChild(menuButton)
        
        soundButton = SKSpriteNode(imageNamed: gameController.isSoundMuted ? Resources.Buttons.unmuteSoundButton : Resources.Buttons.soundButton)
        soundButton.name = Resources.Buttons.soundButton
        soundButton.size = menuButton.size
        soundButton.position = CGPoint(x: menuButton.position.x + 55, y: menuButton.position.y)
        addChild(soundButton)
        
        let buyHeartsLabel = SKSpriteNode(imageNamed: Resources.Labels.buyHeartsLabel)
        buyHeartsLabel.position = CGPoint(x: frame.midX - 50, y: frame.minY + 65)
        addChild(buyHeartsLabel)
        
        let buyHeartsButton = SKSpriteNode(imageNamed: Resources.Buttons.buyButton)
        buyHeartsButton.name = Resources.Buttons.buyButton
        buyHeartsButton.position = CGPoint(x: buyHeartsLabel.frame.maxX + 53, y: buyHeartsLabel.frame.midY)
        addChild(buyHeartsButton)
    }
    
    private func buyProcessing() {
        if gameController.coinsCount >= 400 {
            gameController.lifesCount += 5
            gameController.coinsCount -= 400
            gameController.restartButtonPressed(level: level)
        } else {
            createAlert(title: "", message: "You don't have enough points")
        }
    }
}
