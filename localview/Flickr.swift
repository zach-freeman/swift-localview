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
    
    static func parameters(latitude: String, longitude: String) -> [String: AnyObject] {
        return ["method": FlickrConstants.SEARCH_METHOD,
            "api_key": FlickrConstants.FLICKR_KEY,
            "lat": latitude,
            "lon": longitude,
            "per_page": FlickrConstants.NUMBER_OF_PHOTOS,
            "format": FlickrConstants.FORMAT_TYPE,
            "privacy_filter": FlickrConstants.PRIVACY_FILTER,
            "nojsoncallback": FlickrConstants.JSON_CALLBACK]
    }
    
}
