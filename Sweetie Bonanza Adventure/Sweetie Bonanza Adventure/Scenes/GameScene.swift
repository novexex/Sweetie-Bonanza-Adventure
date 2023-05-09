//
//  GameScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 03.05.2023.
//

import SpriteKit

class GameScene: BaseScene {
    let level: Int
    var lifesCountLabel = SKLabelNode()
    private var tilesBoard = SKSpriteNode()
    private var tiles = [[SKSpriteNode]]()
    private lazy var tilesBackgroundLine = Array(repeating: SKSpriteNode(), count: level+4)
    private lazy var tilesLine = Array(repeating: SKSpriteNode(), count: level+4)
    private var tilesImage = [String]()
    private var elementSelected = -1 {
        willSet {
            if elementSelected != -1 {
                tilesLine[elementSelected].size = CGSize(width: tilesLine[elementSelected].size.width / 1.4, height: tilesLine[elementSelected].size.height / 1.4)
            }
        }
    }
    
    init(size: CGSize, gameController: GameViewController, level: Int) {
        self.level = level
        super.init(size: size, gameController: gameController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Top line touch handler
        for i in tilesBackgroundLine.enumerated() {
            if i.element.contains(location) {
                if elementSelected != -1 && elementSelected == i.offset {
                    gameController.makeClickSound()
                    elementSelected = -1
                } else {
                    gameController.makeClickSound()
                    tilesLine[i.offset].size = CGSize(width: tilesLine[i.offset].size.width * 1.4, height: tilesLine[i.offset].size.height * 1.4)
                    elementSelected = i.offset
                }
            }
        }
        
        // Tiles board line touch handler
        for i in tiles.enumerated() {
            for j in i.element.enumerated() {
                if j.element.contains(location) {
                    if elementSelected != -1 {
                        gameController.makeClickSound()
                        if j.element.texture == tilesLine[elementSelected].texture {
                            elementSelected = -1
                            break
                        }
                        j.element.texture = tilesLine[elementSelected].texture
                        j.element.name = tilesLine[elementSelected].name
                        elementSelected = -1
                        if isSameTileRepeatedVertically(row: i.offset, col: j.offset) || isSameTileRepeatedHorizontally(row: i.offset, col: j.offset) {
                            gameController.lifesCount -= 1
                            gameController.saveGameSetup()
                        } else if allBoardFilled() {
                            if gameOver() {
                                gameController.gameOver()
                            }
                        }
                    } else {
                        j.element.texture = SKTexture(imageNamed: Resources.Tiles.questionMark)
                        j.element.name = Resources.Tiles.questionMark
                    }
                }
            }
        }
        
        if gameController.lifesCount == 0 {
            gameController.gameOver()
        }
        
        for touch in touches {
            if let node = atPoint(touch.location(in: self)) as? SKSpriteNode {
                switch node.name {
                case Resources.Buttons.menu:
                    gameController.menuButtonPressed()
                case Resources.Buttons.sound:
                    gameController.soundButtonPressed()
                case Resources.Buttons.bigRestart:
                    gameController.restartButtonPressed(level: level)
                case Resources.Buttons.guide:
                    gameController.guideButtonPressed()
                default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.game)
        
        tilesBoard = SKSpriteNode(imageNamed: "levelBoard" + String(level))
        if let size = tilesBoard.texture?.size() {
            tilesBoard.size = CGSize(width: size.width * 0.5, height: size.height * 0.5)
        }
        
        tilesBoard.position = CGPoint(x: frame.midX, y: frame.midY - 33)
        tilesBoard.zPosition = -1
        addChild(tilesBoard)
        
        setupTilesImage()
        setTilesLine()
        setTiles()
        
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
        
        let guideButton = SKSpriteNode(imageNamed: Resources.Buttons.guide)
        guideButton.name = Resources.Buttons.guide
        guideButton.size = menuButton.size
        guideButton.position = CGPoint(x: frame.maxX - 120, y: menuButton.position.y)
        addChild(guideButton)
        
        let restartButton = SKSpriteNode(imageNamed: Resources.Buttons.bigRestart)
        if let size = restartButton.texture?.size() {
            restartButton.size = CGSize(width: size.width * 1.3, height: size.height * 1.3)
        }
        restartButton.name = Resources.Buttons.bigRestart
        restartButton.position = CGPoint(x: tilesBoard.frame.maxX + 100, y: frame.midY)
        restartButton.size = CGSize(width: menuButton.size.width * 2, height: menuButton.size.height * 2)
        addChild(restartButton)
        
        let levelLabel = SKLabelNode(text: "LVL \(level)")
        levelLabel.fontName = Resources.Fonts.RifficFree_Bold
        levelLabel.fontSize = 40
        levelLabel.position = CGPoint(x: restartButton.frame.midX, y: restartButton.frame.midY - 170)
        addChild(levelLabel)
    }
    
    private func setupTilesImage() {
        for i in 1...11 {
            tilesImage.append("tile\(i)")
        }
    }
    
    private func allBoardFilled() -> Bool {
        for i in tiles.enumerated() {
            for j in i.element.enumerated() {
                if tiles[i.offset][j.offset].name == Resources.Tiles.questionMark {
                    return false
                }
            }
        }
        return true
    }
    
    private func gameOver() -> Bool {
        for i in tiles.enumerated() {
            for j in i.element.enumerated() {
                if isSameTileRepeatedVertically(row: i.offset, col: j.offset) || isSameTileRepeatedHorizontally(row: i.offset, col: j.offset) {
                    return false
                }
            }
        }
        return true
    }
    
    private func setTilesLine() {
        let tileBackground = SKSpriteNode(imageNamed: Resources.Tiles.background)
        tileBackground.name = Resources.Tiles.background + "1"
        tileBackground.size = getBackgroundSizeOnLine(node: tileBackground)
        tileBackground.zPosition = -1
        tileBackground.position = getStartBackgroundPositionOnLine()
        tilesBackgroundLine[0] = tileBackground
        addChild(tileBackground)
        
        for i in 1...level+3 {
            let tilesBackground = SKSpriteNode(imageNamed: Resources.Tiles.background)
            tilesBackground.name = Resources.Tiles.background + String(i+1)
            tilesBackground.size = tileBackground.size
            tilesBackground.position = CGPoint(x: tileBackground.position.x + tileBackground.size.width * CGFloat(i), y: tileBackground.position.y)
            tilesBackground.zPosition = -1
            tilesBackgroundLine[i] = tilesBackground
            addChild(tilesBackground)
        }
        
        for i in tilesBackgroundLine.indices {
            let tileLine = SKSpriteNode(imageNamed: tilesImage[i])
            tileLine.name = tilesImage[i]
            tileLine.size = getTileSizeOnLine(node: tileLine)
            tileLine.position = CGPoint(x: tilesBackgroundLine[i].frame.midX, y: tilesBackgroundLine[i].frame.midY)
            tilesLine[i] = tileLine
            addChild(tileLine)
        }
    }
    
    private func isSameTileRepeatedHorizontally(row: Int, col: Int) -> Bool {
        for i in 0..<tiles.count {
            if i == row {
                continue
            } else if tiles[row][col].name == tiles[i][col].name {
                return true
            }
        }
        return false
    }
    
    private func isSameTileRepeatedVertically(row: Int, col: Int) -> Bool {
        for i in 0..<tiles[0].count {
            if i == col {
                continue
            } else if tiles[row][col].name == tiles[row][i].name {
                return true
            }
        }
        return false
    }
    
    private func getTileSizeOnLine(node: SKSpriteNode) -> CGSize {
        var returnSize = CGSize()
        if let size = node.texture?.size() {
            switch level {
            case 1, 2:
                returnSize = CGSize(width: size.width * 1.4, height: size.height * 1.4)
            case 3:
                returnSize = CGSize(width: size.width * 1.2, height: size.height * 1.2)
            case 4:
                returnSize = CGSize(width: size.width * 1.1, height: size.height * 1.1)
            case 5:
                returnSize = CGSize(width: size.width, height: size.height)
            case 6, 7:
                returnSize = CGSize(width: size.width * 0.9, height: size.height * 0.9)
            default: break
            }
        }
        return returnSize
    }
    
    private func getBackgroundSizeOnLine(node: SKSpriteNode) -> CGSize {
        var returnSize = CGSize()
        if let size = node.texture?.size() {
            switch level {
            case 1, 2:
                returnSize = CGSize(width: size.width * 1.7, height: size.height * 1.7)
            case 3:
                returnSize = CGSize(width: size.width * 1.45, height: size.height * 1.4)
            case 4:
                returnSize = CGSize(width: size.width * 1.27, height: size.height * 1.27)
            case 5:
                returnSize = CGSize(width: size.width * 1.22, height: size.height * 1.22)
            case 6:
                returnSize = CGSize(width: size.width * 1.08, height: size.height * 1.08)
            case 7:
                returnSize = CGSize(width: size.width * 1.03, height: size.height * 1.03)
            default: break
            }
        }
        return returnSize
    }
    
    private func getStartBackgroundPositionOnLine() -> CGPoint {
        switch level {
        case 1:
            return CGPoint(x: tilesBoard.frame.minX + 75, y: tilesBoard.frame.maxY + 40)
        case 2:
            return CGPoint(x: tilesBoard.frame.minX + 34, y: tilesBoard.frame.maxY + 40)
        case 3:
            return CGPoint(x: tilesBoard.frame.minX + 17, y: tilesBoard.frame.maxY + 40)
        case 4:
            return CGPoint(x: tilesBoard.frame.minX + 15, y: tilesBoard.frame.maxY + 35)
        case 5:
            return CGPoint(x: tilesBoard.frame.minX + 26, y: tilesBoard.frame.maxY + 35)
        case 6:
            return CGPoint(x: tilesBoard.frame.minX + 15, y: tilesBoard.frame.maxY + 35)
        case 7:
            return CGPoint(x: tilesBoard.frame.minX, y: tilesBoard.frame.maxY + 35)
        default:
            return CGPoint()
        }
    }
    
    private func getStartTilePositionOnBoard() -> CGPoint {
        switch level {
        case 1:
            return CGPoint(x: tilesBoard.frame.minX + 41, y: tilesBoard.frame.maxY - 47)
        case 2:
            return CGPoint(x: tilesBoard.frame.minX + 34, y: tilesBoard.frame.maxY - 37)
        case 3:
            return CGPoint(x: tilesBoard.frame.minX + 27, y: tilesBoard.frame.maxY - 30)
        case 4:
            return CGPoint(x: tilesBoard.frame.minX + 22, y: tilesBoard.frame.maxY - 23)
        case 5:
            return CGPoint(x: tilesBoard.frame.minX + 24, y: tilesBoard.frame.maxY - 23)
        case 6:
            return CGPoint(x: tilesBoard.frame.minX + 21, y: tilesBoard.frame.maxY - 23)
        case 7:
            return CGPoint(x: tilesBoard.frame.minX + 18, y: tilesBoard.frame.maxY - 18)
        default:
            return CGPoint()
        }
    }
    
    private func getStartTileSizeOnBoard(node: SKSpriteNode) -> CGSize {
        var returnSize = CGSize()
        if let size = node.texture?.size() {
            switch level {
            case 1:
                returnSize = CGSize(width: size.width * 0.25, height: size.height * 0.25)
            case 2:
                returnSize = CGSize(width: size.width * 0.2, height: size.height * 0.19)
            case 3:
                returnSize = CGSize(width: size.width * 0.164, height: size.height * 0.1493)
            case 4, 5:
                returnSize = CGSize(width: size.width * 0.145, height: size.height * 0.13)
            case 6:
                returnSize = CGSize(width: size.width * 0.125, height: size.height * 0.108)
            case 7:
                returnSize = CGSize(width: size.width * 0.109, height: size.height * 0.094)
            default: break
            }
        }
        return returnSize
    }
    
    private func setTiles() {
        switch level {
        case 1:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMark), count: 5), count: 3)
        case 2:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMark), count: 6), count: 4)
        case 3:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMark), count: 7), count: 5)
        case 4:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMark), count: 8), count: 6)
        case 5:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMark), count: 9), count: 6)
        case 6:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMark), count: 10), count: 7)
        case 7:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMark), count: 11), count: 8)
        default: break
        }
        
        let startTile = SKSpriteNode(imageNamed: Resources.Tiles.questionMark)
        startTile.name = Resources.Tiles.questionMark
        startTile.size = getStartTileSizeOnBoard(node: startTile)
        startTile.position = getStartTilePositionOnBoard()
        tiles[0][0] = startTile
        addChild(startTile)
        
        for i in tiles.enumerated() {
            for j in i.element.enumerated() {
                if i.offset == 0 && j.offset == 0 {
                    continue
                }
                let tile = SKSpriteNode(imageNamed: Resources.Tiles.questionMark)
                tile.name = Resources.Tiles.questionMark
                tile.size = startTile.size
                tile.position = CGPoint(x: startTile.position.x + (tile.size.width * 1.18) * CGFloat(j.offset), y: startTile.position.y - (tile.size.height * 1.25) * CGFloat(i.offset))
                tiles[i.offset][j.offset] = tile
                addChild(tile)
            }
        }
    }
}
