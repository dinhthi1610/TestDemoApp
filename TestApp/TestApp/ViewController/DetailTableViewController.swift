//
//  DetailTableViewController.swift
//  TestApp
//
//  Created by To Dinh Thi on 1/3/18.
//  Copyright © 2018 To Dinh Thi ✉️ todinhthi@gmail.com. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var value: UILabel!
}

typealias DetailType = (title: String, value: String)

class DetailTableViewController: UITableViewController {
  var venue = VenueModel() {
    didSet {
      venueList = [DetailType]()
      venueList.append((title: "Address", value: venue.venueAddress))
      venueList.append((title: "Contact number", value: venue.venuePhone))
      venueList.append((title: "Rating", value: venue.venueRating?.stringValue ?? ""))
      venueList.append((title: "People been there", value: "\(venue.venueHowManyPeople)"))
      self.tableView.reloadData()
    }
  }
  var venueList = [DetailType]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = venue.venueName
    APIClient.sharedInstance.getVenueDetail(id: venue.venueID) { (response, error) in
      if let e = error {
        print(e.localizedDescription)
      } else {
        print(response)
        if let responseDict = response["response"] as? NSDictionary, let venue = responseDict["venue"] as? NSDictionary {
          self.venue = VenueModel(dictionary: venue)
        }
      }
    }
    
    let showMapButton = UIBarButtonItem(title: "Show Map", style: .plain, target: self, action: #selector(showMap))
    self.navigationItem.rightBarButtonItem = showMapButton
  }
  
  @objc func showMap() {
    self.performSegue(withIdentifier: "showMap", sender: self.venue)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMap", let venue = sender as? VenueModel {
      (segue.destination as? MapViewController)?.venue = venue
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return venueList.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
    cell.title.text = venueList[indexPath.row].title
    cell.value.text = venueList[indexPath.row].value
    return cell
  }
  
}
