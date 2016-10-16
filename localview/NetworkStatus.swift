//
//  NetworkStatus.swift
//  localview
//
//  Created by Zach Freeman on 8/22/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import Foundation

protocol NetworkStatusDelegate {
  func networkStatusDidFinish(_ networkStatus: NetworkStatus)
}

class NetworkStatus: Operation {
  var delegate: NetworkStatusDelegate?
  var isReachable: Bool = false
  override func main() {
    if self.isCancelled {
      return
    }
    let reachableUrl = URL(string: "http://www.google.com")
    let reachableData = try? Data(contentsOf: reachableUrl!)
    if reachableData != nil {
      self.isReachable = true
    }
    DispatchQueue.main.async(execute: {
      self.delegate?.networkStatusDidFinish(self)
    })
  }
}
