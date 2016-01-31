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
    func request(latitude: String, longitude: String, response: AnyObject? -> ()) {
        Alamofire.request(.GET, Flickr.url, parameters: Flickr.parameters(latitude, longitude: longitude))
            .responseJSON{ (request, data, result) in
                response(result.value)
                
        }
    }
}
