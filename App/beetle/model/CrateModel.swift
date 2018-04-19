//
//  crateModel.swift
//  beetle
//
//  Created by ivo kroon on 10/04/2018.
//  Copyright © 2018 ivo kroon. All rights reserved.
//

import Foundation
import RealmSwift

class Crate:Object{
    @objc dynamic var id:String = ""
    @objc dynamic var title:String = ""
    @objc dynamic var temperature:Int = 0
    @objc dynamic var humidity:Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
