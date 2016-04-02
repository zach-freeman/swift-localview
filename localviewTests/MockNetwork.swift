//
//  MockNetwork.swift
//  localview
//
//  Created by Zach Freeman on 3/6/16.
//  Copyright © 2016 sparkwing. All rights reserved.
//

import Foundation

class MockNetwork: Networking {
    var requestCount = 0
    
    func request(latitude: String, longitude: String, response: AnyObject? -> ()) {
        requestCount += 1
        do {
            let flickrResponse: NSData = LocalViewTestsHelpers.bundleFileContentsAsData("good-flickr-response", filetype: "json")
            let flickrResponseJsonObject = try NSJSONSerialization.JSONObjectWithData(flickrResponse, options: NSJSONReadingOptions.MutableContainers)
            response(flickrResponseJsonObject)
        } catch _ {
            print("could not open flickr response file")
        }
    }
}
