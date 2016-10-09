//
//  FlickrApiUtils.swift
//  localview
//
//  Created by Zach Freeman on 10/7/15.
//  Copyright © 2015 sparkwing. All rights reserved.
//

import UIKit
import SwiftyJSON

open class FlickrApiUtils {
    
    public enum PhotoFetchState: Int {
        case photoListNotFetched
        case photoListFetched
        case photosNotFetched
        case photosFetched
    }
    
    public enum FlickrPhotoSize: Int {
        case photoSizeUnknown
        case photoSizeCollectionIconLarge
        case photoSizeBuddyIcon
        case photoSizeSmallSquare75
        case photoSizeLargeSquare150
        case photoSizeThumbnail100
        case photoSizeSmall240
        case photoSizeSmall320
        case photoSizeMedium500
        case photoSizeMedium640
        case photoSizeMedium800
        case photoSizeLarge1024
        case photoSizeLarge1600
        case photoSizeLarge2048
        case photoSizeOriginal
        case photoSizeVideoOriginal
        case photoSizeVideoHDMP4
        case photoSizeVideoSiteMP4
        case photoSizeVideoMobileMP4
        case photoSizeVideoPlayer
    }
    
    class func setupPhotoListWithJSON(_ json: JSON) -> [FlickrPhoto] {
        var flickrPhotos:[FlickrPhoto] = []
        let thePhotoArray : JSON! = json["photos"]["photo"]
        if thePhotoArray.count > 0 {
            for (_, flickrPhotoDictionary) in thePhotoArray {
                let flickrPhoto : FlickrPhoto = FlickrPhoto()
                flickrPhoto.title = flickrPhotoDictionary["title"].string
                flickrPhoto.bigImageUrl = FlickrApiUtils.photoUrlForSize(FlickrConstants.BIG_IMAGE_SIZE, photoDictionary: flickrPhotoDictionary)
                flickrPhoto.smallImageUrl = FlickrApiUtils.photoUrlForSize(FlickrConstants.SMALL_IMAGE_SIZE, photoDictionary: flickrPhotoDictionary)
                flickrPhoto.photoSetId = flickrPhotoDictionary["id"].string
                flickrPhotos.append(flickrPhoto)
            }
        }
        return flickrPhotos
    }
    
    class func photoUrlForSize(_ size: FlickrPhotoSize, photoDictionary: JSON!) -> URL {
        let photoId = photoDictionary["id"].string!
        let server = photoDictionary["server"].string!
        
        let farm : String? = photoDictionary["farm"].string
        let secret = photoDictionary["secret"].string!
        
        let photoUrl = photoUrlForSize(size, photoId: photoId, server: server, secret: secret, farm: farm)
        return photoUrl
    }
    
    class func photoUrlForSize(_ size: FlickrPhotoSize, photoId : String, server: String, secret: String, farm: String?) -> URL {
        // https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
        // https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
        var photoUrlString = "https://"
        if let _ = farm {
            photoUrlString += "farm\(farm!)."
        }
        let sizeSuffix = suffixForSize(size)
        assert(server.characters.count > 0, "Server attribute is required")
        assert(secret.characters.count > 0, "Secret attribute is required")
        assert(photoId.characters.count > 0, "Id attribute is required")
        photoUrlString += FlickrConstants.FLICKR_PHOTO_SOURCE_HOST + "/\(server)/\(photoId)_\(secret)_\(sizeSuffix).jpg"
        return URL(string: photoUrlString)!
    }
    
    class func suffixForSize(_ size: FlickrPhotoSize) -> String {
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
