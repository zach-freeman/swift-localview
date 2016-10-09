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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    class func hideNetworkActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    class func isPad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
    
    class func isPhone() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return true
        } else {
            return false
        }
    }
    
    class func showReachabilityAlert() {
        showAlert("Error", message: "Unable to load photos. Please connect to a network")
    }
    
    class func showAlert(_ title: String, message: String) {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: "OK")
        alert.show()
    }
    
    
    class func setupRoundedCornersForLayer(_ layer: CALayer) {
        layer.cornerRadius = 9
        layer.masksToBounds = true
    }
  
}
