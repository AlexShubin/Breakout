

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
   
    let ballCategoryName = "ball"
    let paddleCategoryName = "paddle"
    let brickCategoryName = "brick"
    
    var fingerIsOnPaddle:Bool = false
    var bricksCount = 0
    var isWaitingForTap = true
    
    let ballCategory:UInt32 = 1 << 0
    let bottomCategory:UInt32 = 1 << 1
    let brickCategory:UInt32 = 1 << 2
    let paddleCategory:UInt32 = 1 << 3
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(color: .darkGray, size: size)
        background.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        self.addChild(background)
        
        self.physicsWorld.gravity = .zero
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = 0
        
        let waitingLabel = SKLabelNode(text: "Tap to start")
        waitingLabel.name = "waitingLabel"
        waitingLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/3)
        
        self.addChild(waitingLabel)
        
        let ball = SKShapeNode(circleOfRadius: 10)
        ball.name = ballCategoryName
        ball.fillColor = .cyan
        ball.position = CGPoint(x: self.frame.width/2, y: ball.frame.height*3)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        
        
        let paddle = SKSpriteNode(color: .red, size: CGSize(width: 88, height: 22))
        paddle.name = paddleCategoryName
        paddle.position = CGPoint(x: self.frame.midX, y: paddle.frame.height+5)
        self.addChild(paddle)
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: paddle.frame.width, height: paddle.frame.height))
        paddle.physicsBody?.friction = 0.4
        paddle.physicsBody?.restitution = 0.1
        paddle.physicsBody?.isDynamic = false
        
        let bottomRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        self.addChild(bottom)
     
        bottom.physicsBody?.categoryBitMask = bottomCategory
        ball.physicsBody?.categoryBitMask = ballCategory
        paddle.physicsBody?.categoryBitMask = paddleCategory
        
        ball.physicsBody?.contactTestBitMask = bottomCategory | brickCategory
        
        //
        let numberOfRows = 4
        let numberOfColumns = 8
        let brickPlaceleft = self.frame.width / 20
        let brickPlaceBottom = self.frame.height / 2
        let brickPlaceTop = self.frame.height - self.frame.height / 20
        //
        
        let brickPlaceRight = self.frame.width - brickPlaceleft
        let offsetX = (brickPlaceRight - brickPlaceleft)/(CGFloat(numberOfColumns)*4)
        let offsetY = (brickPlaceTop - brickPlaceBottom)/(CGFloat(numberOfRows)*4)
        let brickHeigth = (brickPlaceTop - brickPlaceBottom)/CGFloat(numberOfRows) - offsetY
        let brickWidth = (brickPlaceRight - brickPlaceleft)/CGFloat(numberOfColumns) - offsetX
        
        
        for row in 0 ... numberOfRows-1 {
            
            for column in 0 ... numberOfColumns-1 {
                
                let brick = SKSpriteNode(color: .green, size: CGSize(width: brickWidth, height: brickHeigth))
                brick.position = CGPoint(x: brickPlaceleft+(offsetX+brickWidth)*CGFloat(column)+brickWidth/2, y: brickPlaceBottom+(offsetY+brickHeigth)*CGFloat(row)+brickHeigth/2)
                brick.name = brickCategoryName
                
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.frame.size)
                brick.physicsBody?.friction = 0
                brick.physicsBody?.restitution = 1
                brick.physicsBody?.affectedByGravity = false
                brick.physicsBody?.isDynamic = false
                brick.physicsBody?.allowsRotation = false
                
                brick.physicsBody?.categoryBitMask = brickCategory
                
                self.addChild(brick)
                
                bricksCount += 1
                
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isWaitingForTap {
            isWaitingForTap = false
            let ball = childNode(withName: "ball")
            ball?.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 3))
            let waitingLabel = childNode(withName: "waitingLabel")
            waitingLabel?.removeFromParent()
        }
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: self)
            
            let paddle = childNode(withName: paddleCategoryName) as! SKSpriteNode
            
            if touchLocation.x >= paddle.position.x - paddle.size.width/2
                && touchLocation.x <= paddle.position.x + paddle.size.width/2
                && touchLocation.y <= paddle.position.y + paddle.size.height/2 + 10
                {
                fingerIsOnPaddle = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if fingerIsOnPaddle {
            if let touch = touches.first {
                
                let touchLocation = touch.location(in: self)
                let PrevTouchLocation = touch.previousLocation(in: self)
                
                let paddle = self.childNode(withName: paddleCategoryName) as! SKSpriteNode
                
                var newXPos = paddle.position.x + (touchLocation.x - PrevTouchLocation.x)
                
                if newXPos - paddle.size.width/2 < 0 {
                    newXPos = paddle.size.width/2
                }
                if newXPos + paddle.size.width/2 > self.size.width {
                    newXPos = self.size.width - paddle.size.width/2
                }
                
                paddle.position = CGPoint(x: newXPos, y: paddle.position.y)
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fingerIsOnPaddle = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1: SKPhysicsBody
        var body2: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == ballCategory && body2.categoryBitMask == bottomCategory {
            
            let gameScene = GameOverScene(size: self.frame.size, text: "Game over")
            gameScene.scaleMode = .aspectFill
            
            self.view?.presentScene(gameScene)
            
        }
        
        if body1.categoryBitMask == ballCategory && body2.categoryBitMask == brickCategory {
            body2.node?.removeFromParent()
            bricksCount -= 1
            
            if bricksCount == 0 {
               
                let gameScene = GameOverScene(size: self.frame.size, text: "You won!")
                gameScene.scaleMode = .aspectFill
                
                self.view?.presentScene(gameScene)
                
            }
            
        }
        
    }
    
}
