//
//  FlickrPhoto.swift
//  localview
//
//  Created by Zach Freeman on 8/13/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit
import SwiftyJSON

public class FlickrPhoto: NSObject {
  
  public enum PhotoFetchState: Int {
    case PhotoListNotFetched
    case PhotoListFetched
    case PhotosNotFetched
    case PhotosFetched
  }
  
  public enum FlickrPhotoSize: Int {
    case PhotoSizeUnknown
    case PhotoSizeCollectionIconLarge
    case PhotoSizeBuddyIcon
    case PhotoSizeSmallSquare75
    case PhotoSizeLargeSquare150
    case PhotoSizeThumbnail100
    case PhotoSizeSmall240
    case PhotoSizeSmall320
    case PhotoSizeMedium500
    case PhotoSizeMedium640
    case PhotoSizeMedium800
    case PhotoSizeLarge1024
    case PhotoSizeLarge1600
    case PhotoSizeLarge2048
    case PhotoSizeOriginal
    case PhotoSizeVideoOriginal
    case PhotoSizeVideoHDMP4
    case PhotoSizeVideoSiteMP4
    case PhotoSizeVideoMobileMP4
    case PhotoSizeVideoPlayer
  }
  
  var photoSetId : String?
  var smallImageUrl : NSURL?
  var bigImageUrl : NSURL?
  var title : String?
  
  func photoUrlForSize(size: FlickrPhotoSize, photoDictionary: JSON!) -> NSURL {
    var photoId = photoDictionary["id"].string!
    var server = photoDictionary["server"].string!
   
    var farm : String? = photoDictionary["farm"].string
    var secret = photoDictionary["secret"].string!
    
    let photoUrl = photoUrlForSize(size, photoId: photoId, server: server, secret: secret, farm: farm)
    return photoUrl
  }
  
  func photoUrlForSize(size: FlickrPhotoSize, photoId : String, server: String, secret: String, farm: String?) -> NSURL {
    // https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
    // https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
    var photoUrlString = "https://"
    if let unwrappedFarm = farm {
      photoUrlString += "farm\(farm)."
    }
    var sizeSuffix = suffixForSize(size)
    assert(count(server) > 0, "Server attribute is required")
    assert(count(secret) > 0, "Secret attribute is required")
    assert(count(photoId) > 0, "Id attribute is required")
    photoUrlString += FlickrConstants.FLICKR_PHOTO_SOURCE_HOST + "/\(server)/\(photoId)_\(secret)_\(sizeSuffix).jpg"
    return NSURL(string: photoUrlString)!
  }
  
  func suffixForSize(size: FlickrPhotoSize) -> String {
    let suffixArray : [String] = ["",
      "collectionIconLarge",
      "buddyIcon",
      "s",
      "q",
      "t",
      "m",
      "n",
      "",
      "z",
      "c",
      "b",
      "h",
      "k",
      "o",
      "",
      "",
      "",
      "",
      ""]
    return suffixArray[size.rawValue];
  }
}
