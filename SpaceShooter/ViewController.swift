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

    var starBackground1 = UIImageView()
    var starBackground2 = UIImageView()
    var stop = CGPoint()
    var timer1 = NSTimer()
    var timer2 = NSTimer()
    var timer3 = NSTimer()
    var backgroundMusic = AVAudioPlayer()
    var shipMusic = AVAudioPlayer()
    var readySound = AVAudioPlayer()
    var checkPlayReady = false
    override func viewDidLoad()
    {
        playSong()
        NSTimer.scheduledTimerWithTimeInterval(1/15, target: self, selector: (#selector(ViewController.updateFire)), userInfo: nil, repeats: true)
        powerBar.setProgress(0, animated: true)
    }

    func playSong()
    {
        let filePath = NSBundle.mainBundle().pathForResource("spaceMusic", ofType: ".mp3")
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
        shipMusic.play()
        shipMusic.numberOfLoops = -1
        shipMusic.volume = 3
    }
    
    func ready()
    {
        checkPlayReady = true
        let filePath = NSBundle.mainBundle().pathForResource("ready", ofType: ".mp3")
        let url = NSURL(fileURLWithPath: filePath!)
        readySound = try!AVAudioPlayer(contentsOfURL: url)
        readySound.prepareToPlay()
        readySound.play()
        readySound.volume = 3
    }
   
    override func viewDidAppear(animated: Bool)
    {
//background's speed and coordinates
        starBackground1 = UIImageView(image: UIImage(named: "star1.jpg"))
        starBackground1.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
        starBackground2 = UIImageView(image: UIImage(named: "star2.jpg"))
        starBackground2.frame = CGRectMake(0, -starBackground1.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)
        self.view.addSubview(starBackground1)
        self.view.addSubview(starBackground2)
        super.viewDidLoad()
        self.view.sendSubviewToBack(starBackground1)
        self.view.sendSubviewToBack(starBackground2)
        timer3 = NSTimer.scheduledTimerWithTimeInterval(1/60, target: self, selector: #selector(background), userInfo: nil, repeats: true)
        background()
        super.viewDidAppear(animated)
    }
    
//connection to ShipView
    @IBOutlet weak var Ship: ShipView!
    
//buttons to turn left and right
    @IBAction func touchDownRight(sender: UIButton) {
        timer2 = NSTimer.scheduledTimerWithTimeInterval(1/60, target: self, selector: #selector(turnRight), userInfo: nil, repeats: true)
        shipSound()
    }
    @IBAction func touchDownLeft(sender: AnyObject) {
        timer1 = NSTimer.scheduledTimerWithTimeInterval(1/60, target: self, selector: #selector(turnLeft), userInfo: nil, repeats: true)
        shipSound()
    }
    @IBAction func touchUpLeft(sender: AnyObject) {
        timer1.invalidate()
        Ship.image = UIImage(named: "centerShip.png")
        shipMusic.stop()
    }
    @IBAction func touchUpRight(sender: AnyObject) {
        timer2.invalidate()
        Ship.image = UIImage(named: "centerShip.png")
        shipMusic.stop()
    }
    
//turning between left and right functions
    func turnLeft() {
        Ship.image = UIImage(named: "leftShip.png")
        Ship.center = CGPointMake(Ship!.center.x - 5, Ship!.center.y)
        stop = Ship.center
    }
    func turnRight() {
        Ship.image = UIImage(named: "rightShip.png")
        Ship.center = CGPointMake(Ship!.center.x + 5, Ship!.center.y)
    }

//infinite scrolling background image
    func background() {
        starBackground1.center = CGPointMake(starBackground1.center.x, starBackground1.center.y + 1)
        starBackground2.center = CGPointMake(starBackground2.center.x, starBackground2.center.y + 1)
        
        if(starBackground1.frame.origin.y >= self.view.bounds.height){
            starBackground1.frame = CGRectMake(0, -starBackground1.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)
            }
        if(starBackground2.frame.origin.y >= self.view.bounds.height){
            starBackground2.frame = CGRectMake(0, -starBackground1.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)
        }
    }
    @IBOutlet var powerBar: UIProgressView!
    @IBOutlet weak var bomb: UIButton!
    @IBOutlet weak var shield: UIButton!
    @IBOutlet weak var shock: UIButton!
    @IBOutlet weak var double: UIButton!

    func updateFire()
    {
        if (powerBar.progress != 1)
        {
            self.powerBar.progress += 0.01
            bomb.setImage(UIImage(named: "bombGrey.png"), forState: .Normal)
            shield.setImage(UIImage(named: "shieldGrey.png"), forState: .Normal)
            shock.setImage(UIImage(named: "shockGrey.png"), forState: .Normal)
            double.setImage(UIImage(named: "doubleGrey.png"), forState: .Normal)
            
        } else if (checkPlayReady == false){
            ready()
            bomb.setImage(UIImage(named: "bomb.png"), forState: .Normal)
            shield.setImage(UIImage(named: "shield.png"), forState: .Normal)
            shock.setImage(UIImage(named: "shock.png"), forState: .Normal)
            double.setImage(UIImage(named: "double.png"), forState: .Normal)
            }
    }
}