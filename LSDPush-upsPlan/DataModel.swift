//
//  dataModel.swift
//  LSDPush-upsPlan
//
//  Created by LSD on 2017/1/12.
//  Copyright © 2017年 LSD. All rights reserved.
//

import Foundation
import RealmSwift

class PushUpModel: Object {
    dynamic var date: String = ""
    dynamic var pushUpCount: Int = 0
    
    override static func primaryKey() -> String? {
        return "date"
    }
}
