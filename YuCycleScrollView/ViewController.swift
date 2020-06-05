//
//  ViewController.swift
//  YuCycleScrollView
//
//  Created by Ai on 2020/6/5.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


        let cycleScrollView = CYcleScrollView(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: 200))
        cycleScrollView.images = ["1","2","3"]
        view.addSubview(cycleScrollView)
        
    }


}

