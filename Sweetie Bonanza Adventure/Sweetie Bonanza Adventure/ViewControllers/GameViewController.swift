//
//  GameViewController.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 03.05.2023.
//

import SpriteKit

class GameViewController: UIViewController {
    // MARK: Game state & settings
    var isSoundMuted = false {
        didSet {
            let soundImage = isSoundMuted ? Resources.Buttons.unmuteSoundButton : Resources.Buttons.soundButton
            menuScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            dailyBonusScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            storeScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            gameScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            winScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            loseScene.soundButton.texture = SKTexture(imageNamed: soundImage)
        }
    }
    var lifesCount = 5 {
        didSet {
            menuScene.lifesCount.text = String(lifesCount)
            dailyBonusScene.lifesCount.text = String(lifesCount)
            storeScene.lifesCount.text = String(lifesCount)
            gameScene.lifesCount.text = String(lifesCount)
        }
    }
    var coinsCount = 0 {
        didSet {
            menuScene.coinsCount.text = String(coinsCount)
            dailyBonusScene.coinsCount.text = String(coinsCount)
            storeScene.coinsCount.text = String(coinsCount)
        }
    }
    var availableLevel = 1 {
        didSet {
            if availableLevel < 1 {
                availableLevel = oldValue
            }
        }
    }
    var lastPickupBonus: Date?
    private var isFirstLaunch = 0
    
    // MARK: Scenes
    private lazy var menuScene = MenuScene(size: view.bounds.size, gameController: self)
    private lazy var gameScene = GameScene(size: view.bounds.size, gameController: self, level: availableLevel)
    private lazy var storeScene = StoreScene(size: view.bounds.size, gameController: self)
    private lazy var dailyBonusScene = DailyBonusScene(size: view.bounds.size, gameController: self)
    private lazy var winScene = WinScene(size: view.bounds.size, gameController: self, level: availableLevel)
    private lazy var loseScene = LoseScene(size: view.bounds.size, gameController: self, level: availableLevel)
    private weak var currentScene: Scene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGame()
        setupSKView()
    }
    
    func saveGameSetup() {
        UserDefaults.standard.set(isFirstLaunch, forKey: Resources.UserDefaultKeys.isFirstLaunch)
        UserDefaults.standard.set(lifesCount, forKey: Resources.UserDefaultKeys.lifesCount)
        UserDefaults.standard.set(coinsCount, forKey: Resources.UserDefaultKeys.coinsCount)
        UserDefaults.standard.set(availableLevel, forKey: Resources.UserDefaultKeys.availableLevel)
        UserDefaults.standard.set(lastPickupBonus, forKey: Resources.UserDefaultKeys.lastPickupBonus)
    }
    
    func soundButtonPressed() {
        isSoundMuted.toggle()
    }
    
    func giftButtonPressed() {
        presentCustomScene(dailyBonusScene)
    }
    
    func newGameButtonPressed() {
        availableLevel = 1
        saveGameSetup()
        gameScene = GameScene(size: view.bounds.size, gameController: self, level: availableLevel)
        presentCustomScene(gameScene)
    }
    
    func continueButtonPressed() {
        gameScene = GameScene(size: view.bounds.size, gameController: self, level: availableLevel)
        presentCustomScene(gameScene)
    }
    
    func shopButtonPressed() {
        presentCustomScene(storeScene)
    }
    
    func menuButtonPressed() {
        presentCustomScene(menuScene)
    }
    
    func restartButtonPressed(level: Int) {
        gameScene = GameScene(size: view.bounds.size, gameController: self, level: level)
        presentCustomScene(gameScene)
    }
    
    func continueToWinButtonPressed(level: Int) {
        if level <= 6 {
            gameScene = GameScene(size: view.bounds.size, gameController: self, level: level+1)
            presentCustomScene(gameScene)
        }
    }
    
    func gameOver() {
        if lifesCount == 0 {
            loseScene = LoseScene(size: view.bounds.size, gameController: self, level: availableLevel)
            presentCustomScene(loseScene)
        } else {
            presentCustomScene(winScene)
            coinsCount += availableLevel * 1000
            availableLevel += 1
            saveGameSetup()
        }
    }
    
    private func setupSKView() {
        let skView = SKView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        self.view = skView
        currentScene = menuScene
        skView.presentScene(currentScene)
    }
    
    private func setupGame() {
        isFirstLaunch = UserDefaults.standard.integer(forKey: Resources.UserDefaultKeys.isFirstLaunch)
        lifesCount = UserDefaults.standard.integer(forKey: Resources.UserDefaultKeys.lifesCount)
        coinsCount = UserDefaults.standard.integer(forKey: Resources.UserDefaultKeys.coinsCount)
        availableLevel = UserDefaults.standard.integer(forKey: Resources.UserDefaultKeys.availableLevel)
        lastPickupBonus = UserDefaults.standard.object(forKey: Resources.UserDefaultKeys.lastPickupBonus) as? Date
        if isFirstLaunch == 0 {
            lifesCount = 5
            isFirstLaunch = 1
            saveGameSetup()
        }
    }
    
    private func presentCustomScene(_ scene: Scene) {
        if let view = view as? SKView {
            currentScene.removeAllChildren()
            currentScene = scene
            view.presentScene(currentScene)
        }
    }
}
