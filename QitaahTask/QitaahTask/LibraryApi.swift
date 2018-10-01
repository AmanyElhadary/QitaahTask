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
        static let apiURL = "https://api.themoviedb.org/3/person"
        static let ImagePath = "https://image.tmdb.org/t/p/w500"
        static let originalImagePath = "https://image.tmdb.org/t/p/original/"

    }
    
    func PopularRequest( pagenum:Int , completion: @escaping (_ sucses: Bool  , _ ResultArr: [popularObject])->()){
        var popularList = [popularObject]()
        let parameters: Parameters = [
            :]
        Alamofire.request("\(APIConstants.apiURL)/popular?api_key=\(APIConstants.APIKey)&language=en-US&page=\(pagenum)", method: .get , parameters: parameters, encoding: URLEncoding.default)
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

    func PersonDetailsRequest( person_id:Int , completion: @escaping (_ sucses: Bool  , _ ResultDetails: PersonDetails , _ personImgArr : [PersonImagesObject])->()){
        var popularDetailsObj:PersonDetails = PersonDetails()
        var popularImgsArr = [PersonImagesObject]()
        let parameters: Parameters = [
            :]
        Alamofire.request("\(APIConstants.apiURL)/\(person_id)?api_key=\(APIConstants.APIKey)&language=en-US", method: .get , parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let result = response.result.value else {
                        completion(false,popularDetailsObj,[])
                        return
                    }
                        guard let singleObj  = Mapper<PersonDetails>().map(JSONObject: result)
                            else {
                                completion(false,popularDetailsObj,[])
                                return
                        }
                        popularDetailsObj = singleObj
                    LibraryApi.sharedInstance.PersonImgsRequest(person_id: person_id, completion: {
                        sucses,ResultDetails  in
                        guard (sucses) else {
                            completion (false,popularDetailsObj,[])
                            return
                        }
                        popularImgsArr = ResultDetails
                        completion (true , popularDetailsObj, popularImgsArr )
                    })
                case .failure(let error):
                    print("Requesterror: \(error)")
                    completion(false,popularDetailsObj,[])
                }
        }


    }


    private func PersonImgsRequest( person_id:Int , completion: @escaping (_ sucses: Bool  , _ ResultDetails: [PersonImagesObject])->()){
        var popularImgsArr = [PersonImagesObject]()
        let parameters: Parameters = [
            :]
        Alamofire.request("\(APIConstants.apiURL)/\(person_id)/images?api_key=\(APIConstants.APIKey)&language=en-US", method: .get , parameters: parameters, encoding: URLEncoding.default)
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
                guard let data = RstultDic["profiles"]as? NSArray else {
                        completion(false,[])
                            return
                    }
                    for obj in data {
                    guard let singleObj  = Mapper<PersonImagesObject>().map(JSONObject: obj)
                        else {
                            completion(false,[])
                            return
                    }

                        popularImgsArr.append(singleObj)

                                        }
                    completion(true, popularImgsArr)
                case .failure(let error):
                    print("Requesterror: \(error)")
                    completion(false,[])
                }
        }


    }

}
