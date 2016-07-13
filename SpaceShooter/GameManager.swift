//
//  GameManager.swift
//  SpaceShooter
//
//  Created by HoangHai on 6/25/16.
//  Copyright © 2016 Tien Son. All rights reserved.
//

import UIKit

class GameManager: NSObject {
    var meteView : NSMutableArray?
    var bulletView : Bullet?
    var scoreCount = 0
    var score: UILabel!
    override init() {
        self.meteView = NSMutableArray()
        self.bulletView = Bullet(frame: CGRectMake(0, -490, 20, 490))
    }
    
    func addMete(viewcontroller: UIViewController, width: Int) {
        let meteView1 = MeteorView(frame: CGRectMake(0, 0, 40, 30))
        meteView1.generateMete(width)
        self.meteView?.addObject(meteView1)
        viewcontroller.view.addSubview(meteView1)
    }
    
    func hit(meteView1: MeteorView) {
        if (meteView1.status != meteView1.DES && self.bulletView?.status != self.bulletView?.MISS && self.bulletView?.status != self.bulletView?.HIT) {
            meteView1.status = meteView1.DES
            meteView1.center = CGPointMake(self.bulletView!.center.x, self.bulletView!.frame.origin.y + self.bulletView!.frame.height + meteView1.frame.width/2)
            if (self.bulletView?.status != self.bulletView?.HIT)
            {
                scoreCount += 100
                score.text = String(scoreCount)
            }
            self.bulletView?.status = self.bulletView?.HIT
        }
    }
    
    func updateMove() {
        self.bulletView?.updateMove()
        for meteView1 in self.meteView! {
            meteView1.updateMove()
        if (CGRectContainsPoint(meteView1.frame, CGPointMake(self.bulletView!.center.x, self.bulletView!.frame.origin.y + self.bulletView!.frame.height + meteView1.frame.width/2)))
            {
                hit(meteView1 as! MeteorView)
            }
        }
    }
    
    func dropHookAtY(y: Int) {
        self.bulletView?.dropDownAtY(y)
    }

}
