//
//  popularObject.swift
//  QitaahTask
//
//  Created by mac on 9/29/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class popularObject:Mappable{
    var popularity:Int?
    var name: String?
    var profile_path: String?
    var known_for: [DetailsObject]?
    var section_name: String?
    var newsurl:String?
    var view_count:String?

    required init?(map: Map){

    }

    func mapping(map: Map) {
        popularity <- map["popularity"]
        name <- map["name"]
        profile_path <- map["profile_path"]
        known_for <- map["known_for"]
        

    }

}

