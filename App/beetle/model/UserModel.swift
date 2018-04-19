//
//  File.swift
//  beetle
//
//  Created by ivo kroon on 10/04/2018.
//  Copyright © 2018 ivo kroon. All rights reserved.
//

import Foundation
import RealmSwift

class User:Object{
    @objc dynamic var id:String = ""
    @objc dynamic var firstName:String = ""
    @objc dynamic var lastName:String = ""
    @objc dynamic var email:String = ""
    let crates = List<Crate>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
