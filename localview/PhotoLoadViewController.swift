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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Utils.showNetworkActivityIndicator()
    DispatchQueue.main.async {
      self.loadingActivityIndicator.startAnimating()
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    Utils.hideNetworkActivityIndicator()
    DispatchQueue.main.async {
      self.loadingActivityIndicator.stopAnimating()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

}
