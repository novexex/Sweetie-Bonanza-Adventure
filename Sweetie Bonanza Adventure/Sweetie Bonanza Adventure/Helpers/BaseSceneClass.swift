//
//  BaseClass.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 03.05.2023.
//

import SpriteKit

class Scene: SKScene {
    weak var gameController: GameViewController!
    var soundButton = SKSpriteNode()
    
    init(size: CGSize, gameController: GameViewController) {
        self.gameController = gameController
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupUI()
    }
    
    func setupUI() {}
    
    func setBackground(with imageNamed: String) {
        let background = SKSpriteNode(imageNamed: imageNamed)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scale(to: frame.size)
        background.zPosition = -2
        addChild(background)
    }
}
