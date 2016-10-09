//
//  Flickr.swift
//  localview
//
//  Created by Zach Freeman on 1/17/16.
//  Copyright © 2016 sparkwing. All rights reserved.
//

import Foundation

struct Flickr {
    
    static let url = FlickrConstants.FLICKR_URL
    
    static func parameters(_ latitude: String, longitude: String) -> [String: AnyObject] {
        return ["method": FlickrConstants.SEARCH_METHOD as AnyObject,
            "api_key": FlickrConstants.FLICKR_KEY as AnyObject,
            "lat": latitude as AnyObject,
            "lon": longitude as AnyObject,
            "per_page": FlickrConstants.NUMBER_OF_PHOTOS as AnyObject,
            "format": FlickrConstants.FORMAT_TYPE as AnyObject,
            "privacy_filter": FlickrConstants.PRIVACY_FILTER as AnyObject,
            "nojsoncallback": FlickrConstants.JSON_CALLBACK as AnyObject]
    }
    
}
