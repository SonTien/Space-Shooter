//
//  GameManager.swift
//  SpaceShooter
//
//  Created by HoangHai on 6/25/16.
//  Copyright © 2016 Tien Son. All rights reserved.
//

import UIKit
import AVFoundation

class GameManager: NSObject, AVAudioPlayerDelegate {
    var meteView: [MeteorView] = []
    var bulletView: [Bullet] = []
    var ship : ShipView!
    var mainView = ViewController()
    var scoreCount = 0
    var score: UILabel!
    var progressValue = 10
    var powerBar = 0
    var crashSound = AVAudioPlayer()
    var oneHitOn = false
    override init()
    {
        super.init()
        self.meteView = []
        self.bulletView = []
        let filePath = NSBundle.mainBundle().pathForResource("crash", ofType: ".wav")
        let url = NSURL(fileURLWithPath: filePath!)
        crashSound = try!AVAudioPlayer(contentsOfURL: url)
        crashSound.prepareToPlay()
    }
    
    
    func getSize(imgT:Int) -> CGSize
    {
        
        if (imgT >= 0 && imgT < 5)
        {
            return (UIImage(named: "mete1.png")?.size)!
        }
        if (imgT == 5)
        {
            return (UIImage(named: "mete2.png")?.size)!
        }
        if (imgT == 6)
        {
            return (UIImage(named: "mete3.png")?.size)!
        }
        if (imgT == 7)
        {
            return (UIImage(named: "mete4.png")?.size)!
        }
        if (imgT == 8)
        {
            return (UIImage(named: "energy.png")?.size)!
        }
        if (imgT == 9)
        {
            return (UIImage(named: "notNiceMete.png")?.size)!
        }
        return CGSizeZero
    }
    func addMete(viewcontroller: UIViewController, height: Int) {
        let imgT = Int(arc4random_uniform(10))
        let size = getSize(imgT)
        let meteView1 = MeteorView(frame: CGRectMake(0, 0, size.width / 2, size.height / 2))
        meteView1.imgT = imgT
        meteView1.generateMete(height)
        self.meteView.append(meteView1)
        viewcontroller.view.addSubview(meteView1)
    }
    
    func addBullet(viewcontroller: UIViewController, size: CGSize, point: CGPoint)
    {
        let bullet = Bullet(frame: CGRectMake(point.x, point.y, size.width, size.height))
        bulletView.append(bullet)
        viewcontroller.view.addSubview(bullet)
    }
    
    func hit()
    {
        for currentBullet in bulletView
        {
            print(bulletView.count)
            if (currentBullet.status == currentBullet.OUT || currentBullet.status == currentBullet.HIT)
            {
                if let index = self.bulletView.indexOf(currentBullet)
                {
                    self.bulletView.removeAtIndex(index)
                }
            }
            for currentMeteor in meteView{
                print(meteView.count)
                if (currentMeteor.status == currentMeteor.OUT)
                {
                    if let index = self.meteView.indexOf(currentMeteor)
                    {
                        self.meteView.removeAtIndex(index)
                    }
                }
                else if(CGRectIntersectsRect(currentBullet.frame, currentMeteor.frame) && currentBullet.status != currentBullet.HIT && currentMeteor.meteHP != 0){
                    MeteorView.animateWithDuration(0.1, animations: {currentMeteor.alpha = 0.5}, completion: { (finshed) in
                        MeteorView.animateWithDuration(0.1, animations: {currentMeteor.alpha = 1}, completion: { (finished) in
                            MeteorView.animateWithDuration(0.1, animations: {currentMeteor.alpha = 0.5}, completion: { (finished) in
                                currentMeteor.alpha = 1
                            })
                        })
                    })
                    currentMeteor.meteHP -= 1
                    if (currentMeteor.meteHP == 0){
                        if (currentMeteor.imgT >= 0 && currentMeteor.imgT < 5){
                            scoreCount += 100
                        }
                        if (currentMeteor.imgT == 5){
                            scoreCount += 200
                        }
                        if (currentMeteor.imgT == 6){
                            scoreCount += 300
                        }
                        if (currentMeteor.imgT == 7){
                            scoreCount += 400
                        }
                        if (currentMeteor.imgT == 8){
                            scoreCount += 1000
                        }
                        if (currentMeteor.imgT == 9){
                            progressValue -= 2
                        }
                    }
                    score.text = String(scoreCount)+" $"
                    currentBullet.status = currentBullet.HIT
            }
            }
        }
    }
    
    func crash()
    {
        
        for currentMeteor in meteView{
            if (CGRectIntersectsRect(CGRectMake(ship.center.x, ship.center.y, ship.bounds.width, ship.bounds.height), CGRectMake(currentMeteor.center.x, currentMeteor.center.y, currentMeteor.bounds.width - 10, currentMeteor.bounds.height - 30))){
                if let index = self.meteView.indexOf(currentMeteor){
                    if (currentMeteor.meteHP != 0 && currentMeteor.status != currentMeteor.OUT)
                    {
                        currentMeteor.meteHP = 0
                        if (currentMeteor.imgT == 8)
                        {
                            powerBar += 1
                            progressValue += 0
                        }
                        
                        else
                        {
                            progressValue -= 2
                        }
                        
                        
                        crashSound.play()
                        ShipView.animateWithDuration(0.2, animations: {self.ship.alpha = 0.5}, completion: { (finished) in
                            ShipView.animateWithDuration(0.2, animations: {self.ship.alpha = 1}, completion: { (finished) in
                                ShipView.animateWithDuration(0.2, animations: {self.ship.alpha = 0.5}, completion: { (finished) in
                                    self.ship.alpha = 1
                                    })
                                })
                            })
                    }
                    if (currentMeteor.status == currentMeteor.OUT){
                        currentMeteor.removeFromSuperview()
                        self.meteView.removeAtIndex(index)
                    }
                }
                
                if (currentMeteor.status == currentMeteor.OUT)
                {
                    if let index = self.meteView.indexOf(currentMeteor)
                    {
                        self.meteView.removeAtIndex(index)
                    }
                }
            }
        }
    }
    
    func updateMove()
    {
        crash()
        hit()
        for meteor in self.meteView
        {
            meteor.updateMete()

        }
    }
}



