//
//  CratesViewController.swift
//  beetle
//
//  Created by ivo kroon on 12/04/2018.
//  Copyright © 2018 ivo kroon. All rights reserved.
//

import UIKit
import RealmSwift

class CratesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var selectedCrateId:Int! = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
    
        if !user.isEmpty {
            let crates = user[0]["crates"] as! List<Crate>
//            print(crates.count)
            return crates.count
        }
        return 0;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let realm = try! Realm()
        let user = realm.objects(User.self)
//        print(user)
        let crates = user[0]["crates"] as! List<Crate>
        cell.textLabel?.text = crates[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // First set selected Crate and then preformSegue
        self.selectedCrateId = indexPath.row
        self.performSegue(withIdentifier: "detailSegue", sender:self)
        
    }
    // Prepare the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! CrateDetailViewController
            // your new view controller should have property that will store passed value
            viewController.crateId = self.selectedCrateId
        }
    }
    
    @IBAction func AddCrateEvent(_ sender: Any) {
        print("clicked")
        self.performSegue(withIdentifier: "addCrate", sender:self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData();
        self.tableView.delegate = self
        self.tableView.dataSource = self
        LoadCrateData(){
            DispatchQueue.main.async{
                self.tableView.reloadData();
            }

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
