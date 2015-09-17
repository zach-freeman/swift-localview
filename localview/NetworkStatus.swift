//
//  NetworkStatus.swift
//  localview
//
//  Created by Zach Freeman on 8/22/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import Foundation

protocol NetworkStatusDelegate {
  func networkStatusDidFinish(networkStatus:NetworkStatus)
}

class NetworkStatus: NSOperation {
  var delegate : NetworkStatusDelegate?
  var isReachable : Bool = false
  
  override func main() {
    if self.cancelled {
      return
    }
    
    let reachableUrl = NSURL(string: "http://www.google.com")
    let reachableData = NSData(contentsOfURL:reachableUrl!)
    if reachableData != nil {
      self.isReachable = true
    }
    dispatch_async(dispatch_get_main_queue(), {
      self.delegate?.networkStatusDidFinish(self)
    })
    
  }
}
