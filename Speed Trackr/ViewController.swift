//
//  ViewController.swift
//  Speed Trackr
//
//  Created by Amber Sethi on 30/07/18.
//  Copyright © 2018 Amber Sethi. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation


class ViewController: UIViewController,CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var player: AVAudioPlayer?

    @IBOutlet weak var selectSpeedBtn: UIButton!
    @IBOutlet weak var lblSpeed: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "prompt", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var limitSpeed = 0.0
        
        if selectSpeedBtn.title(for: .normal)  ==  "Select Speed" {
            limitSpeed = 3.0
        }
        else{
            limitSpeed = Double(selectSpeedBtn.title(for: .normal)!)!
        }
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        if manager.location?.speed == -1.0  {
            lblSpeed.text = "Speed:- 0 Km/hr"
        }
        else{
            
            let doubleStr = Double(String(format: "%.2f", (manager.location?.speed)! * 3.6)) // 3.14

            lblSpeed.text = "Speed:- \(doubleStr ?? 0.0) Km/hr"
        }
        
        
        if (Double((manager.location?.speed)!) * Double(3.6))  > limitSpeed {
            playSound()
        }
        print("locations = \(locValue.latitude) \(locValue.longitude) and speed = \(String(describing: manager.location?.speed))")
        
    }

    @IBAction func play(_ sender: Any) {

        var arrayData = [String]()
        for number in 10...100 where number % 2 == 0 {
            arrayData.append("\(number)")
        }
        self.showDropDown(data: arrayData, textField: sender as! UIButton)

    }
    
    
    func showDropDown(data:[String],textField:UIButton)  {
        
        let alert = UIAlertController(title: "Select Speed", message: nil, preferredStyle: .alert)
        for i in data {
            alert.addAction(UIAlertAction(title: i, style: .default, handler: { (aler:UIAlertAction) in
                textField.setTitle(i, for: .normal)
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }

    

    func myHandler(alert: UIAlertAction){
        //        print("You tapped: \(alert.title)")
    }

}

