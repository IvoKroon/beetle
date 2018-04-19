
import Foundation
import RealmSwift

func LoadCrateData(callback: @escaping () -> Void){
    // GET THE DATA
    let url:String = "http://145.24.222.175/user/5ad5af445f85880da5cb95f2"
    HttpCall().makeGetCall(urlString:url){ (ok, obj) in
        // CHECK IF THE DATA IS IN AN REALM OBJECT
        let realm = try! Realm()
        let id = obj!["_id"] as! String
        if(realm.object(ofType: User.self, forPrimaryKey: id) == nil){
            // CREATE NEW USER IN REALM
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
                callback()
            }
        }
    }
}
