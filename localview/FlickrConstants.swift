//
//  FlickrConstants.swift
//  localview
//
//  Created by Zach Freeman on 8/13/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit

class FlickrConstants: NSObject {
  static let FLICKR_KEY:String = "yourFlickrApiKey"
  static let FLICKR_URL:String = "https://api.flickr.com/services/rest/"
  static let SEARCH_METHOD:String = "flickr.photos.search"
  static let FORMAT_TYPE:String = "json"
  static let JSON_CALLBACK:Int = 1
  static let PRIVACY_FILTER:Int = 1
  static let NUMBER_OF_PHOTOS:String = "100"
  static let FLICKR_PHOTO_SOURCE_HOST:String = "static.flickr.com"
  static let TITLE_NOT_AVAILABLE:String = "Title not available"
  static let SMALL_IMAGE_SIZE:FlickrApiUtils.FlickrPhotoSize = FlickrApiUtils.FlickrPhotoSize.PhotoSizeSmallSquare75
  static let BIG_IMAGE_SIZE:FlickrApiUtils.FlickrPhotoSize = FlickrApiUtils.FlickrPhotoSize.PhotoSizeLarge1024
  static let MAX_TITLE_STRING:String = "UmjLyNul3eFoj5zVivYVfR18coNUSInD3rRO2ABzwSDzigNATEJTam0HlMVwcoY0LBeK4m4Zhwu0ZC7S24GrONKymeEXVUMDst97IN96caaZw44c94ClHK1X6sIpSvoSqVejiTu6Fscq12zIi2zwHjROVYwhH4mcvUgGLz3Q06ZCq8fuxwUGBcK3n9h6SXqj3EnRjHF182yXoNN9eM4PW3ZUHgh0y449WnAHpTIex46ys8q3itu9GTTSPXGeVLG"
}
