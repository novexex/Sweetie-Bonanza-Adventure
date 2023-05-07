//
//  GameViewController.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 03.05.2023.
//

import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    // MARK: Game state & settings propertys
    var isSoundMuted = false {
        didSet {
            let soundImage = isSoundMuted ? Resources.Buttons.unmuteSound : Resources.Buttons.sound
            menuScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            dailyBonusScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            storeScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            gameScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            winScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            loseScene.soundButton.texture = SKTexture(imageNamed: soundImage)
            if isSoundMuted {
                backgroundMusic?.pause()
                clickSound?.volume = 0
                winSound?.volume = 0
                loseSound?.volume = 0
            } else {
                backgroundMusic?.play()
                clickSound?.volume = 1
                winSound?.volume = 2
                loseSound?.volume = 1
            }
        }
    }
    var lifesCount = 5 {
        didSet {
            menuScene.lifesCountLabel.text = String(lifesCount)
            dailyBonusScene.lifesCountLabel.text = String(lifesCount)
            storeScene.lifesCountLabel.text = String(lifesCount)
            gameScene.lifesCountLabel.text = String(lifesCount)
        }
    }
    var coinsCount = 0 {
        didSet {
            menuScene.coinsCountLabel.text = String(coinsCount)
            dailyBonusScene.coinsCountLabel.text = String(coinsCount)
            storeScene.coinsCountLabel.text = String(coinsCount)
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
    private var alertController = UIAlertController()
    
    // MARK: Audio propertys
    private var backgroundMusic: AVAudioPlayer?
    private var clickSound: AVAudioPlayer?
    private var winSound: AVAudioPlayer?
    private var loseSound: AVAudioPlayer?
    
    // MARK: Scene propertys
    private lazy var menuScene = MenuScene(size: view.bounds.size, gameController: self)
    private lazy var gameScene = GameScene(size: view.bounds.size, gameController: self, level: availableLevel)
    private lazy var storeScene = StoreScene(size: view.bounds.size, gameController: self)
    private lazy var dailyBonusScene = DailyBonusScene(size: view.bounds.size, gameController: self)
    private lazy var winScene = WinScene(size: view.bounds.size, gameController: self, level: availableLevel)
    private lazy var loseScene = LoseScene(size: view.bounds.size, gameController: self, level: availableLevel)
    private weak var currentScene: BaseScene!
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAlerts()
        setupGame()
        setupAudio()
        setupSKView()
    }
    
    // MARK: Public methods
    func saveGameSetup() {
        UserDefaults.standard.set(isFirstLaunch, forKey: Resources.UserDefaultKeys.isFirstLaunch)
        UserDefaults.standard.set(lifesCount, forKey: Resources.UserDefaultKeys.lifesCount)
        UserDefaults.standard.set(coinsCount, forKey: Resources.UserDefaultKeys.coinsCount)
        UserDefaults.standard.set(availableLevel, forKey: Resources.UserDefaultKeys.availableLevel)
        UserDefaults.standard.set(lastPickupBonus, forKey: Resources.UserDefaultKeys.lastPickupBonus)
    }
    
    func soundButtonPressed() {
        makeSound()
        isSoundMuted.toggle()
    }
    
    func giftButtonPressed() {
        makeSound()
        presentCustomScene(dailyBonusScene)
    }
    
    func newGameButtonPressed() {
        makeSound()
        if lifesCount != 0 {
            availableLevel = 1
            saveGameSetup()
            gameScene = GameScene(size: view.bounds.size, gameController: self, level: availableLevel)
            presentCustomScene(gameScene)
        } else {
            if let view = self.view {
                view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func continueButtonPressed() {
        makeSound()
        if lifesCount != 0 {
            gameScene = GameScene(size: view.bounds.size, gameController: self, level: availableLevel)
            presentCustomScene(gameScene)
        } else {
            if let view = self.view {
                view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func shopButtonPressed() {
        makeSound()
        presentCustomScene(storeScene)
    }
    
    func menuButtonPressed() {
        makeSound()
        presentCustomScene(menuScene)
    }
    
    func restartButtonPressed(level: Int) {
        makeSound()
        if lifesCount != 0 {
            gameScene = GameScene(size: view.bounds.size, gameController: self, level: level)
            presentCustomScene(gameScene)
        } else {
            if let view = self.view {
                view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func continueToWinButtonPressed(level: Int) {
        makeSound()
        if level <= 6 {
            gameScene = GameScene(size: view.bounds.size, gameController: self, level: level+1)
            presentCustomScene(gameScene)
        }
    }
    
    func gameOver() {
        if lifesCount == 0 {
            loseSound?.play()
            loseScene = LoseScene(size: view.bounds.size, gameController: self, level: availableLevel)
            presentCustomScene(loseScene)
        } else {
            winSound?.play()
            presentCustomScene(winScene)
            coinsCount += getCoins(for: availableLevel)
            availableLevel += 1
            saveGameSetup()
        }
    }
    
    func makeSound() {
        clickSound?.play()
    }
    
    func getCoins(for level: Int) -> Int {
        level * 1000
    }
    
    // MARK: Private methods
    private func setupAudio() {
        if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
            do {
                backgroundMusic = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusic?.numberOfLoops = -1
                backgroundMusic?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let soundURL = Bundle.main.url(forResource: "clickSound", withExtension: "mp3") {
            do {
                clickSound = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let soundURL = Bundle.main.url(forResource: "winSound", withExtension: "mp3") {
            do {
                winSound = try AVAudioPlayer(contentsOf: soundURL)
                winSound?.volume = 2
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let soundURL = Bundle.main.url(forResource: "loseSound", withExtension: "mp3") {
            do {
                loseSound = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupAlerts() {
        alertController = UIAlertController(title: "", message: "You don't have enough lifes", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
    }
    
    private func setupSKView() {
        let skView = SKView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        skView.ignoresSiblingOrder = true
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
    
    private func presentCustomScene(_ scene: BaseScene) {
        if let view = view as? SKView {
            currentScene.removeAllChildren()
            currentScene = scene
            view.presentScene(currentScene)
        }
    }
}
