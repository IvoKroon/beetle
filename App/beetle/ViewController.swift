//
//  ViewController.swift
//  beetle
//
//  Created by ivo kroon on 09/04/2018.
//  Copyright © 2018 ivo kroon. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation? = nil
//    var homeLocation:CLLocation = CLLocation(latitude: 51.7640462, longitude: 4.1480324)
    var homeLocation:CLLocation = CLLocation(latitude: 51.753242, longitude: 4.162058)
    var home:Bool = false
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.startReceivingSignificantLocationChanges()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusView.layer.cornerRadius = 10
        self.statusView.backgroundColor = ColorHelper(
            red:34.0,
            green:139.0,
            blue:34.0)
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        if !user.isEmpty {
            let userData = user[0] as User
            self.emailLabel.text = userData.email
            self.firstNameLabel.text = userData.firstName
            self.lastNameLabel.text = userData.lastName
        }
    }
    
    // LET'S CHECK WHAT THE USER WANTS.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("AUTH");
        print(status);
        switch status {
        case CLAuthorizationStatus.denied:
            print("USER DENIED")
            break;
        case CLAuthorizationStatus.authorizedWhenInUse:
            print("WHEN IN USE")
            startReceivingSignificantLocationChanges()
        case CLAuthorizationStatus.authorizedAlways:
            print("ALWAY")
            startReceivingSignificantLocationChanges()
        default:
            print("ERROR")
        }
    }

    func startReceivingSignificantLocationChanges (){
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedAlways {
            print("NO AUTHORIZATION")
            // User has not authorized access to location information.
            return
        }
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The service is not available.
            print("ERROR")
            return
        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 100.0
        self.locationManager.startUpdatingLocation()
    }
    
    // CHECK
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
        let distance = self.currentLocation?.distance(from: self.homeLocation)
        // IF DISTANCE IS NEAR HOME WE ARE HOME ELS WE ARE LEAVING HOME
        if(Double(distance!) < 500.0 && !self.home){
            // SHOW NOTIFICATION
            self.home = true;
            self.statusLabel.text = "Status: HOME"
            self.statusView.backgroundColor = ColorHelper(
                red:34.0,
                green:139.0,
                blue:34.0)
        }else if(Double(distance!) < 500.0){
            print("Still HERE")
        }else{
            print("LEAVING HOME")
            self.home = false;
            self.statusLabel.text = "Status: OUT"
            self.statusView.backgroundColor = ColorHelper(
                red:255.0,
                green:0.0,
                blue:0.0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopMonitoringSignificantLocationChanges()
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

