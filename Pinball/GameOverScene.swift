
import SpriteKit
import GameplayKit

class GameOverScene: SKScene {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(size: CGSize, text: String) {
        super.init(size: size)
     
        let background = SKSpriteNode(color: .black, size: size)
        background.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        self.addChild(background)
        
        let GameOverLabel = SKLabelNode(text: text)
        
        GameOverLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        self.addChild(GameOverLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let gameScene = GameScene(size: (self.view?.bounds.size)!)
        gameScene.scaleMode = .aspectFill

        self.view?.presentScene(gameScene)
        
    }
    
}
