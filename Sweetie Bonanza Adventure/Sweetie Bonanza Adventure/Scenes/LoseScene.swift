//
//  LoseScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

import SpriteKit

class LoseScene: Scene {
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
                    case Resources.Buttons.restartButton:
                        gameController.restartButtonPressed(level: level)
                    case Resources.Buttons.buyButton:
                        buyProcessing()
                    default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.loseBackground)
        
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
        
        let restartButton = SKSpriteNode(imageNamed: Resources.Buttons.restartButton)
        restartButton.size = menu.size
        restartButton.position = CGPoint(x: frame.maxX - 150, y: menu.position.y)
        addChild(restartButton)
        
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
        }
    }
}
