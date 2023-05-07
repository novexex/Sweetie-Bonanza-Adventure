//
//  GiftScene.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

import SpriteKit

class DailyBonusScene: BaseScene {
    var lifesCountLabel = SKLabelNode()
    var coinsCountLabel = SKLabelNode()
    var isBonusClaimed = false {
        didSet {
            if isBonusClaimed {
                gameController.lastPickupBonus = Date()
            }
        }
    }
    
    private var claimButtons = [SKSpriteNode]()
    private var claimAmount = [Resources.Labels.smallCandy, Resources.Labels.mediumCandy, Resources.Labels.largeCandy]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let node = atPoint(touch.location(in: self)) as? SKSpriteNode {
                switch node.name {
                case Resources.Buttons.menu:
                    gameController.menuButtonPressed()
                case Resources.Buttons.sound:
                    gameController.soundButtonPressed()
                case Resources.Buttons.claimGift + "1":
                    gameController.makeSound()
                    if !isBonusClaimed { claimProcessing(clicked: 1) }
                case Resources.Buttons.claimGift + "2":
                    gameController.makeSound()
                    if !isBonusClaimed { claimProcessing(clicked: 2) }
                case Resources.Buttons.claimGift + "3":
                    gameController.makeSound()
                    if !isBonusClaimed { claimProcessing(clicked: 3) }
                default: break
                }
            }
        }
    }
    
    override func setupUI() {
        setBackground(with: Resources.Backgrounds.dailyBonus)
        
        let coinsLabel = SKSpriteNode(imageNamed: Resources.Labels.coins)
        coinsLabel.position = CGPoint(x: frame.maxX - 140, y: frame.maxY - 60)
        addChild(coinsLabel)
        
        let menuButton = SKSpriteNode(imageNamed: Resources.Buttons.menu)
        menuButton.name = Resources.Buttons.menu
        menuButton.size = CGSize(width: coinsLabel.size.height, height: coinsLabel.size.height)
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
        
        coinsCountLabel = SKLabelNode(text: String(gameController.coinsCount))
        coinsCountLabel.fontName = Resources.Fonts.RifficFree_Bold
        coinsCountLabel.fontSize = 35
        coinsCountLabel.horizontalAlignmentMode = .right
        coinsCountLabel.position = CGPoint(x: coinsLabel.frame.maxX - 12, y: coinsLabel.frame.midY - 15)
        coinsCountLabel.zPosition = 1
        addChild(coinsCountLabel)
        
        let claimGiftButton2 = SKSpriteNode(imageNamed: Resources.Buttons.claimGift)
        claimGiftButton2.name = Resources.Buttons.claimGift + "2"
        claimGiftButton2.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        addChild(claimGiftButton2)
        
        let claimGiftButton1 = SKSpriteNode(imageNamed: Resources.Buttons.claimGift)
        claimGiftButton1.name = Resources.Buttons.claimGift + "1"
        claimGiftButton1.size = claimGiftButton2.size
        claimGiftButton1.position = CGPoint(x: claimGiftButton2.position.x - 170, y: claimGiftButton2.position.y)
        addChild(claimGiftButton1)
        
        let claimGiftButton3 = SKSpriteNode(imageNamed: Resources.Buttons.claimGift)
        claimGiftButton3.name = Resources.Buttons.claimGift + "3"
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
