//
//  GameScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 03.05.2023.
//

import SpriteKit

class GameScene: Scene {
    let level: Int
    var lifesCount = SKLabelNode()
    
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
                    case Resources.Buttons.bigRestartButton:
                        gameController.restartButtonPressed(level: level)
                    default: break
                }
            }
        }
    }
        
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.gameBackground)
        
        let tilesBoard = SKSpriteNode(imageNamed: "levelBoard" + String(level))
        if let size = tilesBoard.texture?.size() {
            tilesBoard.size = CGSize(width: size.width * 0.55, height: size.height * 0.55)
        }
        tilesBoard.position = CGPoint(x: frame.midX, y: frame.midY - 30)
        addChild(tilesBoard)
        
        let tileMiddleBackground = SKSpriteNode(imageNamed: Resources.Tiles.tileBackground)
        tileMiddleBackground.name = Resources.Tiles.tileBackground + String(level+3/2)
        if let size = tileMiddleBackground.texture?.size() {
            tileMiddleBackground.size = CGSize(width: size.width * 1.7, height: size.height * 1.7)
        }
        tileMiddleBackground.position = CGPoint(x: tilesBoard.frame.midX, y: tilesBoard.frame.maxY + tileMiddleBackground.size.height / 2 + 10)
        addChild(tileMiddleBackground)
        
        for i in 1...level+3 {
            let tileBackground = SKSpriteNode(imageNamed: Resources.Tiles.tileBackground)
            tileBackground.name = Resources.Tiles.tileBackground + String(i)
            if let size = tileBackground.texture?.size() {
                tileBackground.size = CGSize(width: size.width * 1.7, height: size.height * 1.7)
            }
//            if level+4 % 2 == 0 {
//                print("even")
//            } else {
            if i % 2 == 0 || i == 0 {
                tileBackground.position = CGPoint(x: tileMiddleBackground.frame.midX + CGFloat(i^50), y: tileMiddleBackground.position.y)
            } else {
                tileBackground.position = CGPoint(x: tileMiddleBackground.frame.midX + CGFloat(i^50), y: tileMiddleBackground.position.y)
            }
//            }
            tileBackground.zPosition = 1
            addChild(tileBackground)
        }
        
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
        
        let restartButton = SKSpriteNode(imageNamed: Resources.Buttons.bigRestartButton)
        if let size = restartButton.texture?.size() {
            restartButton.size = CGSize(width: size.width * 1.3, height: size.height * 1.3)
        }
        restartButton.name = Resources.Buttons.bigRestartButton
        restartButton.position = CGPoint(x: tilesBoard.frame.maxX + 100, y: frame.midY)
        addChild(restartButton)
        
        let levelLabel = SKLabelNode(text: "LVL \(level)")
        levelLabel.fontName = Resources.Fonts.RifficFree_Bold
        levelLabel.fontSize = 50
        levelLabel.position = CGPoint(x: restartButton.frame.midX, y: restartButton.frame.midY - 170)
        addChild(levelLabel)
    }
}
