//
//  AddCrateViewController.swift
//  beetle
//
//  Created by ivo kroon on 16/04/2018.
//  Copyright © 2018 ivo kroon. All rights reserved.
//

import UIKit
import RealmSwift

class AddCrateViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addCrateAction(_ sender: Any) {
        let realm = try! Realm()
        let user = realm.objects(User.self)
        let text = self.titleTextField.text
        HttpCall().makePostCall(
        urlString: "http://145.24.222.175/user/newcrate",
        dataCollection: ["title": text!, "userId":user[0].id])
        {
            (success, data) in
            let realm2 = try! Realm()
            let user2 = realm2.objects(User.self)
            
            if(success){
                let crate = data!["crate"] as! Dictionary<String, Any>;
                let crateObject = Crate();
                crateObject.humidity = crate["humidity"] as! Int
                crateObject.temperature = crate["temperature"] as! Int
                crateObject.title = crate["title"] as! String
                crateObject.id = crate["_id"] as! String
                
                if !user2.isEmpty {
                    let updatedUser = user2[0]
                    // UPDATE THE REALM
                    try! realm2.write {
                        updatedUser.crates.append(crateObject)
                        realm2.add(updatedUser, update:true)
                        DispatchQueue.main.async{
//                            self.performSegue(withIdentifier: "goBack", sender:self)
                            self.navigationController?.popToRootViewController(animated: true)
                        }
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
