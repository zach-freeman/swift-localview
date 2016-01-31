//
//  FlickrApiUtils.swift
//  localview
//
//  Created by Zach Freeman on 10/7/15.
//  Copyright © 2015 sparkwing. All rights reserved.
//

import UIKit
import SwiftyJSON

public class FlickrApiUtils {
    
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
    
    class func setupPhotoListWithJSON(json: JSON) -> [FlickrPhoto] {
        var flickrPhotos:[FlickrPhoto] = []
        for (_, flickrPhotoDictionary) in json["photos"]["photo"] {
            let flickrPhoto : FlickrPhoto = FlickrPhoto()
            flickrPhoto.title = flickrPhotoDictionary["title"].string
            flickrPhoto.bigImageUrl = FlickrApiUtils.photoUrlForSize(FlickrConstants.BIG_IMAGE_SIZE, photoDictionary: flickrPhotoDictionary)
            flickrPhoto.smallImageUrl = FlickrApiUtils.photoUrlForSize(FlickrConstants.SMALL_IMAGE_SIZE, photoDictionary: flickrPhotoDictionary)
            flickrPhoto.photoSetId = flickrPhotoDictionary["id"].string
            flickrPhotos.append(flickrPhoto)
        }
        return flickrPhotos
    }
    
    class func photoUrlForSize(size: FlickrPhotoSize, photoDictionary: JSON!) -> NSURL {
        let photoId = photoDictionary["id"].string!
        let server = photoDictionary["server"].string!
        
        let farm : String? = photoDictionary["farm"].string
        let secret = photoDictionary["secret"].string!
        
        let photoUrl = photoUrlForSize(size, photoId: photoId, server: server, secret: secret, farm: farm)
        return photoUrl
    }
    
    class func photoUrlForSize(size: FlickrPhotoSize, photoId : String, server: String, secret: String, farm: String?) -> NSURL {
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
        return NSURL(string: photoUrlString)!
    }
    
    class func suffixForSize(size: FlickrPhotoSize) -> String {
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
