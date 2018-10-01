//
//  PersonDetails.swift
//  QitaahTask
//
//  Created by mac on 10/1/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class PersonDetails:Mappable{
    var birthday: String?
    var known_for_department: String?
    var name: String?
    var biography:String?
    var place_of_birth:String?
    var profile_path:String?
    var id:Int?
    var popularity:Int?
    required init?(map: Map){

    }
    init(){

        birthday = ""
        known_for_department = ""
        name = ""
        biography = ""
        place_of_birth = ""
        profile_path = ""
        id = 0
        popularity = 0
    }

    func mapping(map: Map) {
        birthday <- map["birthday"]
        known_for_department <- map["known_for_department"]
        name <- map["name"]
        biography <- map["biography"]
        place_of_birth <- map["place_of_birth"]
        profile_path <- map["profile_path"]
        id <- map["id"]
        popularity <- map["popularity"]

}
}
