// GameScene.swift
// Winston Squirrelchill Explorer
//
//  Created by Richard Groeneveld on 11/30/23.

import SpriteKit
import GameplayKit
import AVFoundation

let defaults = UserDefaults.standard

class GameScene: SKScene, SKPhysicsContactDelegate {
    let droneTimePerFrame = 0.2
    let maxTimeBgMoving: CGFloat = 3
    let bgAnimatedInSecs: TimeInterval = 7
    // Create a variable with Get and Set methods that will run when the variable is requested or changed

    var highScore:Int{
        get {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            return defaults.integer(forKey: "Best")
        }
        set (newValue) {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            // Saves what the highScore variable was just set to as the saved value for "Best"
            defaults.set(newValue, forKey: "Best")
        }
    }
    var totalDistance:Int{
        get {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            return defaults.integer(forKey: "Distance")
        }
        set (newValue) {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            defaults.set(newValue, forKey: "Distance")
        }
    }
    var totalFood:Int{
        get {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            return defaults.integer(forKey: "Food")
        }
        set (newValue) {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            defaults.set(newValue, forKey: "Food")
        }
    }
    var totalWater:Int{
        get {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            return defaults.integer(forKey: "Water")
        }
        set (newValue) {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            defaults.set(newValue, forKey: "Water")
        }
    }
    var totalMushrooms:Int{
        get {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            return defaults.integer(forKey: "Mushrooms")
        }
        set (newValue) {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            defaults.set(newValue, forKey: "Mushrooms")
        }
    }
    var totalLife:Int{
        get {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            return defaults.integer(forKey: "Life")
        }
        set (newValue) {
            // Get the standard UserDefaults as "defaults"
            let defaults = UserDefaults.standard
            
            defaults.set(newValue, forKey: "Life")
        }
    }
    
    var drone: SKSpriteNode = SKSpriteNode()
    var background: SKSpriteNode = SKSpriteNode()
    var scoreLabel: SKLabelNode = SKLabelNode()
    var scoreTitleLabel: SKLabelNode = SKLabelNode()
    var highScoreLabel: SKLabelNode = SKLabelNode()
    var score: Int = 0
    var gameOver: Bool = false
    var StartScreen: Bool = true
    var gameOverLabel: SKLabelNode = SKLabelNode()
    var gameBeginLabel: SKLabelNode = SKLabelNode()
    var titleLabel: SKLabelNode = SKLabelNode()
    var instructionsLabel: SKLabelNode = SKLabelNode()
    var gamePlayLabel: SKLabelNode = SKLabelNode()
    var soundStyleLabel: SKLabelNode = SKLabelNode()
    var timer: Timer = Timer()
    var backgroundcounter: Int = 1
    var audioPlayer : AVPlayer!
    var playerLooper: AVPlayerLooper?
    var queuePlayer = AVQueuePlayer()
    var backgroundMusic: SKAudioNode!
    let DroneTexture = SKTexture(imageNamed: "SquirrelPlane1.png")
    let DroneTexture2 = SKTexture(imageNamed: "SquirrelPlane2.png")
    let DroneTexture3 = SKTexture(imageNamed: "SquirrelPlane3.png")
    let DroneTexture4 = SKTexture(imageNamed: "SquirrelPlane4.png")
    @objc func swipeD() {
        swipe(ID: 4)
    }
    @objc func swipeU() {
        swipe(ID: 2)
    }
    func swipe(ID: Int) {
        if (ID == 4 ) {
            drone.position = CGPoint(x: self.frame.midX, y: (drone.position.y ) - 35)
            }
        if (ID == 2 ) {
            drone.position = CGPoint(x: self.frame.midX, y: (drone.position.y ) + 35)
            }
    }
    

    enum ColliderType: UInt32 {
        case drone = 1
        case Object = 2
        case Gap = 4
    }

