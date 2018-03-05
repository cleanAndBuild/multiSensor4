//
//  MyLocationManager.swift
//  multiSensor
//
//  Created by matsumoto keiji on 2017/07/04.
//  Copyright © 2017年 matsumoto keiji. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MyLocationManager: CLLocationManager {
	let BAD_DEVIATION:CLLocationDirection = -999
	let GPS_ACCURACY_MODE_ECO = 1
	let COMPASS_UPDATE_FORGROUND:CLLocationDirection = 3.0
	let COMPASS_UPDATE_BACKGROUND:CLLocationDirection = 15.0
	let INVALID_ALT:Double = -9999

	private(set) var isGPSActive:Bool = false //GPSが動いているか
	private(set) var isCompassActive:Bool = false //コンパスが動いているか

	private(set) public var myHeading:CLLocationDirection = 0//コンパスの向き
	private(set) var deviation:CLLocationDirection = 0//磁北偏差
	
//	private(set) var isNoCompassDevice:Bool = false//コンパスがない機種
	
	//現在地
	private(set) var nowLocation:CLLocation? = nil
	
	//-----------------------------------
	// 初期化
	//-----------------------------------
	init(isBackGround:Bool)
	{
		super.init()
		deviation = BAD_DEVIATION
		self.allowsBackgroundLocationUpdates = isBackGround//バックグラウンド更新
		
		//精度
		updateAccuracySetting(accuracy: GPS_ACCURACY_MODE_ECO)
		self.headingFilter = COMPASS_UPDATE_FORGROUND;//コンパス

		self.requestAlwaysAuthorization()

		//これがないとGPSが自動的に止まる
		self.pausesLocationUpdatesAutomatically = false
		self.activityType = CLActivityType.fitness
		
		//現在地情報を初期化
		updateNowLocation(location:self.nowLocation,altitude:INVALID_ALT);
		
	}

	//--------------------
	//精度を初期化する
	//--------------------
	func updateAccuracySetting(accuracy:Int) {
		if(accuracy == GPS_ACCURACY_MODE_ECO) {
			self.desiredAccuracy = 99;//省エネ
			self.distanceFilter = kCLDistanceFilterNone;//1mの移動
		}
		else {
			self.desiredAccuracy = kCLLocationAccuracyBest;//最高精度
			self.distanceFilter = kCLDistanceFilterNone;//常に更新
		}
	}
	
	//--------------------
	// GPSとコンパスを動かす
	//--------------------
	func startGPSandCompass() {
		startUpdatingLocation()
		startUpdatingHeading()
		isGPSActive = true
		isCompassActive = true
	}
	func stopGPSandCompass() {
		stopUpdatingLocation()
		stopUpdatingHeading()
		isGPSActive = false
		isCompassActive = false
	}

	func startGPS() {
		startUpdatingLocation()
		isGPSActive = true
	}
	func stopGPS() {
		stopUpdatingLocation()
		isGPSActive = false
	}
	func startCompass() {
		startUpdatingHeading()
		isCompassActive = true
	}
	func stopCompass() {
		stopUpdatingHeading()
		isCompassActive = false
	}

	//--------------------
	// コンパスの角度を更新
	//--------------------
	func updateHeading(_ newHeading: CLHeading) {
		if(newHeading.trueHeading != -1) {
			self.myHeading = newHeading.trueHeading;
			
			if(newHeading.magneticHeading != -1) {
				self.deviation = newHeading.magneticHeading - newHeading.trueHeading;
			}
		}
		else {
			self.myHeading = newHeading.magneticHeading;
		}
	}
	
	//--------------------
	// 位置情報を更新
	//--------------------
	func updateNowLocation(_ location:CLLocation?) {
		
		if let location = location {
			self.nowLocation = location

		}
	}

	//--------------------
	// 位置情報を更新 高度付き
	//--------------------
	func updateNowLocation(location:CLLocation?,altitude:Double) {
		var myAltitude:Double = altitude

		if let location = location {
			if(myAltitude != INVALID_ALT) {
				if(myAltitude == -1) {
					myAltitude = -1.1; //-1ピッタリだと記録されないのでちょっとズラす
				}
				self.nowLocation = CLLocation(coordinate: CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude), altitude:myAltitude, horizontalAccuracy: location.horizontalAccuracy, verticalAccuracy:location.verticalAccuracy, course:location.course, speed:location.speed, timestamp:location.timestamp)
			}
			else {
				myAltitude = location.altitude
				if(myAltitude > -1 && myAltitude < 0.0) {
					myAltitude = 0.0;
				}
				self.nowLocation = CLLocation(coordinate: CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude), altitude:myAltitude, horizontalAccuracy: location.horizontalAccuracy, verticalAccuracy:location.verticalAccuracy, course:location.course, speed:location.speed, timestamp:location.timestamp)
			}
			
		}
		else {
			self.nowLocation = CLLocation(coordinate: CLLocationCoordinate2DMake(0,0), altitude:0.0, horizontalAccuracy: 0.0, verticalAccuracy:0.0, course:0.0, speed:0.0, timestamp:Date())
		}
	}

	//--------------------
	// 位置情報の取得をお願いする
	//--------------------
	func didChangeAuthorization(status: CLAuthorizationStatus,vc:UIViewController,errorMsg:String) {
		switch status {
		case .notDetermined:
			self.requestWhenInUseAuthorization() // 起動中のみの取得許可を求める
			break
		case .denied:
			MyLocationManager.showAlertWithOK(vc: vc, title: "GPS Error!", message:errorMsg)
			break
		case .restricted:
			MyLocationManager.showAlertWithOK(vc: vc, title: "GPS Error!", message:errorMsg)
			break
		case .authorizedAlways:
			break
		case .authorizedWhenInUse:
			break
		}
		
	}
	
	//--------------------
	// アラートを表示する
	//--------------------
	static func showAlertWithOK(vc:UIViewController,title:String,message:String,handler: ((UIAlertAction) -> Swift.Void)? = nil,completion: (() -> Swift.Void)? = nil) {
		let alert:UIAlertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:handler))
		vc.present(alert, animated: true, completion:completion)
	}
}
