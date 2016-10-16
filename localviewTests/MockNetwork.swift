//
//  MockNetwork.swift
//  localview
//
//  Created by Zach Freeman on 3/6/16.
//  Copyright © 2016 sparkwing. All rights reserved.
//

import Foundation
@testable import localview

class MockNetwork: Networking {
    var requestCount: Int = 0
    init() { }
    func request(_ latitude: String, longitude: String, completion: @escaping (Any?) -> ()) {
        requestCount = 1
        do {
            let flickrResponse: Data = LocalViewTestsHelpers
                .bundleFileContentsAsData("good-flickr-response", filetype: "json")
            let flickrResponseJsonObject = try JSONSerialization
                .jsonObject(with: flickrResponse,
                            options: JSONSerialization.ReadingOptions.mutableContainers)
            completion(flickrResponseJsonObject as AnyObject?)
        } catch _ {
            print("could not open flickr response file")
        }
    }
}
