//
//  GiftScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

import SpriteKit

class DailyBonusScene: Scene {
    var isBonusClaimed = false {
        didSet {
            if isBonusClaimed {
                gameController.lastPickupBonus = Date()
            }
        }
    }
    var lifesCount = SKLabelNode()
    var coinsCount = SKLabelNode()
    
    private var claimButtons = [SKSpriteNode]()
    private var claimAmount = [Resources.Labels.candyLabel500, Resources.Labels.candyLabel1000, Resources.Labels.candyLabel2000]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let node = atPoint(touch.location(in: self)) as? SKSpriteNode {
                switch node.name {
                    case Resources.Buttons.menuButton:
                        gameController.menuButtonPressed()
                    case Resources.Buttons.soundButton:
                        gameController.soundButtonPressed()
                    case Resources.Buttons.claimGiftButton + "1":
                        if !isBonusClaimed { claimProcessing(clicked: 1) }
                    case Resources.Buttons.claimGiftButton + "2":
                        if !isBonusClaimed { claimProcessing(clicked: 2) }
                    case Resources.Buttons.claimGiftButton + "3":
                        if !isBonusClaimed { claimProcessing(clicked: 3) }
                    default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.dailyBonusBackground)
        
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
        
        let claimGiftButton2 = SKSpriteNode(imageNamed: Resources.Buttons.claimGiftButton)
        claimGiftButton2.name = Resources.Buttons.claimGiftButton + "2"
        claimGiftButton2.size = CGSize(width: claimGiftButton2.size.width * 1.2, height: claimGiftButton2.size.height * 1.2)
        claimGiftButton2.position = CGPoint(x: frame.midX, y: frame.midY - 120)
        addChild(claimGiftButton2)
        
        let claimGiftButton1 = SKSpriteNode(imageNamed: Resources.Buttons.claimGiftButton)
        claimGiftButton1.name = Resources.Buttons.claimGiftButton + "1"
        claimGiftButton1.size = claimGiftButton2.size
        claimGiftButton1.position = CGPoint(x: claimGiftButton2.position.x - 170, y: claimGiftButton2.position.y)
        addChild(claimGiftButton1)
        
        let claimGiftButton3 = SKSpriteNode(imageNamed: Resources.Buttons.claimGiftButton)
        claimGiftButton3.name = Resources.Buttons.claimGiftButton + "3"
        claimGiftButton3.size = claimGiftButton2.size
        claimGiftButton3.position = CGPoint(x: claimGiftButton2.position.x + 170, y: claimGiftButton2.position.y)
        addChild(claimGiftButton3)
        
        claimButtons.append(claimGiftButton1)
        claimButtons.append(claimGiftButton2)
        claimButtons.append(claimGiftButton3)
    }
    
    private func claimProcessing(clicked: Int) {
        var claimClick = [Int:String]()
        for i in claimButtons.indices {
            let randomInt = Int.random(in: 0...claimAmount.count-1)
            let randomElement = claimAmount[randomInt]
            claimButtons[i].texture = SKTexture(imageNamed: randomElement)
            claimClick[i+1] = randomElement
            claimAmount.remove(at: randomInt)
            isBonusClaimed = true
        }
        
        if let str = claimClick[clicked] {
            let numberString = String(str.filter { "0123456789".contains($0) })
            if let number = Int(numberString) {
                gameController.coinsCount += number
                gameController.saveGameSetup()
            }
        }
    }
}
