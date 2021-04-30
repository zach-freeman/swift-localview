//
//  PhotoListFetcher.swift
//  localview
//
//  Created by Zach Freeman on 8/13/15.
//  Copyright (c) 2021 sparkwing. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol PhotoListFetcherDelegate: AnyObject {
    func photoListFetcherDidFinish(_ photoListFetcher: PhotoListFetcher)
}

class PhotoListFetcher: Operation {
    weak var delegate: PhotoListFetcherDelegate?
    var flickrPhotos: [FlickrPhoto] = []
    var currentLatitude: String!
    var currentLongitude: String!
    var network: Networking!
    init(currentLatitude: String, currentLongitude: String, currentNetwork: Networking) {
        self.currentLatitude = currentLatitude
        self.currentLongitude = currentLongitude
        self.network = currentNetwork
    }
    override func main() {
        if self.isCancelled {
            return
        }
        self.network.request(self.currentLatitude, longitude: self.currentLongitude) { response in
            let responseJson: JSON = JSON(response!)
            self.flickrPhotos = FlickrApiUtils.setupPhotoListWithJSON(responseJson)
            DispatchQueue.main.async(execute: {
                self.delegate?.photoListFetcherDidFinish(self)
            })
        }
    }
}
