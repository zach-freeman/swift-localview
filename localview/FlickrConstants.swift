//
//  FlickrConstants.swift
//  localview
//
//  Created by Zach Freeman on 8/13/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit

class FlickrConstants: NSObject {
  static let kFlickrApiKey: String = "yourFlickrApiKey"
  static let kFlickrUrl: String = "https://api.flickr.com/services/rest/"
  static let kSearchMethod: String = "flickr.photos.search"
  static let kFormatType: String = "json"
  static let kJsonCallback: Int = 1
  static let kPrivacyFilter: Int = 1
  static let kNumberOfPhotos: String = "100"
  static let kFlickrPhotoSourceHost: String = "static.flickr.com"
  static let kTitleNotAvailable: String = "Title not available"
  static let kSmallImageSize: FlickrApiUtils.FlickrPhotoSize = FlickrApiUtils.FlickrPhotoSize.photoSizeSmallSquare75
  static let kBigImageSize: FlickrApiUtils.FlickrPhotoSize = FlickrApiUtils.FlickrPhotoSize.photoSizeLarge1024
  static let kMaxTitleSize: String = "UmjLyNul3eFoj5zVivYVfR18coNUSInD3rRO2ABzwSDzigNATEJTam0HlMVwcoY0LBeK4m4Zhwu0ZC7S24GrONKymeEXVUMDst97IN96caaZw44c94ClHK1X6sIpSvoSqVejiTu6Fscq12zIi2zwHjROVYwhH4mcvUgGLz3Q06ZCq8fuxwUGBcK3n9h6SXqj3EnRjHF182yXoNN9eM4PW3ZUHgh0y449WnAHpTIex46ys8q3itu9GTTSPXGeVLG"
}
