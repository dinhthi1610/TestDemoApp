//
//  SlideShowViewController.swift
//  TestApp
//
//  Created by To Dinh Thi on 1/3/18.
//  Copyright © 2018 To Dinh Thi ✉️ todinhthi@gmail.com. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import AlamofireImage

class SlideShowViewController: UIViewController {
  var venue = VenueModel()
  
  @IBOutlet weak var slideshow: ImageSlideshow!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = venue.venueName
    
    APIClient.sharedInstance.getPhotos(id: venue.venueID) { (response, error) in
      if let e = error {
        print(e.localizedDescription)
      } else {
        if let responseDict = response["response"] as? NSDictionary,
          let venue = responseDict["photos"] as? NSDictionary,
          let items = venue["items"] as? [NSDictionary]{
          
          var photoList = [AlamofireSource]()
          items.forEach({ (anItem) in
            print(anItem)
            let prefix = anItem["prefix"] as? String ?? ""
            let suffix = anItem["suffix"] as? String ?? ""
            let width = (anItem["width"] as? NSNumber)?.stringValue ?? "500"
            let height = (anItem["height"] as? NSNumber)?.stringValue ?? "500"
            let imageURL = prefix + width + "x" + height + suffix
            
            photoList.append(AlamofireSource(urlString: imageURL)!)
          })
          DispatchQueue.main.async {
            self.slideshow.setImageInputs(photoList)
          }
        }
      }
    }
    
    // Do any additional setup after loading the view.
    slideshow.backgroundColor = UIColor.white
    slideshow.slideshowInterval = 5.0
    slideshow.pageControlPosition = PageControlPosition.underScrollView
    slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
    slideshow.pageControl.pageIndicatorTintColor = UIColor.black
    slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
    
    // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
    slideshow.activityIndicator = DefaultActivityIndicator()
    slideshow.currentPageChanged = { page in
      print("current page:", page)
    }
    
    let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
    slideshow.addGestureRecognizer(recognizer)
  }
  
  @objc func didTap() {
    let fullScreenController = slideshow.presentFullScreenController(from: self)
    // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
    fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
