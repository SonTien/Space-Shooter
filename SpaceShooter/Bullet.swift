//
//  Bullet.swift
//  SpaceShooter
//
//  Created by HoangHai on 6/29/16.
//  Copyright © 2016 Tien Son. All rights reserved.
//

import UIKit
import AVFoundation

class Bullet: UIImageView, AVAudioPlayerDelegate {
    let SHOOT = 0
    let MISS = 1
    let HIT = 2
    let OUT = 3
    var rapidFire = NSTimer()
    var status : Int?
    var meteHit = AVAudioPlayer()
    var checkSound = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "redLaserRay.png")
        self.status = SHOOT
        rapidFire = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: (#selector(Bullet.updateMove)), userInfo: nil, repeats: true)
        let filePath = NSBundle.mainBundle().pathForResource("meteHit", ofType: ".wav")
        let url = NSURL(fileURLWithPath: filePath!)
        meteHit = try!AVAudioPlayer(contentsOfURL: url)
        meteHit.prepareToPlay()
        meteHit.numberOfLoops = 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hitSound()
    {
        if (checkSound == false)
        {
            checkSound = true
            meteHit.play()
        }

    }

    
    func updateMove() {
        if (self.status == SHOOT)
        {
            self.center = CGPointMake(self.center.x, self.center.y - 5)
            if (self.frame.origin.y + self.frame.height < 50)
            {
                self.status = MISS
           }
        }
        else if (self.status == MISS)
        {
            self.center = CGPointMake(self.center.x, self.center.y - 5)
            if (self.frame.origin.y + self.frame.height <= 70)
            {
            self.removeFromSuperview()
            }
        }
        else if (self.status == HIT)
        {
            hitSound()
            self.center = CGPointMake(self.center.x, self.center.y)
            self.removeFromSuperview()
        }
        
        if (self.frame.origin.y + self.frame.height <= 70)
        {
            self.status = OUT
            rapidFire.invalidate()
            self.removeFromSuperview()
        }
    }
}
