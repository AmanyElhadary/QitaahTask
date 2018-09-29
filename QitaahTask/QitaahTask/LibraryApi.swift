//
//  LibraryApi.swift
//  QitaahTask
//
//  Created by mac on 9/29/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class LibraryApi: NSObject {
    static let sharedInstance: LibraryApi = LibraryApi()
    struct APIConstants {
        static let APIKey  = "7e1603ef716387f7787b280e1f2192d9"
        static let apiURL = "https://api.themoviedb.org/3/person/popular?api_key=\(APIConstants.APIKey)&language=en-US&page="
        static let ImagePath = "https://image.tmdb.org/t/p/w500/"
        static let originalImagePath = "https://image.tmdb.org/t/p/original/"

    }
    func PopularRequest( pagenum:Int , completion: @escaping (_ sucses: Bool  , _ ResultArr: [popularObject])->()){
        var popularList = [popularObject]()
        let parameters: Parameters = [
            :]
        Alamofire.request("\(APIConstants.apiURL)\(pagenum)", method: .get , parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let result = response.result.value else {
                        completion(false,[])
                        return
                    }
                    guard let RstultDic = result as? NSDictionary else {
                        completion(false,[])
                        return
                    }
                    guard let data = RstultDic["results"]as? NSArray else {
                        completion(false,[])
                        return
                    }
                    for obj in data {
                        guard let singleObj  = Mapper<popularObject>().map(JSONObject: obj)
                            else {
                                completion(false,[])
                                return
                        }

                        popularList.append(singleObj)
                    }
                    completion(true, popularList)
                case .failure(let error):
                    print("Requesterror: \(error)")
                    completion(false,[])
                }
        }


    }


}
