//
//  APIClient.swift
//  TestApp
//
//  Created by To Dinh Thi on 1/3/18.
//  Copyright © 2018 To Dinh Thi ✉️ todinhthi@gmail.com. All rights reserved.
//

import Foundation
import Alamofire

class APIClient: NSObject {
  static let sharedInstance = APIClient()
  static let oauth_token = "ZQ3CXWCYWPQRTEICGRW1B1MAY3QIBAMR5RHDXXS0CNYQHV5E"
  
  func getPhotos(id: String,  completion: @escaping (_ resultData: AnyObject, _ error: Error?) -> Void) {
    let urlString = "https://api.foursquare.com/v2/venues/\(id)/photos?&oauth_token=\(APIClient.oauth_token)&v=20180103"
    self.sendRequestWithURLString(urlString, parameters: nil, completion: completion)
  }
  func getVenueDetail(id: String,  completion: @escaping (_ resultData: AnyObject, _ error: Error?) -> Void) {
    let urlString = "https://api.foursquare.com/v2/venues/\(id)?&oauth_token=\(APIClient.oauth_token)&v=20180103"
    self.sendRequestWithURLString(urlString, parameters: nil, completion: completion)
  }
  
  func search(text: String, lat: Double, lon: Double,  completion: @escaping (_ resultData: AnyObject, _ error: Error?) -> Void) {
     let apiURL = "https://api.foursquare.com/v2/venues/search?ll=\(lat),\(lon)&limit=50&query=\(text)&oauth_token=\(APIClient.oauth_token)&v=20180103"
    self.sendRequestWithURLString(apiURL, parameters: nil, completion: completion)
  }
  // MARK: - base connection
  func sendRequestWithURLString(_ urlString: String,
                                            parameters: Parameters?,
                                            completion: @escaping (_ resultData: AnyObject, _ error: Error?) -> Void) {
    Alamofire.request(urlString, parameters: parameters, encoding: URLEncoding.default)
      .responseJSON { response in
        if response.result.isSuccess {
          print(response.result.value ?? "")
          completion(response.result.value as AnyObject, nil)
        } else {
          completion(response.result.value as AnyObject, response.result.error)
        }
        
    }
  }
}
