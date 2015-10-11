//
//  PhotoListManager.swift
//  localview
//
//  Created by Zach Freeman on 8/23/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import Foundation

protocol PhotoListManagerDelegate {
  func photoListManagerDidFinish(photoListManager : PhotoListManager)
}

class PhotoListManager:NSObject,NetworkStatusDelegate,LocationUpdaterDelegate,PhotoListFetcherDelegate {
    var delegate : PhotoListManagerDelegate?
    var currentPlacemark:String!
    var flickrPhotoList : [FlickrPhoto] = []
    var locationUpdater:LocationUpdater!
    var networkAccessQueue:NSOperationQueue {
        let queue = NSOperationQueue()
        queue.name = "NetworkAccessQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }
  
  override init() {
    super.init()
    self.currentPlacemark = ""
    self.startNetworkStatus()
    
  }

  // MARK: - Network Status
  func startNetworkStatus() {
    
    let networkStatusOperation : NetworkStatus = NetworkStatus();
    networkStatusOperation.delegate = self
    self.networkAccessQueue.addOperation(networkStatusOperation)
  }
  
  func networkStatusDidFinish(networkStatus: NetworkStatus) {
    self.networkAccessQueue.cancelAllOperations()
    if networkStatus.isReachable == false {
      Utils.showReachabilityAlert()
      dispatch_async(dispatch_get_main_queue(), {
        self.delegate?.photoListManagerDidFinish(self)
      })
    } else if networkStatus.isReachable == true {
      self.startLocationUpdater()
    }
  }
  
  // MARK: - Location Updater
  func startLocationUpdater() {
    self.locationUpdater = LocationUpdater()
    self.locationUpdater.locationUpdaterDelegate = self
  }
  
  func locationAvailable(locationUpdater: LocationUpdater) {
    self.currentPlacemark = locationUpdater.currentPlacemark
    if !locationUpdater.currentLongitude.isEmpty &&
      !locationUpdater.currentLatitude.isEmpty {
        self.startPhotoListFetcherWithCoordinates(locationUpdater.currentLatitude, longitude: locationUpdater.currentLongitude)
    }
  }
  
  // MARK: - Photo List Fetcher
  func startPhotoListFetcherWithCoordinates(latitude:String, longitude:String) {
    
    let photoListFetcherOperation : PhotoListFetcher = PhotoListFetcher(currentLatitude: latitude, currentLongitude: longitude)
    photoListFetcherOperation.delegate = self
    self.networkAccessQueue.addOperation(photoListFetcherOperation)
  }
  
  func photoListFetcherDidFinish(photoListFetcher: PhotoListFetcher) {
    self.networkAccessQueue.cancelAllOperations()
    self.flickrPhotoList = photoListFetcher.flickrPhotos
    dispatch_async(dispatch_get_main_queue(), {
        self.delegate?.photoListManagerDidFinish(self)
    })
    
  }
    
}