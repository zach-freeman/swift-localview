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
    
    let flickrSearchParameters = ["method": FlickrConstants.SEARCH_METHOD, "api_key": FlickrConstants.FLICKR_KEY, "lat": self.currentLatitude, "lon": self.currentLongitude, "per_page": FlickrConstants.NUMBER_OF_PHOTOS, "format": FlickrConstants.FORMAT_TYPE, "privacy_filter": FlickrConstants.PRIVACY_FILTER, "nojsoncallback": FlickrConstants.JSON_CALLBACK]
    Alamofire.request(Method.GET, FlickrConstants.FLICKR_URL, parameters: flickrSearchParameters as? [String : AnyObject]).responseJSON { (request, response, result) in
        var innerJson:JSON = JSON(result.value!)
        for (_, subJson) in innerJson["photos"]["photo"] {
          let flickrPhoto : FlickrPhoto = FlickrPhoto()
          flickrPhoto.title = subJson["title"].string
          flickrPhoto.bigImageUrl = flickrPhoto.photoUrlForSize(FlickrPhoto.FlickrPhotoSize.PhotoSizeLarge1024, photoDictionary: subJson)
          flickrPhoto.smallImageUrl = flickrPhoto.photoUrlForSize(FlickrPhoto.FlickrPhotoSize.PhotoSizeSmallSquare75, photoDictionary: subJson)
          flickrPhoto.photoSetId = subJson["id"].string
          self.flickrPhotos.append(flickrPhoto)
        }
        dispatch_async(dispatch_get_main_queue(), {
          self.delegate?.photoListFetcherDidFinish(self)
        })
        
      
      

      
    }
    
    
    
    
  }
}
