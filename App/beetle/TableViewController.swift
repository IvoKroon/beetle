
import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    @IBOutlet var CrateTableView: UITableView!
    var selectedCrateId:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCrateData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        if !user.isEmpty {
            let crates = user[0]["crates"] as! List<Crate>
            print(crates.count)
            return crates.count
        }
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let realm = try! Realm()
        let user = realm.objects(User.self)
        let crates = user[0]["crates"] as! List<Crate>
        cell.textLabel?.text = crates[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func loadCrateData(){
        // GET THE DATA
        let url:String = "http://145.24.222.175/user/5aca18cfa1142895ba6e4250"
        HttpCall().makeGetCall(urlString:url){ (ok, obj) in
            // CHECK IF THE DATA IS IN AN REALM OBJECT
            let realm = try! Realm()
            let id = obj!["_id"] as! String
            if(realm.object(ofType: User.self, forPrimaryKey: id) == nil){
                // CREATE NEW USER
                let user = User()
                user.id = obj!["_id"] as! String
                user.firstName = obj!["firstName"] as! String
                user.lastName = obj!["lastName"] as! String
                user.email = obj!["email"] as! String
                
                // FILL THE CRATES
                let crates = obj!["crates"] as! Array<Dictionary<String, AnyObject>>
                for crate in crates {
                    let newCrate = Crate()
                    newCrate.id = crate["_id"] as! String
                    newCrate.title = crate["title"] as! String
                    newCrate.temperature = crate["temperature"] as! Int
                    newCrate.humidity = crate["humidity"] as! Int
                    // ADD CRATE TO USER
                    user.crates.append(newCrate)
                }
                // ADD THE DATA TO REALM DATABASE
                try! realm.write {
                    realm.add(user)
                    DispatchQueue.main.async{
                        self.CrateTableView.reloadData();
                    }
                }
            }
        }
    }
}
