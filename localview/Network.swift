//
//  Network.swift
//  localview
//
//  Created by Zach Freeman on 1/17/16.
//  Copyright © 2016 sparkwing. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


struct Network : Networking {
    func request(latitude: String, longitude: String, jsonResponse: AnyObject? -> ()) {
        Alamofire.request(.GET,
            Flickr.url,
            parameters: Flickr.parameters(latitude, longitude: longitude))
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching flickr photos: \(response.result.error)")
                    return
                }
                
                jsonResponse(response.result.value)
        }
    }
}
