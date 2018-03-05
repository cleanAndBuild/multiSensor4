//
//  etcSensorViewController.swift
//  multiSensor
//
//  Created by Yako Kobayashi on 2018/03/05.
//  Copyright © 2018年 Yako Kobayashi. All rights reserved.
//

import UIKit

class etcSensorViewController: UIViewController {

    @IBOutlet var labelTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.text = "いろんなセンサー"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
