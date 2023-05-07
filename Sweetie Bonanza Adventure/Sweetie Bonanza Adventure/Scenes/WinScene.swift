//
//  WinScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

import SpriteKit

class WinScene: BaseScene {
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
                case Resources.Buttons.menu:
                    gameController.menuButtonPressed()
                case Resources.Buttons.sound:
                    gameController.soundButtonPressed()
                case Resources.Buttons.restart:
                    gameController.restartButtonPressed(level: level)
                case Resources.Buttons.continueToWin:
                    gameController.continueToWinButtonPressed(level: level)
                default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.win)
        
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
        
        let restartButton = SKSpriteNode(imageNamed: Resources.Buttons.restart)
        restartButton.name = Resources.Buttons.restart
        restartButton.size = menuButton.size
        restartButton.position = CGPoint(x: frame.maxX - 140, y: menuButton.position.y)
        addChild(restartButton)
        
        let plusAmountLabel = SKLabelNode(text: "+" + String(gameController.getCoins(for: level)))
        plusAmountLabel.fontName = Resources.Fonts.RifficFree_Bold
        plusAmountLabel.fontColor = UIColor(named: Resources.Colors.font)
        plusAmountLabel.fontSize = 30
        plusAmountLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(plusAmountLabel)
        
        let unlockedLabel = SKLabelNode(text: "NEW ITEM UNLOCKED:")
        unlockedLabel.fontName = Resources.Fonts.RifficFree_Bold
        unlockedLabel.horizontalAlignmentMode = .right
        unlockedLabel.fontColor = UIColor(named: Resources.Colors.font)
        unlockedLabel.fontSize = 15
        unlockedLabel.position = CGPoint(x: plusAmountLabel.frame.maxX - 10, y: plusAmountLabel.frame.minY - 50)
        addChild(unlockedLabel)
        
        let unlockedItemBackground = SKSpriteNode(imageNamed: Resources.Tiles.background)
        if let size = unlockedItemBackground.texture?.size() {
            unlockedItemBackground.size = CGSize(width: size.width * 1.8, height: size.height * 1.8)
        }
        unlockedItemBackground.position = CGPoint(x: unlockedLabel.frame.maxX + 50, y: unlockedLabel.frame.midY)
        addChild(unlockedItemBackground)
        
        let unlockedItemLabel = SKSpriteNode(imageNamed: "tile" + String(level+5))
        if let size = unlockedItemLabel.texture?.size() {
            unlockedItemLabel.size = CGSize(width: size.width * 1.5, height: size.height * 1.5)
        }
        unlockedItemLabel.position = CGPoint(x: unlockedItemBackground.frame.midX, y: unlockedItemBackground.frame.midY)
        unlockedItemLabel.zPosition = 1
        addChild(unlockedItemLabel)
        
        let continueToWinButton = SKSpriteNode(imageNamed: Resources.Buttons.continueToWin)
        if let size = continueToWinButton.texture?.size() {
            continueToWinButton.size = CGSize(width: size.width * 0.5, height: size.height * 0.5)
        }
        continueToWinButton.name = Resources.Buttons.continueToWin
        continueToWinButton.position = CGPoint(x: plusAmountLabel.position.x, y: plusAmountLabel.position.y - 120)
        addChild(continueToWinButton)
    }
}
