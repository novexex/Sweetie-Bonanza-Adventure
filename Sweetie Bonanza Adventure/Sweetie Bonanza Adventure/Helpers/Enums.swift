//
//  Enums.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 04.05.2023.
//

enum Resources {
    enum Buttons {
        static let gift = "giftButton"
        static let sound = "soundButton"
        static let unmuteSound = "unmuteSoundButton"
        static let newGame = "newGameButton"
        static let `continue` = "continueButton"
        static let shop = "shopButton"
        static let menu = "menuButton"
        static let claimGift = "claimGiftButton"
        static let buy = "buyButton"
        static let bigRestart = "bigRestartButton"
        static let restart = "restartButton"
        static let continueToWin = "continueToWinButton"
    }
    
    enum Names {
        static let buyThreeLifesButton = "buyThreeLifesButton"
        static let buyOneLifeButton = "buyOneLifeButton"
        static let buyFiveLifesButton = "buyFiveLifesButton"
    }
    
    enum Labels {
        static let coins = "coinsLabel"
        static let lifes = "lifesLabel"
        static let largeCandy = "candyLabel2000"
        static let mediumCandy = "candyLabel1000"
        static let smallCandy = "candyLabel500"
        static let oneLife = "oneLifeLabel"
        static let threeLifes = "twoLifesLabel"
        static let fiveLifes = "fiveLifesLabel"
        static let buyHearts = "buyHeartsLabel"
    }
    
    enum Tiles {
        static let questionMark = "questionMarkTile"
        static let background = "tileBackground"
        static let bomb = "tile10"
        static let moon = "tile11"
    }
    
    enum Backgrounds {
        static let menu = "mainBackground"
        static let store = "mainBackground"
        static let dailyBonus = "giftBackground"
        static let game = "gameBackground"
        static let win = "winBackground"
        static let lose = "loseBackground"
    }
    
    enum Fonts {
        static let RifficFree_Bold = "RifficFree-Bold"
    }
    
    enum Colors {
        static let font = "fontColor"
    }
    
    enum UserDefaultKeys {
        static let lifesCount = "lifesCount"
        static let coinsCount = "coinsCount"
        static let availableLevel = "availableLevel"
        static let lastPickupBonus = "lastPickupBonus"
        static let isFirstLaunch = "isFirstLaunch"
    }
}
