//
//  Blalajljdad.swift
//  SpaceShooter
//
//  Created by HoangHai on 7/12/16.
//  Copyright © 2016 Tien Son. All rights reserved.
//

import UIKit

class Blalajljdad: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    var photo: [UIImageView] = []
    var pageImages: [String] = []
    var frontScrollViews: [UIScrollView] = []
    var first = false
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImages = ["tut", "tut2", "tut3"]
        pageControl.numberOfPages = pageImages.count
    
    }

}
