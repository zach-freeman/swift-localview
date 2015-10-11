//
//  PhotoLoadViewController.swift
//  localview
//
//  Created by Zach Freeman on 8/15/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit


class PhotoLoadViewController: UIViewController {

  @IBOutlet weak var loadingLabel: UILabel!
  @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    Utils.showNetworkActivityIndicator()
    dispatch_async(dispatch_get_main_queue()) {
      self.loadingActivityIndicator.startAnimating()
    }
  }
  
  override func viewDidDisappear(animated: Bool) {
    Utils.hideNetworkActivityIndicator()
    dispatch_async(dispatch_get_main_queue()) {
      self.loadingActivityIndicator.stopAnimating()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func updateLoadingLabe(theLoadingText: String) {
    dispatch_async(dispatch_get_main_queue()) {
      self.loadingLabel.text = theLoadingText
      self.loadingLabel.setNeedsDisplay()
    }
  }
  


}
