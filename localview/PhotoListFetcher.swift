//
//  PhotoListFetcher.swift
//  localview
//
//  Created by Zach Freeman on 8/13/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol PhotoListFetcherDelegate {
    func photoListFetcherDidFinish(photoListFetcher : PhotoListFetcher)
}

class PhotoListFetcher: NSOperation {
    var delegate : PhotoListFetcherDelegate?
    var flickrPhotos : [FlickrPhoto] = []
    var currentLatitude : String!
    var currentLongitude : String!
    let network: Networking
    
    init(currentLatitude : String, currentLongitude: String, currentNetwork: Networking) {
        self.currentLatitude = currentLatitude
        self.currentLongitude = currentLongitude
        self.network = currentNetwork
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        self.network.request(self.currentLatitude, longitude: self.currentLongitude) { response in
            let responseJson:JSON = JSON(response!)
            self.flickrPhotos = FlickrApiUtils.setupPhotoListWithJSON(responseJson)
            dispatch_async(dispatch_get_main_queue(), {
                self.delegate?.photoListFetcherDidFinish(self)
                
            })
            
        }
        
    }
}
