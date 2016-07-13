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
    var rapidFire = NSTimer()
    var status : Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "fire1.png")
        self.status = SHOOT
        rapidFire = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: (#selector(Bullet.updateMove)), userInfo: nil, repeats: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMove() {
        if (self.status == SHOOT)
        {
            self.center = CGPointMake(self.center.x - 10, self.center.y)
            if (self.frame.origin.y + self.frame.height > 480)
            {
                self.status = MISS
            }
        }
        else if (self.status == MISS)
        {
            self.center = CGPointMake(self.center.x - 10, self.center.y)
            if (self.frame.origin.y + self.frame.height < 0)
            {
                print("miss")
            }
        }
        else if (self.status == HIT)
        {
            self.alpha = 0
            print("hit")
        }
    }
    
    func dropDownAtY(y: Int) {
        if (self.status == SHOOT) {
            self.center = CGPointMake(self.center.x, CGFloat(y))
        }
    }
}
