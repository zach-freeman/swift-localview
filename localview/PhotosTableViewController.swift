//
//  PhotosTableViewController.swift
//  localview
//
//  Created by Zach Freeman on 8/13/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PhotosTableViewController: UITableViewController, PhotoListManagerDelegate {

  var flickrPhotoList : [FlickrPhoto] = []
  var photoListManager:PhotoListManager!
  var photoLoadViewController:PhotoLoadViewController!
  var photoFetchState:FlickrPhoto.PhotoFetchState?

  @IBOutlet weak var refreshButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.photoFetchState = .PhotoListNotFetched
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    self.photoLoadViewController = storyboard.instantiateViewControllerWithIdentifier("PhotoLoadViewController") as! PhotoLoadViewController
    
  }
  
  override func viewDidAppear(animated: Bool) {
    if (self.photoFetchState == .PhotoListNotFetched) {
      self.startPhotoListManager()
    }
  }
  
  @IBAction func refreshButtonTapped(sender: AnyObject) {
    self.photoFetchState = .PhotoListNotFetched
    self.tableView.hidden = false
    self.startPhotoListManager()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // Return the number of sections.
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows in the section.
    return self.flickrPhotoList.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell:PhotoTableCell = tableView.dequeueReusableCellWithIdentifier("PhotoTableCell", forIndexPath: indexPath) as! PhotoTableCell
    let previewImageLayer = cell.previewImageView.layer
    Utils.setupRoundedCornersForLayer(previewImageLayer)
    let placeholder:UIImage = UIImage(named: "placeholder")!
    cell.previewImageView.sd_setImageWithURL(self.flickrPhotoList[indexPath.row].smallImageUrl!, placeholderImage: placeholder)
    let photoTitle : String = self.flickrPhotoList[indexPath.row].title!
    if photoTitle.isEmpty {
      cell.titleLabel.text = "Title not available"
      cell.titleLabel.textColor = UIColor.grayColor()
    } else {
      cell.titleLabel.text = photoTitle
      cell.titleLabel.textColor = UIColor.blackColor()
    }
    
    // Configure the cell...
    
    return cell
  }
  
  // MARK: - Photo List Manager
  func startPhotoListManager() {
    self.navigationController?.presentViewController(self.photoLoadViewController, animated: true, completion: nil)
    self.photoListManager = PhotoListManager()
    self.photoListManager.delegate = self
  }
  
  func photoListManagerDidFinish(photoListManager : PhotoListManager) {
    self.photoFetchState = .PhotoListFetched
    if photoListManager.flickrPhotoList.count > 0 {
      self.flickrPhotoList = photoListManager.flickrPhotoList
    }
    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    self.tableView.reloadData()
    
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let senderPath:NSIndexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
    let selectedRow:Int = senderPath.row
    let photoFullScreenViewController:PhotoFullScreenViewController = segue.destinationViewController as! PhotoFullScreenViewController
    photoFullScreenViewController.flickrPhoto = self.flickrPhotoList[selectedRow]
  }
  
  
}
