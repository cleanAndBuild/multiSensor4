//
//  MyTabBarController.swift
//  multiSensor
//
//  Created by Yako Kobayashi on 2018/03/05.
//  Copyright © 2018年 Yako Kobayashi. All rights reserved.
//

import UIKit
import CoreLocation

class MyTabBarController: UITabBarController, CLLocationManagerDelegate {
    
    var myLocationManager:MyLocationManager! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        myLocationManager = MyLocationManager(isBackGround:false) //MylocationmManagerを実体化
        myLocationManager.delegate = self //デリゲート登録
        myLocationManager.startGPSandCompass() //GPSを動かす
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


}
