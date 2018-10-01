//
//  DetailsObject.swift
//  QitaahTask
//
//  Created by mac on 9/29/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class known_for:Mappable{
    var poster_path: String?
    var overview: String?
    var release_date: String?
    var media_type:String?
    var title:String?
    var backdrop_path:String?
    var vote_count:Int?

    required init?(map: Map){

    }

    func mapping(map: Map) {
        poster_path <- map["poster_path"]
        overview <- map["overview"]
        release_date <- map["release_date"]
        media_type <- map["media_type"]
        title <- map["title"]
        backdrop_path <- map["backdrop_path"]
        vote_count <- map["vote_count"]


    }

}