    override func didMove(to view: SKView) -> Void {
        self.physicsWorld.contactDelegate = self
        initializeGame()
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        
        
    }

    func initializeGame() -> Void {
        timer = Timer.scheduledTimer(
            timeInterval: 3,
             target: self,
             selector: #selector(self.drawPipes),
             userInfo: nil,
             repeats: true
        )
        backgroundcounter = 1
        drawBackground()
        loadScoreBackground()
        drawdrone()
        drawPipes()
        if let musicURL = Bundle.main.url(forResource: "bensound-sunny", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
    func playjetPulse() {
        guard let url = Bundle.main.url(forResource: "jetPulse", withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }
        
        do {
            audioPlayer = AVPlayer(url: url)
        }
        audioPlayer?.play()
    }
    
    func playCrash() {
        guard let url = Bundle.main.url(forResource: "dronecrash", withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }
        
        do {
            audioPlayer = AVPlayer(url: url)
        }
        audioPlayer?.play()
    }
    func playLevel() {
        guard let url = Bundle.main.url(forResource: "level", withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }
        
        do {
            audioPlayer = AVPlayer(url: url)
        }
        audioPlayer?.play()
    }
    
    
    func drawdrone() -> Void {
        let animations = [DroneTexture, DroneTexture2, DroneTexture3, DroneTexture4, DroneTexture3]
        let animation = SKAction.animate(with: animations, timePerFrame: droneTimePerFrame)
        let makedronejetPulse = SKAction.repeatForever(animation)

        drone = SKSpriteNode(texture: DroneTexture)

        drone.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        drone.run(makedronejetPulse)

        // For colisions
        drone.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0) //dy: -1.8
        drone.physicsBody!.isDynamic = false

        drone.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        drone.physicsBody!.categoryBitMask = ColliderType.drone.rawValue
        drone.physicsBody!.collisionBitMask = ColliderType.drone.rawValue

        self.addChild(drone)

        makeGround()

        self.setScoreStyle()
        self.setScoreTitleStyle()
        self.setHighScoreStyle()
        self.setTitleStyle()
        self.setInstructionsStyle()
        self.setGamePlayStyle()
        self.setSoundStyle()
        
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+375)
        self.addChild(scoreLabel)
        scoreTitleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+450)
        self.addChild(scoreTitleLabel)
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+500)
        self.addChild(highScoreLabel)
        
        titleLabel.position = CGPoint(x: self.frame.midY, y: self.frame.midY-450)
        self.addChild(titleLabel)
        instructionsLabel.position = CGPoint(x: self.frame.midY, y: self.frame.midY-400)
        self.addChild(instructionsLabel)
        gamePlayLabel.position = CGPoint(x: self.frame.midY, y: self.frame.midY-480)
        self.addChild(gamePlayLabel)
        soundStyleLabel.position = CGPoint(x: self.frame.midY, y: self.frame.midY-505)
        self.addChild(soundStyleLabel)
    }
    
    func loadScoreBackground() {
        let back = SKShapeNode(rect: CGRect(x: 0-120, y: 1024-200-30, width: 240, height: 140), cornerRadius: 20)
        back.fillColor = SKColor.black.withAlphaComponent(0.3)
        back.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(back)
    }

    func drawBackground() {
        // Remove existing background nodes
        self.enumerateChildNodes(withName: "background") { node, _ in
            node.removeFromParent()
        }

        let currentBackground = "background" + String(backgroundcounter) + ".png"
        let bgTexture = SKTexture(imageNamed: currentBackground)

        let moveBgAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: bgAnimatedInSecs)
        let shiftBgAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        let bgAnimation = SKAction.sequence([moveBgAnimation, shiftBgAnimation])
        let moveBgForever = SKAction.repeatForever(bgAnimation)

        var i: CGFloat = 0

        while i < maxTimeBgMoving {
            let background = SKSpriteNode(texture: bgTexture)
            background.name = "background" // Set a name to easily identify background nodes
            background.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            background.size.height = self.frame.height
            background.run(moveBgForever)

            self.addChild(background)

            i += 1

            // Set background first
            background.zPosition = -2
        }
    }


    // Draws the pipes and move them around the drone
    @objc func drawPipes() -> Void {
        let multiplier = Int.random(in: 4..<8)
        let gapHeight = drone.size.height * CGFloat(multiplier)

        let movePipes = SKAction.move(
            by: CGVector(dx: -2 * self.frame.width, dy: 0),
            duration: TimeInterval(self.frame.width / 75)
        )

        let removePipes = SKAction.removeFromParent()

        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])

        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4

        makePipe1(moveAndRemovePipes, gapHeight, pipeOffset)
        makePipe2(moveAndRemovePipes, gapHeight, pipeOffset)
        makeGap(moveAndRemovePipes, gapHeight, pipeOffset)
    }

    func didBegin(_ contact: SKPhysicsContact) -> Void {
        if gameOver == false {
            
            if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue ||
                contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
                score += 1
                if score % 5 == 0 || score % 10 == 0 || score % 10 == 5 || score % 5 == 0 || score % 10 == 0 || score % 10 == 5 || score % 5 == 0 || score % 10 == 0 || score % 10 == 5{
                    if totalDistance > 1000 {
                        backgroundcounter = Int.random(in: 1..<14)
                    }
                    else{
                        backgroundcounter = Int.random(in: 1..<13)
                    }
                    let currentBackground = "background" + String(backgroundcounter) + ".png"
                    _ = SKTexture(imageNamed: currentBackground)
                    playLevel()
                    drawBackground()
                    if backgroundcounter == 3 {
                        instructionsLabel.text = "Food Found!"
                        totalFood += 1
                    } else if backgroundcounter == 5 {
                        instructionsLabel.text = "Food Found!"
                        totalFood += 1
                    } else if backgroundcounter == 6 {
                        instructionsLabel.text = "Mushrooms Found!"
                        totalMushrooms += 1
                    } else if backgroundcounter == 7 {
                        instructionsLabel.text = "Water Found!"
                        totalWater += 1
                    } else if backgroundcounter == 8 {
                        instructionsLabel.text = "Water Found!"
                        totalWater += 1
                    } else if backgroundcounter == 13 {
                        instructionsLabel.text = "Animals Found!"
                        totalLife += 1
                    }else{
                        instructionsLabel.text = "Keep Searching..."
                    }
                    
                }
                if score > highScore {
                    highScore = score
                }
                scoreLabel.text = String(score)
                highScoreLabel.text = "Longest Run: " + String(highScore) + " Meters"
                
            } else {
                playCrash()
                totalDistance += score
                resetGame()
                setMessageScoreStyle()
                setGameBeginStyle()
                gameOverLabel.text = "Game Over!"
                gameOverLabel.position = CGPoint(x: self.frame.midY, y: self.frame.midY)
                
                self.addChild(gameOverLabel)
                gameBeginLabel.text = "Swipe screen to restart!"
                gameBeginLabel.position = CGPoint(x: self.frame.midY, y: self.frame.midY-300)
                self.addChild(gameBeginLabel)
                backgroundMusic.run(SKAction.stop())
                //self.backgroundMusic.removeFromParent()
                
            }
        }
    }

    func makePipe1(_ moveAndRemovePipes: SKAction, _ gapHeight: CGFloat, _ pipeOffset: CGFloat) -> Void {
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(
            x: self.frame.midX + self.frame.width,
            y: self.frame.midY + pipeTexture.size().height / 2 + gapHeight / 2 + pipeOffset
        )
        pipe1.run(moveAndRemovePipes)

        pipe1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 65, height: 1650))
        pipe1.physicsBody!.isDynamic = false

        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        setPipePosition(pipe1)

        self.addChild(pipe1)
    }

    func makePipe2(_ moveAndRemovePipes: SKAction, _ gapHeight: CGFloat, _ pipeOffset: CGFloat) -> Void {
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(
            x: self.frame.midX + self.frame.width,
            y: self.frame.midY - pipe2Texture.size().height / 2 - gapHeight / 2  + pipeOffset
        )
        pipe2.run(moveAndRemovePipes)

        pipe2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 65, height: 1650))
        pipe2.physicsBody!.isDynamic = false

        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        setPipePosition(pipe2)

        self.addChild(pipe2)
    }

    // Set the pipe second position after background
    func setPipePosition(_ pipe: SKSpriteNode) -> Void {
        pipe.zPosition = -1
    }

    func makeGap(_ moveAndRemovePipes: SKAction, _ gapHeight: CGFloat, _ pipeOffset: CGFloat) -> Void {
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")

        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffset)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))

        gap.physicsBody!.isDynamic = false
        gap.run(moveAndRemovePipes)

        gap.physicsBody!.contactTestBitMask = ColliderType.drone.rawValue
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue

        self.addChild(gap)
    }

    func makeGround() -> Void {
        let ground = SKNode()
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))

        ground.physicsBody!.isDynamic = false

        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue

        self.addChild(ground)
    }

    func setScoreStyle() -> Void {
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 80
        scoreLabel.text = "0"
    }
    func setScoreTitleStyle() -> Void {
        scoreTitleLabel.fontName = "Helvetica"
        scoreTitleLabel.fontSize = 30
        scoreTitleLabel.text = "Meters Covered"
    }
    func setHighScoreStyle() -> Void {
        highScoreLabel.fontName = "Helvetica"
        highScoreLabel.fontSize = 30
        highScoreLabel.text = "Longest Run: " + String(highScore) + " Meters"
        highScoreLabel.fontColor = UIColor(red: 237/255, green: 231/255, blue: 213/255, alpha: 255)
    }
    func setTitleStyle() -> Void {
        titleLabel.fontName = "Futura-Bold"
        titleLabel.fontSize = 40
        titleLabel.text = "Squirrel Explorer"
    }
    func setInstructionsStyle() -> Void {
        instructionsLabel.fontName = "Helvetica"
        instructionsLabel.fontSize = 40
        instructionsLabel.text = "Swipe Screen to Play"
        instructionsLabel.fontColor = UIColor(red: 237/255, green: 231/255, blue: 213/255, alpha: 255)
    }
    func setGamePlayStyle() -> Void {
        gamePlayLabel.fontName = "Helvetica"
        gamePlayLabel.fontSize = 25
        gamePlayLabel.text = "Swipe up and down to avoid collisions."
        gamePlayLabel.fontColor = UIColor(red: 237/255, green: 231/255, blue: 213/255, alpha: 255)
    }
    func setSoundStyle() -> Void {
        soundStyleLabel.fontName = "Helvetica"
        soundStyleLabel.fontSize = 23
        soundStyleLabel.text = "Turn on the sound to make it more fun!"
        soundStyleLabel.fontColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 255)
    }
    func setMessageScoreStyle() -> Void {
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = UIColor(red: 255, green: 0, blue: 0, alpha: 255)
    }
    func setGameBeginStyle() -> Void {
        gameBeginLabel.fontName = "TrebuchetMS-Italic"
        gameBeginLabel.fontSize = 30
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) -> Void {
        if gameOver == false {
            drone.physicsBody!.isDynamic = true
            drone.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            //Impulse
            drone.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 0))
            playjetPulse()
        } else {
            startGame()
            removeAllChildren()
            StartScreen = false
            initializeGame()
        }
        

    }
    
    func startGame() -> Void {
        gameOver = false
        score = 0
        self.speed = 1
    }

    func resetGame() -> Void {
        self.speed = 0
        gameOver = true
        timer.invalidate()
    }
    
}

