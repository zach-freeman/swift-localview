//
//  PhotoListManager.swift
//  localview
//
//  Created by Zach Freeman on 8/23/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import Foundation

protocol PhotoListManagerDelegate {
  func photoListManagerDidFinish(_ photoListManager : PhotoListManager)
}

class PhotoListManager:NSObject,NetworkStatusDelegate,LocationUpdaterDelegate,PhotoListFetcherDelegate {
    var delegate : PhotoListManagerDelegate?
    var currentPlacemark:String!
    var flickrPhotoList : [FlickrPhoto] = []
    var locationUpdater:LocationUpdater!
    var networkAccessQueue:OperationQueue {
        let queue = OperationQueue()
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
  
  func networkStatusDidFinish(_ networkStatus: NetworkStatus) {
    self.networkAccessQueue.cancelAllOperations()
    if networkStatus.isReachable == false {
      Utils.showReachabilityAlert()
      DispatchQueue.main.async(execute: {
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
  
  func locationAvailable(_ locationUpdater: LocationUpdater) {
    self.currentPlacemark = locationUpdater.currentPlacemark
    if !locationUpdater.currentLongitude.isEmpty &&
      !locationUpdater.currentLatitude.isEmpty {
        self.startPhotoListFetcherWithCoordinates(locationUpdater.currentLatitude, longitude: locationUpdater.currentLongitude)
    }
  }
  
  // MARK: - Photo List Fetcher
  func startPhotoListFetcherWithCoordinates(_ latitude:String, longitude:String) {
    
    let photoListFetcherOperation : PhotoListFetcher = PhotoListFetcher(currentLatitude: latitude, currentLongitude: longitude, currentNetwork: Network())
    photoListFetcherOperation.delegate = self
    self.networkAccessQueue.addOperation(photoListFetcherOperation)
  }
  
  func photoListFetcherDidFinish(_ photoListFetcher: PhotoListFetcher) {
    self.networkAccessQueue.cancelAllOperations()
    self.flickrPhotoList = photoListFetcher.flickrPhotos
    DispatchQueue.main.async(execute: {
        self.delegate?.photoListManagerDidFinish(self)
    })
    
  }
    
}
