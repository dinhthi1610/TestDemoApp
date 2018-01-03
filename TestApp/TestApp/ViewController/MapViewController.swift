//
//  MapViewController.swift
//  TestApp
//
//  Created by To Dinh Thi on 1/3/18.
//  Copyright © 2018 To Dinh Thi ✉️ todinhthi@gmail.com. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  
  var venue = VenueModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = venue.venueName
    
    // Do any additional setup after loading the view.
    self.mapView.delegate = self
    
    let venuePin = CLLocationCoordinate2DMake(venue.venueLat, venue.venueLon)
    // Drop a pin
    let pinAnnotation = MKPointAnnotation()
    pinAnnotation.coordinate = venuePin
    pinAnnotation.title = venue.venueName
    
    let dropPin = MKPinAnnotationView()
    dropPin.animatesDrop = true
    dropPin.annotation = pinAnnotation
    
    mapView.addAnnotation(pinAnnotation)
    mapView.showAnnotations([pinAnnotation], animated: true)
    mapView.selectAnnotation(pinAnnotation, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showSlideShow", let venue = sender as? VenueModel {
      (segue.destination as? SlideShowViewController)?.venue = venue
    }
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if control == view.rightCalloutAccessoryView{
      self.performSegue(withIdentifier: "showSlideShow", sender: self.venue)
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      //return nil
      return nil
    }
    
    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
      //println("Pinview was nil")
      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinView!.canShowCallout = true
      pinView!.animatesDrop = true
    }
    
    let button = UIButton(type: UIButtonType.detailDisclosure) as UIButton // button with info sign in it
    
    pinView?.rightCalloutAccessoryView = button
    
    
    return pinView
  }
}
