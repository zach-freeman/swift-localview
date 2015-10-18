//
//  LocationManager.swift
//  localview
//
//  Created by Zach Freeman on 8/22/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

protocol LocationUpdaterDelegate {
  func locationAvailable(locationUpdater: LocationUpdater)
}

class LocationUpdater : NSObject, CLLocationManagerDelegate {
    var locationUpdaterDelegate : LocationUpdaterDelegate?
    let locationManager:CLLocationManager = CLLocationManager()
    var shouldUpdateLocation:Bool!
    var currentLatitude:String!
    var currentLongitude:String!
    var currentPlacemark:String!
  
  override init() {
    super.init()
    self.locationManager.delegate = self
    self.shouldUpdateLocation = true
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0)) &&
      CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse {
        self.locationManager.requestWhenInUseAuthorization()
    } else {
      self.locationManager.startUpdatingLocation()
    }
    
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    switch status {
    case .NotDetermined:
      print("authorization not determined")
      self.locationManager.requestWhenInUseAuthorization()
      break
    case .Denied:
      print("Authorization Denied")
      break
    case .AuthorizedWhenInUse, .AuthorizedAlways:
      self.locationManager.startUpdatingLocation()
      break;
    default:
      break;
    }
    
  }
    
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 
    if self.shouldUpdateLocation == true {
      if let location = locations.last {
        self.currentLatitude = "\(location.coordinate.latitude)"
        self.currentLongitude = "\(location.coordinate.longitude)"
        self.geocodeLocation(location)
      }
      self.shouldUpdateLocation = false

    }
  }
    
    func geocodeLocation(location: CLLocation) {
        let geocoder:CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)-> Void in
            if error == nil && placemarks!.count > 0 {
                if let firstPlacemark = placemarks?[0] {
                    self.currentPlacemark = self.formatPlacemark(firstPlacemark)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.locationUpdaterDelegate?.locationAvailable(self)
                    })
                }
                
            }
            
        })
        
    }
    
    func formatPlacemark(placemark: CLPlacemark) -> String {
        var formattedPlacemark:String
        if (placemark.ISOcountryCode == "US") {
            formattedPlacemark = placemark.locality! + ", " + placemark.administrativeArea! + ", " + placemark.country!
        } else {
            formattedPlacemark = placemark.locality! + ", " + placemark.country!
        }
        return formattedPlacemark
    }
  
}


