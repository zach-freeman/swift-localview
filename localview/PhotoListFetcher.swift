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
    
    init(currentLatitude : String, currentLongitude: String) {
        self.currentLatitude = currentLatitude
        self.currentLongitude = currentLongitude
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let flickrSearchParameters = FlickrApiUtils.searchParametersForCoordinates(self.currentLatitude, longitude: self.currentLongitude)
        
        Alamofire.request(Method.GET, FlickrConstants.FLICKR_URL, parameters: flickrSearchParameters).responseJSON { (request, response, result) in
            
            let responseJson:JSON = JSON(result.value!)
            self.flickrPhotos = FlickrApiUtils.setupPhotoListWithJSON(responseJson)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.delegate?.photoListFetcherDidFinish(self)

            })
            
        }
        
    }
}
