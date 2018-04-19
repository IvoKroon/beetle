//
//  ViewController.swift
//  beetle
//
//  Created by ivo kroon on 09/04/2018.
//  Copyright © 2018 ivo kroon. All rights reserved.
//

import UIKit
import RealmSwift


class CrateDetailViewController: UIViewController {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var CrateTitleLabel: UILabel!
    var crateId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.crateId)
        let realm = try! Realm()
        let user = realm.objects(User.self)
        let crates = user[0]["crates"] as! List<Crate>
        self.CrateTitleLabel.text = crates[self.crateId].title
        self.humidityLabel.text = String(crates[self.crateId].humidity)
        self.temperatureLabel.text = String(crates[self.crateId].temperature)
    }
    
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        print(self.crateId)
        let realm = try! Realm()
        let user = realm.objects(User.self)
        let crates = user[0]["crates"] as! List<Crate>
        let id = crates[self.crateId]["id"] as! String
        print(id)
        let url:String = "http://145.24.222.175/crate/\(id)"
        HttpCall().makeGetCall(
            urlString:url){
            (success, data) in
                if(success){
                    let crate = data!["crate"] as! Dictionary<String, Any>
                    let realm2 = try! Realm()
                    let user = realm2.objects(User.self)
                    let crates = user[0]["crates"] as! List<Crate>
                    let oldCrate = crates[self.crateId] as Crate
                    
                    try! realm2.write {
                        print("saved")
                        let humidity = crate["humidity"] as! Int
                        let temperature = crate["temperature"] as! Int
                        oldCrate.humidity = humidity
                        oldCrate.temperature = temperature
                        realm2.add(oldCrate)
                        DispatchQueue.main.async{
                            self.temperatureLabel.text = String(temperature)
                            self.humidityLabel.text = String(humidity)
                        }
                    }
                }else{
                    print("Error")
                }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        // FIX FOR SHOWING DETAIL PAGE.
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}


