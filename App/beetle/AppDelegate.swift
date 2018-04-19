//
//  AppDelegate.swift
//  beetle
//
//  Created by ivo kroon on 09/04/2018.
//  Copyright © 2018 ivo kroon. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var lastLocation:CLLocation?
    var locationManager = CLLocationManager()
    var homeLocation:CLLocation = CLLocation(latitude: 51.753242, longitude: 4.162058)
    var center:UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    func createRegion(location:CLLocation?) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let coordinate = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            let regionRadius = 50.0
            
            let region = CLCircularRegion(center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude),
                                          radius: regionRadius,
                                          identifier: "aabb")
            
            region.notifyOnExit = true
            region.notifyOnEntry = true
            
            //Send your fetched location to server
            
            //Stop your location manager for updating location and start regionMonitoring
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startMonitoring(for: region)
        }
        else {
            print("System can't track regions")
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Region")
        self.scheduleLocal(title: "Entering region", description: "Welcom back home!")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited Region")
        self.scheduleLocal(title: "Exited region", description: "You just left the home area")
        
        locationManager.stopMonitoring(for: region)
        
        //Start location manager and fetch current location
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("GETTTING LOCATION")
        if UIApplication.shared.applicationState == .active {
        } else {
            //App is in BG/ Killed or suspended state
            //send location to server
            // create a New Region with current fetched location
            let location = locations.last
            lastLocation = location
            
            //Make region and again the same cycle continues.
//            self.createRegion(location: lastLocation)
        }
    }
    
    func registerLocal() {
        center.delegate = self as? UNUserNotificationCenterDelegate
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
//                self.scheduleLocal()
            } else {
                print("D'oh")
            }
        }
    }
    
//    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//
//        return true
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.registerLocal()
//        self.scheduleLocal()
        
//        self.startReceivingSignificantLocationChanges()
        return true
    }
    
    func scheduleLocal(title:String, description:String) {
        print("SENDING NOTIFICATION")
        
//        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = description
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default()
        
        var dateComponents = DateComponents()
        dateComponents.second = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            guard let error = error else { return }
            print("Error: \(error)")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("GOING")
        self.createRegion(location: homeLocation)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

