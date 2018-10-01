//
//  PersonImagesObject.swift
//  QitaahTask
//
//  Created by mac on 10/1/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
class PersonImagesObject:Mappable{
    var file_path: String?
    var width:Int?
    var height:Int?
    var aspect_ratio :Double?
    required init?(map: Map){
    }
    init(){
        file_path = ""
        width = 0
        height = 0
        aspect_ratio = 0.0
    }
    func mapping(map: Map) {
        file_path <- map["file_path"]
        width <- map["width"]
        height <- map ["height"]
         aspect_ratio <- map["aspect_ratio"]
    }
}

