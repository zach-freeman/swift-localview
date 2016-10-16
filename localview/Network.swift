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


struct Network: Networking {
    func request(_ latitude: String, longitude: String, completion: @escaping (Any?) -> ()) {
        Alamofire.request(Flickr.url, parameters: Flickr.parameters(latitude, longitude: longitude))
            .responseJSON { response in
                completion(response.result.value)
        }
    }
}
