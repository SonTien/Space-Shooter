//
//  MeteorView.swift
//  SpaceShooter
//
//  Created by HoangHai on 6/25/16.
//  Copyright © 2016 Tien Son. All rights reserved.
//

import UIKit

class MeteorView: UIImageView {
    var status : Int?
    var speed : Int?
    var radian = CGFloat()
    var radius = CGFloat()
    var vy = 0
    var widthFrame : Int?
    var heightFrame : Int?
    var widthMete : Int?
    var heightMete : Int?
    let MOVE : Int = 0
    let DES : Int = 1
    let imgT = Int(arc4random_uniform(10))
    
    
    override init(frame: CGRect)
    {
        self.widthMete = Int(frame.width)
        self.heightMete = Int(frame.height)
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spinMete()
    {
        let deltaAngle: CGFloat = 0.1
        radius = 32
        radian = radian + deltaAngle
        self.transform = CGAffineTransformMakeRotation(radian)
        self.center = CGPointMake(self.center.x + deltaAngle*radius, self.center.y)
    }

    func generateMete(width:Int)
    {
        self.widthFrame = width;
        self.vy = Int(arc4random_uniform(5)) - 1
        let y: Float = Float(arc4random_uniform(470) + 50)
        self.status = MOVE
        self.speed = Int(arc4random_uniform(5) + 2)
        if (Int(self.center.x) <= Int(self.widthMete!/2))
        {
            self.transform = CGAffineTransformIdentity
            if (imgT == 1 && imgT == 2 && imgT == 3 && imgT == 4 && imgT == 5)
            {
                self.image = UIImage(named: "mete1.png")
            }
            if (imgT == 6 && imgT == 7)
            {
                self.image = UIImage(named: "mete2.png")
            }
            if (imgT == 8)
            {
                self.image = UIImage(named: "mete3.png")
            }
            if (imgT == 9)
            {
                self.image = UIImage(named: "mete4.png")
            }
            self.frame = CGRectMake(-CGFloat(self.widthMete!), CGFloat(y), CGFloat(self.widthMete!), CGFloat(self.heightMete!))
        }
    }

    func updateMove()
    {
        if (self.status == MOVE)
        {
            self.center = CGPointMake(self.center.x + CGFloat(self.speed!), self.center.y - CGFloat(self.vy))
            if ((Int(self.center.x) > self.widthFrame! && self.speed! > 0) || (Int(self.center.x) < -self.widthMete! && self.speed! < 0))
            {
                generateMete(self.widthFrame!)
            }
        }
        else if (self.status == DES)
        {
            self.image = UIImage(named: "expl.png")
        }
        
    }
}
