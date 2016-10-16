//
//  Flickr.swift
//  localview
//
//  Created by Zach Freeman on 1/17/16.
//  Copyright © 2016 sparkwing. All rights reserved.
//

import Foundation

struct Flickr {
    static let url = FlickrConstants.kFlickrUrl
    static func parameters(_ latitude: String, longitude: String) -> [String: AnyObject] {
        return ["method": FlickrConstants.kSearchMethod as AnyObject,
            "api_key": FlickrConstants.kFlickrApiKey as AnyObject,
            "lat": latitude as AnyObject,
            "lon": longitude as AnyObject,
            "per_page": FlickrConstants.kNumberOfPhotos as AnyObject,
            "format": FlickrConstants.kFormatType as AnyObject,
            "privacy_filter": FlickrConstants.kPrivacyFilter as AnyObject,
            "nojsoncallback": FlickrConstants.kJsonCallback as AnyObject]
    }
}
