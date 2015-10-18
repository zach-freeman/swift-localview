//
//  Utils.swift
//  localview
//
//  Created by Zach Freeman on 8/16/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit

class Utils: NSObject {
  
    class func showNetworkActivityIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    class func hideNetworkActivityIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    class func isPad() -> Bool {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return true
        } else {
            return false
        }
    }
    
    class func isPhone() -> Bool {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return true
        } else {
            return false
        }
    }
    
    class func showReachabilityAlert() {
        showAlert("Error", message: "Unable to load photos. Please connect to a network")
    }
    
    class func showAlert(title: String, message: String) {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    
    class func setupRoundedCornersForLayer(layer: CALayer) {
        layer.cornerRadius = 9
        layer.masksToBounds = true
    }
  
}
