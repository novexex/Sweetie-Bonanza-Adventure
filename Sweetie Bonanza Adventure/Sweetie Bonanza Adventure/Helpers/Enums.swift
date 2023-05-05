//
//  Enums.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

enum Resources {
    enum Buttons {
        static let giftButton = "giftButton"
        static let soundButton = "soundButton"
        static let unmuteSoundButton = "unmuteSoundButton"
        static let newGameButton = "newGameButton"
        static let continueButton = "continueButton"
        static let shopButton = "shopButton"
        static let menuButton = "menuButton"
        static let claimGiftButton = "claimGiftButton"
        static let buyButton = "buyButton"
        static let bigRestartButton = "bigRestartButton"
        static let restartButton = "restartButton"
        static let continueToWinButton = "continueToWinButton"
    }
    
    enum Labels {
        static let coinsLabel = "coinsLabel"
        static let lifesLabel = "lifesLabel"
        static let candyLabel2000 = "candyLabel2000"
        static let candyLabel1000 = "candyLabel1000"
        static let candyLabel500 = "candyLabel500"
        static let oneLifeLabel = "oneLifeLabel"
        static let threeLifesLabel = "twoLifesLabel"
        static let fiveLifesLabel = "fiveLifesLabel"
        static let buyHeartsLabel = "buyHeartsLabel"
    }
    
    enum Tiles {
        static let questionMarkTile = "questionMarkTile"
        static let tileBackground = "tileBackground"
        static let bombTile = "tile10"
        static let moonTile = "tile11"
    }
    
    enum Backgrounds {
        static let menuBackground = "mainBackground"
        static let storeBackground = "mainBackground"
        static let dailyBonusBackground = "giftBackground"
        static let gameBackground = "gameBackground"
        static let winBackground = "winBackground"
        static let loseBackground = "loseBackground"
    }
    
    enum Fonts {
        static let RifficFree_Bold = "RifficFree-Bold"
    }
    
    enum Colors {
        static let fontColor = "fontColor"
    }
    
    enum UserDefaultKeys {
        static let lifesCount = "lifesCount"
        static let coinsCount = "coinsCount"
        static let availableLevel = "availableLevel"
        static let lastPickupBonus = "lastPickupBonus"
        static let isFirstLaunch = "isFirstLaunch"
    }
}
