//
//  WinScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

import SpriteKit

class WinScene: Scene {
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
                    case Resources.Buttons.continueToWinButton:
                        gameController.continueToWinButtonPressed(level: level)
                    default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.winBackground)
        
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
        
        let plusAmountLabel = SKLabelNode(text: "+" + String(getPlusAmount()))
        plusAmountLabel.fontName = Resources.Fonts.RifficFree_Bold
        plusAmountLabel.fontColor = UIColor(named: Resources.Colors.fontColor)
        plusAmountLabel.fontSize = 35
        plusAmountLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(plusAmountLabel)
        
        let unlockedLabel = SKLabelNode(text: "NEW ITEM UNLOCKED:")
        unlockedLabel.fontName = Resources.Fonts.RifficFree_Bold
        unlockedLabel.horizontalAlignmentMode = .right
        unlockedLabel.fontColor = UIColor(named: Resources.Colors.fontColor)
        unlockedLabel.fontSize = 20
        unlockedLabel.position = CGPoint(x: plusAmountLabel.frame.maxX + 5, y: plusAmountLabel.frame.minY - 60)
        addChild(unlockedLabel)
        
        let unlockedItemBackground = SKSpriteNode(imageNamed: Resources.Tiles.tileBackground)
        if let size = unlockedItemBackground.texture?.size() {
            unlockedItemBackground.size = CGSize(width: size.width * 2, height: size.height * 2)
        }
        unlockedItemBackground.position = CGPoint(x: unlockedLabel.frame.maxX + 50, y: unlockedLabel.frame.midY)
        addChild(unlockedItemBackground)
        
        let unlockedItemLabel = SKSpriteNode(imageNamed: "tile" + String(level+5))
        if let size = unlockedItemLabel.texture?.size() {
            unlockedItemLabel.size = CGSize(width: size.width * 1.5, height: size.height * 1.5)
        }
        unlockedItemLabel.position = CGPoint(x: unlockedItemBackground.frame.midX + 2, y: unlockedItemBackground.frame.midY + 4)
        unlockedItemLabel.zPosition = 1
        addChild(unlockedItemLabel)
        
        let continueToWinButton = SKSpriteNode(imageNamed: Resources.Buttons.continueToWinButton)
        if let size = continueToWinButton.texture?.size() {
            continueToWinButton.size = CGSize(width: size.width * 0.55, height: size.height * 0.55)
        }
        continueToWinButton.name = Resources.Buttons.continueToWinButton
        continueToWinButton.position = CGPoint(x: plusAmountLabel.position.x, y: plusAmountLabel.position.y - 140)
        addChild(continueToWinButton)
    }
    
    private func getPlusAmount() -> Int {
        level * 1000
    }
}
