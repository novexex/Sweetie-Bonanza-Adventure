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
                    gameController.makeSound()
                    elementSelected = -1
                } else if elementSelected == -1 {
                    gameController.makeSound()
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
                            gameController.makeSound()
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
                            } else if gameOver() {
                                gameController.gameOver()
                            }
                        } else {
                            j.element.texture = SKTexture(imageNamed: Resources.Tiles.questionMarkTile)
                            j.element.name = Resources.Tiles.questionMarkTile
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
        
        let restartButton = SKSpriteNode(imageNamed: Resources.Buttons.bigRestartButton)
        if let size = restartButton.texture?.size() {
            restartButton.size = CGSize(width: size.width * 1.3, height: size.height * 1.3)
        }
        restartButton.name = Resources.Buttons.bigRestartButton
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
    
    private func gameOver() -> Bool {
        for i in tiles.enumerated() {
            for j in i.element.enumerated() {
                if isGameOverVertically(row: i.offset, col: j.offset) || isGameOverHorizontally(row: i.offset, col: j.offset) {
                    return false
                }
            }
        }
        return true
    }
    
    private func isGameOverHorizontally(row: Int, col: Int) -> Bool {
        if row >= 1 {
            if tiles[row][col].name == Resources.Tiles.questionMarkTile || tiles[row-1][col].name == Resources.Tiles.questionMarkTile {
                return true
            } else if tiles[row][col].name == tiles[row-1][col].name {
                return true
            }
        }
        return false
    }
    
    private func isGameOverVertically(row: Int, col: Int) -> Bool {
        if col >= 1 {
            if tiles[row][col].name == Resources.Tiles.questionMarkTile || tiles[row][col-1].name == Resources.Tiles.questionMarkTile {
                return true
            } else if tiles[row][col].name == tiles[row][col-1].name {
                return true
            }
        }
        return false
    }
    
    private func setTilesLine() {
        let tileBackground = SKSpriteNode(imageNamed: Resources.Tiles.tileBackground)
        tileBackground.name = Resources.Tiles.tileBackground + "1"
        tileBackground.size = getLineTilesBackgroundSize(node: tileBackground)
        tileBackground.zPosition = -1
        tileBackground.position = getStartLineBackgroundPosition()
        tilesBackgroundLine[0] = tileBackground
        addChild(tileBackground)
        
        for i in 1...level+3 {
            let tilesBackground = SKSpriteNode(imageNamed: Resources.Tiles.tileBackground)
            tilesBackground.name = Resources.Tiles.tileBackground + String(i+1)
            tilesBackground.size = tileBackground.size
            tilesBackground.position = CGPoint(x: tileBackground.position.x + tileBackground.size.width * CGFloat(i), y: tileBackground.position.y)
            tilesBackground.zPosition = -1
            tilesBackgroundLine[i] = tilesBackground
            addChild(tilesBackground)
        }
        
        for i in tilesBackgroundLine.indices {
            let tileLine = SKSpriteNode(imageNamed: tilesImage[i])
            tileLine.name = tilesImage[i]
            if tilesImage[i] == Resources.Tiles.bombTile {
                if let size = tileLine.texture?.size() {
                    if level == 6 {
                        tileLine.size = CGSize(width: size.width * 0.5, height: size.height * 0.5)
                    } else {
                        tileLine.size = CGSize(width: size.width * 0.5, height: size.height * 0.5)
                    }
                }
            } else if tilesImage[i] == Resources.Tiles.moonTile {
                if let size = tileLine.texture?.size() {
                    tileLine.size = CGSize(width: size.width * 1.15, height: size.height * 1.15)
                }
            } else {
                tileLine.size = getLineTileSize(node: tileLine)
            }
            tileLine.position = CGPoint(x: tilesBackgroundLine[i].frame.midX, y: tilesBackgroundLine[i].frame.midY)
            tilesLine[i] = tileLine
            addChild(tileLine)
        }
    }
    
    private func isSameTileRepeatedHorizontally(row: Int, col: Int) -> Bool {
        if row >= 1 && row != tiles.count-1 {
            if tiles[row][col].name == Resources.Tiles.questionMarkTile && tiles[row-1][col].name == Resources.Tiles.questionMarkTile {
                return false
            } else if tiles[row][col].name == tiles[row-1][col].name || tiles[row][col].name == tiles[row+1][col].name {
                return true
            }
        } else if row == 0 {
            if tiles[row][col].name == tiles[row+1][col].name {
                return true
            }
        } else if row == tiles.count-1 {
            if tiles[row][col].name == tiles[row-1][col].name {
                return true
            }
        }
        return false
    }
    
    private func isSameTileRepeatedVertically(row: Int, col: Int) -> Bool {
        if col >= 1 && col != tiles[row].count-1  {
            if tiles[row][col].name == Resources.Tiles.questionMarkTile && tiles[row][col-1].name == Resources.Tiles.questionMarkTile {
                return false
            } else if tiles[row][col].name == tiles[row][col-1].name || tiles[row][col].name == tiles[row][col+1].name {
                return true
            }
        } else if col == 0 {
            if tiles[row][col].name == tiles[row][col+1].name {
                return true
            }
        } else if col == tiles[row].count-1 {
            if tiles[row][col].name == tiles[row][col-1].name {
                return true
            }
        }
        return false
    }
    
    private func getLineTileSize(node: SKSpriteNode) -> CGSize {
        var returnSize = CGSize()
        if let size = node.texture?.size() {
            switch level {
            case 1, 2:
                returnSize = CGSize(width: size.width, height: size.height)
            case 3:
                returnSize = CGSize(width: size.width * 0.9, height: size.height * 0.9)
            case 4:
                returnSize = CGSize(width: size.width * 0.8, height: size.height * 0.8)
            case 5:
                returnSize = CGSize(width: size.width * 0.72, height: size.height * 0.72)
            case 6, 7:
                returnSize = CGSize(width: size.width * 0.7, height: size.height * 0.7)
            default: break
            }
        }
        return returnSize
    }
    
    private func getLineTilesBackgroundSize(node: SKSpriteNode) -> CGSize {
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
    
    private func getStartLineBackgroundPosition() -> CGPoint {
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
    
    private func getStartTilePosition() -> CGPoint {
        switch level {
        case 1:
            return CGPoint(x: tilesBoard.frame.minX + 37, y: tilesBoard.frame.maxY - 47)
        case 2:
            return CGPoint(x: tilesBoard.frame.minX + 32, y: tilesBoard.frame.maxY - 37)
        case 3:
            return CGPoint(x: tilesBoard.frame.minX + 27, y: tilesBoard.frame.maxY - 30)
        case 4:
            return CGPoint(x: tilesBoard.frame.minX + 22, y: tilesBoard.frame.maxY - 23)
        case 5:
            return CGPoint(x: tilesBoard.frame.minX + 24, y: tilesBoard.frame.maxY - 23)
        case 6:
            return CGPoint(x: tilesBoard.frame.minX + 24, y: tilesBoard.frame.maxY - 23)
        case 7:
            return CGPoint(x: tilesBoard.frame.minX + 18, y: tilesBoard.frame.maxY - 18)
        default:
            return CGPoint()
        }
    }
    
    private func getStartTileSize(node: SKSpriteNode) -> CGSize {
        var returnSize = CGSize()
        if let size = node.texture?.size() {
            switch level {
            case 1:
                returnSize = CGSize(width: size.width * 1.8, height: size.height * 1.75)
            case 2:
                returnSize = CGSize(width: size.width * 1.42, height: size.height * 1.32)
            case 3:
                returnSize = CGSize(width: size.width * 1.15, height: size.height * 1.06)
            case 4, 5:
                returnSize = CGSize(width: size.width * 1.0, height: size.height * 0.91)
            case 6:
                returnSize = CGSize(width: size.width * 0.85, height: size.height * 0.76)
            case 7:
                returnSize = CGSize(width: size.width * 0.75, height: size.height * 0.66)
            default: break
            }
        }
        return returnSize
    }
    
    private func setTiles() {
        switch level {
        case 1:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMarkTile), count: 5), count: 3)
        case 2:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMarkTile), count: 6), count: 4)
        case 3:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMarkTile), count: 7), count: 5)
        case 4:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMarkTile), count: 8), count: 6)
        case 5:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMarkTile), count: 9), count: 6)
        case 6:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMarkTile), count: 10), count: 7)
        case 7:
            tiles = Array(repeating: Array(repeating: SKSpriteNode(imageNamed: Resources.Tiles.questionMarkTile), count: 11), count: 8)
        default: break
        }
        
        let startTile = SKSpriteNode(imageNamed: Resources.Tiles.questionMarkTile)
        startTile.name = Resources.Tiles.questionMarkTile
        startTile.size = getStartTileSize(node: startTile)
        startTile.position = getStartTilePosition()
        tiles[0][0] = startTile
        addChild(startTile)
        
        for i in tiles.enumerated() {
            for j in i.element.enumerated() {
                if i.offset == 0 && j.offset == 0 {
                    continue
                }
                let tile = SKSpriteNode(imageNamed: Resources.Tiles.questionMarkTile)
                tile.name = Resources.Tiles.questionMarkTile
                tile.size = startTile.size
                tile.position = CGPoint(x: startTile.position.x + (tile.size.width * 1.18) * CGFloat(j.offset), y: startTile.position.y - (tile.size.height * 1.25) * CGFloat(i.offset))
                tiles[i.offset][j.offset] = tile
                addChild(tile)
            }
        }
    }
}
