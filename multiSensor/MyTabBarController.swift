//
//  MyTabBarController.swift
//  multiSensor
//
//  Created by Yako Kobayashi on 2018/03/05.
//  Copyright © 2018年 Yako Kobayashi. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class MyTabBarController: UITabBarController, CLLocationManagerDelegate {
    
    var myLocationManager:MyLocationManager! = nil
    
    var myAltimeter:CMAltimeter! = nil
    var myMotionManager:CMMotionManager! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        myLocationManager = MyLocationManager(isBackGround:false) //MylocationmManagerを実体化
        myLocationManager.delegate = self //デリゲート登録
        myLocationManager.startGPSandCompass() //GPSを動かす
        
        //気圧センサーを実体化（インスタンス化）
        myAltimeter = CMAltimeter()
        //モーションマネージャーを実体化（インスタンス化）
        myMotionManager = CMMotionManager()
        startUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //位置情報サービスの権限を設定する
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.myLocationManager.didChangeAuthorization(status:status,vc:self,errorMsg:"GPSを使用できません。iPhoneの[設定]-[プライバシー]-[位置情報サービス]を開いてオンにして下さい。アプリごとの設定は『許可しない』以外にしてください。")
    }
    
    //位置情報更新 更新されると呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations.last! //最新の位置情報を取る
        
        let first = self.viewControllers?.first as! FirstViewController //最初のビューコントローラを取得
        first.updateLocation(location) //ラベルをアップデートする
    }
    
    //コンパス更新
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let second = self.viewControllers?[1] as! SecondViewController
        second.updateHeading(newHeading)
    }
    
    //各種センサーを動かす
    func startUpdate() {
        //気圧高度計
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            //取得を開始
            myAltimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {
                (data, error) in
                //気圧を受け取ると呼ばれる部分
                if(error == nil) {
                    let etcSensor = self.viewControllers?[2] as! etcSensorViewController
                    etcSensor.updateAltimeter(data!)
                }
            })
        }
        
        //重力加速度計
        if (myMotionManager.isAccelerometerAvailable) {
            myMotionManager.accelerometerUpdateInterval = 0.5
            //加速度の取得を開始
            myMotionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                (data, error) in
                //0.5秒ごとに呼ばれる部分
                if(error == nil) {
                    let etcSensor = self.viewControllers?[2] as! etcSensorViewController
                    etcSensor.updateAccelerometer(data!)
                }
            })
        }
        //ジャイロ
        if (myMotionManager.isGyroAvailable) {
            myMotionManager.gyroUpdateInterval = 0.5
            myMotionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: {
                (data,error) in
                //0.5秒ごとに呼ばれる部分
                if (error == nil) {
                    let etcSensor = self.viewControllers?[2] as! etcSensorViewController
                    etcSensor.updateGyro(data!)
                }
            })
        }
    }
    
}
