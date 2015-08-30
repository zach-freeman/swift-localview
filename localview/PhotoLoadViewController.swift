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
    Utils.showNetworkActivityIndicator()
    self.loadingActivityIndicator.startAnimating()

    // Do any additional setup after loading the view.
  }
  
  override func viewDidDisappear(animated: Bool) {
    Utils.hideNetworkActivityIndicator()
    self.loadingActivityIndicator.stopAnimating()
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
