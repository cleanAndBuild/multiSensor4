//
//  FirstViewController.swift
//  multiSensor
//
//  Created by Yako Kobayashi on 2018/03/05.
//  Copyright © 2018年 Yako Kobayashi. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController {
    
    @IBOutlet var labelAltitude: UILabel!
    @IBOutlet var labelLatitude: UILabel!
    @IBOutlet var labelLongitude: UILabel!
    @IBOutlet var labelHaccuracy: UILabel!
    @IBOutlet var labelVaccuracy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //座標などのラベルを更新する
    func updateLocation(_ location:CLLocation?) {
        
        //位置情報を正しく取得できていたら
        if let location = location {
            //画面のラベルに位置情報を表示する
            labelAltitude?.text = String(format:"%.2fm",location.altitude)
            
            labelLatitude?.text = String(format:"%.5f",location.coordinate.latitude)
            labelLongitude?.text = String(format:"%.5f",location.coordinate.longitude)
            
            labelHaccuracy?.text = String(format:"%.2fm",location.horizontalAccuracy)
            labelVaccuracy?.text = String(format:"%.2fm",location.verticalAccuracy)
        }
    }


}

