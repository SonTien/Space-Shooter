//
//  PowerView.swift
//  SpaceShooter
//
//  Created by HoangHai on 7/4/16.
//  Copyright © 2016 Tien Son. All rights reserved.
//

import UIKit
import AVFoundation

class PowerView: NSObject, AVAudioPlayerDelegate {
    var doubleSound = AVAudioPlayer()
    var lightHit = UIImageView()
    override init() {
        let filePath = NSBundle.mainBundle().pathForResource("double", ofType: ".wav")
        let url = NSURL(fileURLWithPath: filePath!)
        doubleSound = try!AVAudioPlayer(contentsOfURL: url)
        doubleSound.prepareToPlay()
        doubleSound.volume = 5
    }
    func doubleShootBack() {
        doubleSound.play()
    }

    func lightPower(viewcontroller: UIViewController)
        {
            lightHit.center = CGPointMake(300, 200)
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(PowerView.moveLight), userInfo: nil, repeats: false)
            lightHit.animationImages = [UIImage(named: "light1.png")!,
                                        UIImage(named: "light2.png")!,
                                        UIImage(named: "light3.png")!,
                                        UIImage(named: "light4.png")!,
                                        UIImage(named: "light5.png")!,
                                        UIImage(named: "light6.png")!]
            lightHit.animationDuration = 0.5
            lightHit.animationRepeatCount = 0
            lightHit.startAnimating()
            viewcontroller.view.addSubview(lightHit)
            
        }
    
    func moveLight()
    {
        lightHit.center = CGPointMake(300, 100)
    }
    
}
