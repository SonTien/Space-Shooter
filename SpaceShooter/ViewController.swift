//
//  ViewController.swift
//  SpaceShooter
//
//  Created by HoangHai on 6/25/16.
//  Copyright © 2016 Tien Son. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    var Background1 = UIImageView()
    var Background2 = UIImageView()
    var timer1 : NSTimer!
    var timer2 : NSTimer!
    var timer3 = NSTimer()
    var backgroundMusic = AVAudioPlayer()
    var shipMusic = AVAudioPlayer()
    var readySound = AVAudioPlayer()
    var laserSound = AVAudioPlayer()
    var healSound = AVAudioPlayer()
    var checkPlayReady = false
    var powerManager = PowerView()
    var gameManager : GameManager?
    var add = NSTimer()
    var addBul = NSTimer()
    var healthCount = NSTimer()
    var powerCount = NSTimer()
    var over = UINavigationController()
    
    @IBOutlet weak var energy: UIImageView!
    @IBOutlet weak var img_Progress: UIImageView!
    @IBOutlet weak var heal: UIButton!
    @IBOutlet weak var shield: UIButton!
    @IBOutlet weak var missile: UIButton!
    @IBOutlet weak var double: UIButton!
    @IBAction func ac_heal(sender: AnyObject) {
        checkPlayReady = false
        if (gameManager!.powerBar < 3)
        {
            return
        }
        gameManager!.powerBar = 0
        gameManager!.progressValue = 10
        let filePath = NSBundle.mainBundle().pathForResource("healSound", ofType: ".wav")
        let url = NSURL(fileURLWithPath: filePath!)
        healSound = try!AVAudioPlayer(contentsOfURL: url)
        healSound.prepareToPlay()
        healSound.volume = 3
        healSound.play()
        
        
    }
    @IBOutlet weak var leftPress: UIButton!
    @IBOutlet weak var rightPress: UIButton!
    
    @IBAction func ac_double(sender: AnyObject) {
        checkPlayReady = false
        if (gameManager!.powerBar < 3)
        {
            return
        }
        gameManager!.powerBar = 0
        let filePath = NSBundle.mainBundle().pathForResource("laserRape", ofType: ".wav")
        let url = NSURL(fileURLWithPath: filePath!)
        laserSound = try!AVAudioPlayer(contentsOfURL: url)
        laserSound.play()
        backgroundMusic.pause()
        powerManager.doubleShootBack()
        addBul.invalidate()
        addBul = NSTimer.scheduledTimerWithTimeInterval(0.09, target: self, selector: (#selector(ViewController.addBullet2)), userInfo: nil, repeats: true)
    }
   
    @IBAction func ac_oneHit(sender: AnyObject) {
        powerManager.lightPower(self)
    }
    
    @IBOutlet weak var score: UILabel!
    //connection to ShipView
    @IBOutlet weak var ship: ShipView!
    override func viewDidLoad()
    {
        
        shipSound()
        shootSound()
        playSong()
        powerManager.doubleSound.delegate = self
        self.gameManager = GameManager()
        self.gameManager?.ship = ship
        add = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: (#selector(ViewController.addMete2)), userInfo: nil, repeats: true)
        addBul = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: (#selector(ViewController.addBullet2)), userInfo: nil, repeats: true)
        
        self.gameManager?.addMete(self, height: Int(self.view.bounds.height))
        
        NSTimer.scheduledTimerWithTimeInterval(1/60, target: self.gameManager!, selector: (#selector(gameManager!.updateMove)), userInfo: nil, repeats: true)
        powerCount = NSTimer.scheduledTimerWithTimeInterval(1/20, target: self, selector: (#selector(ViewController.updatePower)), userInfo: nil, repeats: true)
        healthCount = NSTimer.scheduledTimerWithTimeInterval(1/20, target: self, selector: (#selector(ViewController.hitShip)), userInfo: nil, repeats: true)
        gameManager!.score = score
        let bullet = Bullet(frame: CGRect(x: ship.center.x, y: ship.center.y - ship.bounds.size.height - 10, width: 20, height: 50))
        self.gameManager?.bulletView.append(bullet)
        self.view.addSubview((self.gameManager?.bulletView[0])! )
        ship.layer.zPosition = 1
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool){
        addBul.invalidate()
        addBul = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: (#selector(ViewController.addBullet2)), userInfo: nil, repeats: true)
        powerManager.doubleSound.stop()
        backgroundMusic.play()
        shootSound()
        laserSound.play()
    }
    
    func playSong()
    {
        let filePath = NSBundle.mainBundle().pathForResource("spaceMusicNor", ofType: ".mp3")
        let url = NSURL(fileURLWithPath: filePath!)
        backgroundMusic = try!AVAudioPlayer(contentsOfURL: url)
        backgroundMusic.prepareToPlay()
        backgroundMusic.play()
        backgroundMusic.numberOfLoops = -1
    }
    
    func shipSound()
    {
        let filePath = NSBundle.mainBundle().pathForResource("shipSound1", ofType: ".wav")
        let url = NSURL(fileURLWithPath: filePath!)
        shipMusic = try!AVAudioPlayer(contentsOfURL: url)
        shipMusic.prepareToPlay()
        shipMusic.numberOfLoops = -1
    }
    
    func ready()
    {
        checkPlayReady = true
        let filePath = NSBundle.mainBundle().pathForResource("ready", ofType: ".mp3")
        let url = NSURL(fileURLWithPath: filePath!)
        readySound = try!AVAudioPlayer(contentsOfURL: url)
        readySound.prepareToPlay()
        readySound.play()
    }
   
    func shootSound()
    {
        let filePath = NSBundle.mainBundle().pathForResource("laserShoot", ofType: ".wav")
        let url = NSURL(fileURLWithPath: filePath!)
        laserSound = try!AVAudioPlayer(contentsOfURL: url)
        laserSound.prepareToPlay()
        laserSound.volume = -1
    }


    override func viewDidAppear(animated: Bool)
    {
//background's speed and coordinates
            Background1 = UIImageView(image: UIImage(named: "star1.jpg"))
            Background2 = UIImageView(image: UIImage(named: "star2.jpg"))
        Background1.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
        Background2.frame = CGRectMake(0, -Background1.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)
        self.view.addSubview(Background1)
        self.view.addSubview(Background2)
        super.viewDidLoad()
        self.view.sendSubviewToBack(Background1)
        self.view.sendSubviewToBack(Background2)
        timer3 = NSTimer.scheduledTimerWithTimeInterval(1/60, target: self, selector: #selector(background), userInfo: nil, repeats: true)
        background()
        super.viewDidAppear(animated)
    }
    

    
//buttons to turn left and right
    @IBAction func touchDownRight(sender: UIButton) {
        timer2 = NSTimer.scheduledTimerWithTimeInterval(1/60, target: self, selector: #selector(turnRight), userInfo: nil, repeats: true)
        shipMusic.play()
    }
    @IBAction func touchDownLeft(sender: AnyObject) {
        timer1 = NSTimer.scheduledTimerWithTimeInterval(1/60, target: self, selector: #selector(turnLeft), userInfo: nil, repeats: true)
        shipMusic.play()

    }
    @IBAction func touchUpLeft(sender: AnyObject) {
        timer1.invalidate()
        if (gameManager!.progressValue == 2){
            ship.image = UIImage(named: "shipHurt.png")
        }
        else
        {
        ship.image = UIImage(named: "centerShip.png")
        }
        shipMusic.stop()
    }
    @IBAction func touchUpRight(sender: AnyObject) {
        timer2.invalidate()
        if (gameManager!.progressValue == 2){
            ship.image = UIImage(named: "shipHurt.png")
        }
        else
        {
            ship.image = UIImage(named: "centerShip.png")
        }
        shipMusic.stop()
    }
    
//turning between left and right functions
    func turnLeft() {
        if (gameManager!.progressValue == 2){
            ship.image = UIImage(named: "leftShipHurt.png")
        }
        else
        {
            ship.image = UIImage(named: "leftShip.png")
        }
        ship.center = CGPointMake(ship!.center.x - 5, ship!.center.y)
        if (ship.center.x <= 200)
        {
            timer1.invalidate()
            ship.center.x = 200
        }
    }
    func turnRight() {
        if (gameManager!.progressValue == 2){
            ship.image = UIImage(named: "rightShipHurt.png")
        }
        else
        {
            ship.image = UIImage(named: "rightShip.png")
        }
        ship.center = CGPointMake(ship!.center.x + 5, ship!.center.y)
        if (ship.center.x >= self.view.bounds.width - 200)
        {
            timer2.invalidate()
            ship.center.x = self.view.bounds.width - 200
        }
    }

//infinite scrolling background image
    func background() {
        Background1.center = CGPointMake(Background1.center.x, Background1.center.y + 1)
        Background2.center = CGPointMake(Background2.center.x, Background2.center.y + 1)
        
        if(Background1.frame.origin.y >= self.view.bounds.height){
            Background1.frame = CGRectMake(0, -Background1.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)
            }
        if(Background2.frame.origin.y >= self.view.bounds.height){
            Background2.frame = CGRectMake(0, -Background1.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)
        }
    }
    
    func addMete2()
    {
        self.gameManager?.addMete(self, height: Int(self.view.bounds.height))
    }
    
    func addBullet2()
    {
        self.gameManager?.addBullet(self, size: CGSize(width: 10, height: 20), point: ship.center)
        laserSound.play()
    }
    
    func hitShip(){
        if (gameManager!.progressValue == 10){
            img_Progress.image = UIImage(named: "healthFull")
        }
        if (gameManager!.progressValue == 8){
            img_Progress.image = UIImage(named: "healthBar1")
        }
        if (gameManager!.progressValue == 6){
            img_Progress.image = UIImage(named: "healthBar2")
        }
        if (gameManager!.progressValue == 4){
            img_Progress.image = UIImage(named: "healthBar3")
        }
        if (gameManager!.progressValue == 2){
            img_Progress.image = UIImage(named: "healthBar4")
        }
        if (gameManager!.progressValue == 0){
            shipDie()
            NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: (#selector(ViewController.gameOver)), userInfo: true, repeats: false)
        }
    }
    
    func updatePower()
    {
        if (gameManager?.powerBar == 0)
        {
            energy.image = UIImage(named: "eneNo.png")
        }
        if (gameManager?.powerBar == 1)
        {
            energy.image = UIImage(named: "eneLow.png")
        }
        if (gameManager?.powerBar == 2)
        {
            energy.image = UIImage(named: "eneMed.png")
        }
        if (gameManager?.powerBar == 3)
        {
            energy.image = UIImage(named: "eneFull.png")
        }
        
        if (gameManager?.powerBar == 0)
        {
            heal.setImage(UIImage(named: "heal1Grey.png"), forState: .Normal)
            shield.setImage(UIImage(named: "shield1Grey.png"), forState: .Normal)
            missile.setImage(UIImage(named: "missile1Grey.png"), forState: .Normal)
            double.setImage(UIImage(named: "double1Grey.png"), forState: .Normal)
            
        } else if (gameManager?.powerBar == 3){
            if (checkPlayReady == false){
            ready()
            heal.setImage(UIImage(named: "heal1.png"), forState: .Normal)
            shield.setImage(UIImage(named: "shield1.png"), forState: .Normal)
            missile.setImage(UIImage(named: "missile1.png"), forState: .Normal)
            double.setImage(UIImage(named: "double1.png"), forState: .Normal)
            }
        }
}

    func shipDie()
    {
        img_Progress.hidden = true
        healthCount.invalidate()
        timer1.invalidate()
        timer2.invalidate()
        timer3.invalidate()
        add.invalidate()
        addBul.invalidate()
        healthCount.invalidate()
        leftPress.hidden = true
        rightPress.hidden = true
        heal.hidden = true
        shield.hidden = true
        missile.hidden = true
        double.hidden = true
        energy.hidden = true
        gameManager?.score.hidden = true
        backgroundMusic.stop()
        laserSound.stop()
        shipMusic.stop()
        ship.animationImages = [UIImage(named:"shipHurt.png")!,
                                UIImage(named:"shipDie.png")!,
                                UIImage(named:"shipDie2.png")!]
        ship.image = UIImage(named: "shipDie2.png")
        ship.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, ship.image!.size.width, ship.image!.size.height)
        ship.center.x = self.view.center.x
        ship.center.y = self.view.center.y
        ship.animationDuration = 0.5
        ship.animationRepeatCount = 1
        ship.startAnimating()

    }
    
    func gameOver()
    {
        let gameOver = self.storyboard?.instantiateViewControllerWithIdentifier("end") as! GameOver
        gameOver.score = gameManager!.scoreCount
        self.navigationController!.pushViewController(gameOver, animated: false)
    }

}