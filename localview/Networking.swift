//
//  Networking.swift
//  localview
//
//  Created by Zach Freeman on 1/17/16.
//  Copyright © 2016 sparkwing. All rights reserved.
//
import SwiftyJSON

protocol Networking {
    func request(latitude: String, longitude: String, response: AnyObject? -> ())
}