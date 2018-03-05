//
//  SecondViewController.swift
//  multiSensor
//
//  Created by Yako Kobayashi on 2018/03/05.
//  Copyright © 2018年 Yako Kobayashi. All rights reserved.
//

import UIKit
import CoreLocation

class SecondViewController: UIViewController {
    
    @IBOutlet var labelDegree: UILabel!
    @IBOutlet var imagePointer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateHeading(_ newHeading: CLHeading) {
        labelDegree?.text = String(format:"%.2f°",newHeading.trueHeading)
        
        let angle:CGFloat = CGFloat(-Double.pi * newHeading.trueHeading / 180.0) //ラジアンを求める
        imagePointer?.transform = CGAffineTransform(rotationAngle: angle) //コンパスの画像を回転させる
        
        NSLog("angle:%.3f",angle)
    }

}

