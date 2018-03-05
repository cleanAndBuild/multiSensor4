//
//  etcSensorViewController.swift
//  multiSensor
//
//  Created by Yako Kobayashi on 2018/03/05.
//  Copyright © 2018年 Yako Kobayashi. All rights reserved.
//

import UIKit
import CoreMotion

class etcSensorViewController: UIViewController {

    @IBOutlet var labelTitle: UILabel!
    
    @IBOutlet var labelAltitude: UILabel!
    @IBOutlet var labelPressure: UILabel!
    
    @IBOutlet var labelAccX: UILabel!
    @IBOutlet var labelAccY: UILabel!
    @IBOutlet var labelAccZ: UILabel!
    
    @IBOutlet var labelGyroX: UILabel!
    @IBOutlet var labelGyroY: UILabel!
    @IBOutlet var labelGyroZ: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.text = "いろんなセンサー"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //気圧ラベルを更新
    func updateAltimeter(_ data:CMAltitudeData) {
        let pressure:Double = Double(truncating: data.pressure)
        let altitude:Double = Double(truncating: data.relativeAltitude)
        labelPressure?.text = String(format: "気圧:%.1f hPa",pressure*10)
        labelAltitude?.text = String(format: "高さ:%.2f m",altitude)
    }
    
    //重力加速度計ラベルを更新
    func updateAccelerometer(_ data:CMAccelerometerData) {
        
        labelAccX?.text = String(format: "加速度X:%.3f",data.acceleration.x)
        labelAccY?.text = String(format: "加速度Y:%.3f",data.acceleration.y)
        labelAccZ?.text = String(format: "加速度Z:%.3f",data.acceleration.z)
        
    }
    
    //ジャイロラベルを更新
    func updateGyro(_ data:CMGyroData) {
        labelGyroX?.text = String(format:"ジャイロX:%.3f",data.rotationRate.x)
        labelGyroY?.text = String(format:"ジャイロY:%.3f",data.rotationRate.y)
        labelGyroZ?.text = String(format:"ジャイロZ:%.3f",data.rotationRate.z)
        
    }

}
