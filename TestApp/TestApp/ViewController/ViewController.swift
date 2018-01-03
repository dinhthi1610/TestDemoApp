//
//  ViewController.swift
//  TestApp
//
//  Created by To Dinh Thi on 1/3/18.
//  Copyright © 2018 To Dinh Thi ✉️ todinhthi@gmail.com. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage

class VenueCell: UITableViewCell {
  
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
}


class ViewController: UIViewController {
  var locationManager = CLLocationManager()
  var userLocation: CLLocation? {
    didSet {
      self.searchTextField.isEnabled = (self.userLocation != nil)
    }
  }
  var venueList = [VenueModel]() {
    didSet {
      self.searchResultTableView.reloadData()
    }
  }
  
  
  @IBOutlet weak var searchTextField: UITextField!
  
  @IBOutlet weak var searchResultTableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Search"
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc func search() {
    if let userLocation = self.userLocation, let text = self.searchTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), text.count > 0 {
      let lat = userLocation.coordinate.latitude
      let lon = userLocation.coordinate.longitude
      APIClient.sharedInstance.search(text: text, lat: lat, lon: lon, completion: { (response, error) in
        if let e = error {
          print(e.localizedDescription)
        } else {
          print(response)
          var tempVenueList = [VenueModel]()
          
          if let responseDict = response["response"] as? NSDictionary, let venues = responseDict["venues"] as? [NSDictionary] {
            venues.forEach({ (aVenue) in
              tempVenueList.append(VenueModel(dictionary: aVenue))
            })
          }
          self.venueList = tempVenueList
        }
      })
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail", let venue = sender as? VenueModel {
      (segue.destination as? DetailTableViewController)?.venue = venue
    }
  }
}

extension ViewController : CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if self.userLocation == nil {
      self.userLocation = locations.last
//      print("locations = \(describing: locations.last?.coordinate.latitude ?? "") \(locations.last?.coordinate.latitude ?? "")")
    }
  }
}

extension ViewController : UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newValue = ((textField.text ?? "")as NSString).replacingCharacters(in: range, with: string)
    if newValue.count > 0 {
      NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
      self.perform(#selector(search), with: nil, afterDelay: 0.5)
    } else {
      self.venueList = [VenueModel]()
    }
    return true
  }
}

extension ViewController : UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.venueList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell") as! VenueCell
    cell.nameLabel.text = self.venueList[indexPath.row].venueName
    if let url = URL(string: self.venueList[indexPath.row].venueIconURL) {
      cell.iconImageView.af_setImage(withURL: url)
      
    }
    return cell
  }
}

extension ViewController : UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "showDetail", sender: self.venueList[indexPath.row])
  }
}
