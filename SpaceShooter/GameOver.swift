//
//  GameOver.swift
//  SpaceShooter
//
//  Created by HoangHai on 7/18/16.
//  Copyright © 2016 Tien Son. All rights reserved.
//

import UIKit

class GameOver: UIViewController {
    var starBackground1 = UIImageView()
    var starBackground2 = UIImageView()
    var timer3 = NSTimer()
    var score = 0

    @IBAction func tryAgain(sender: AnyObject) {
        let playAgain = self.storyboard?.instantiateViewControllerWithIdentifier("MainVC") as! ViewController
        self.navigationController!.pushViewController(playAgain, animated: false)
    }
    @IBOutlet weak var scorePrint: UILabel!
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
    scorePrint.text = String(score)+" $"
    super.viewDidAppear(animated)
    
}
    
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

}