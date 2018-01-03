//
//  VenueModel.swift
//  TestApp
//
//  Created by To Dinh Thi on 1/3/18.
//  Copyright © 2018 To Dinh Thi ✉️ todinhthi@gmail.com. All rights reserved.
//

import UIKit

class VenueModel: NSObject {
  var venueID = ""
  var venueName = ""
  var venueLat = Double()
  var venueLon = Double()
  var venueIconURL = ""
  var venueAddress = ""
  var venuePhone = ""
  var venueRating: NSNumber?
  var venueHowManyPeople: Int = 0
  
  convenience init(dictionary: NSDictionary) {
    self.init()
    self.venueID = dictionary["id"] as? String ?? ""
    self.venueName = dictionary["name"] as? String ?? ""
    self.venueLat = (dictionary["location"] as? NSDictionary)?["lat"] as? Double ?? 0
    self.venueLon = (dictionary["location"] as? NSDictionary)?["lng"] as? Double ?? 0
    if let categories = dictionary["categories"] as? NSArray,
      let first = categories.firstObject as? NSDictionary,
      let icon = first["icon"] as? NSDictionary {
      self.venueIconURL = (icon["prefix"] as? String ?? "") + (icon["suffix"] as? String ?? "")
    }
    self.venueAddress = (dictionary["location"] as? NSDictionary)?["address"] as? String ?? ""
    self.venuePhone = (dictionary["contact"] as? NSDictionary)?["phone"] as? String ?? ""
    self.venueRating = dictionary["rating"] as? NSNumber
    
    self.venueHowManyPeople = (dictionary["beenHere"] as? NSDictionary)?["count"] as? Int ?? 0
  }
}
