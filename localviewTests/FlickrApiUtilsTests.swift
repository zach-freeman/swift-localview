//
//  FlickrPhotoTests.swift
//  localview
//
//  Created by Zach Freeman on 8/14/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit
import XCTest
import SwiftyJSON

class FlickrApiUtilsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPhotoUrlForSize_LargeImageSize_returnsValidUrl() {
        // This is an example of a functional test case.
      let expectedUrlString : String = "https://farm1.static.flickr.com/2/1418878_1e9228336_b.jpg"
      let expectedUrl = NSURL(string: expectedUrlString)
      let photoUrl = FlickrApiUtils.photoUrlForSize(FlickrConstants.BIG_IMAGE_SIZE, photoId: "1418878", server: "2", secret: "1e9228336", farm: "1")
      XCTAssertEqual(expectedUrl!, photoUrl, "pass")
      
    }
    
    func testPhotoUrlForSize_SmallImageSize_returnsValidUrl() {
        // This is an example of a functional test case.
        let expectedUrlString : String = "https://farm1.static.flickr.com/2/1418878_1e9228336_s.jpg"
        let expectedUrl = NSURL(string: expectedUrlString)
        let photoUrl = FlickrApiUtils.photoUrlForSize(FlickrConstants.SMALL_IMAGE_SIZE, photoId: "1418878", server: "2", secret: "1e9228336", farm: "1")
        XCTAssertEqual(expectedUrl!, photoUrl, "pass")
        
    }
    
    func testSetupPhotoListWithJson_GoodFlickrResponse_returns5FlickrPhotos() {
        
        do {
            let emptyData = NSData()
            let goodFlickrResponse: NSData = bundleFileContentsAsData("good-flickr-response", filetype: "json")
            XCTAssertNotEqual(goodFlickrResponse.length, emptyData.length, "pass")
            let goodFlickrResponseJsonObject = try NSJSONSerialization.JSONObjectWithData(goodFlickrResponse, options: NSJSONReadingOptions.MutableContainers)
            let goodFlickrResponseJson:JSON = JSON(goodFlickrResponseJsonObject)
            XCTAssertNotEqual("", goodFlickrResponseJson, "pass")
            let flickrPhotoList = FlickrApiUtils.setupPhotoListWithJSON(goodFlickrResponseJson)
            XCTAssertEqual(flickrPhotoList.count, 5, "pass")
        } catch _ {
            print("could not open good flickr response file")
        }
        
    }
    
    func testSetupPhotoList_BadFlickrResponse_returns0FlickrPhotos() {
        
        do {
            let emptyData = NSData()
            let goodFlickrResponse: NSData = bundleFileContentsAsData("bad-flickr-response", filetype: "json")
            XCTAssertNotEqual(goodFlickrResponse.length, emptyData.length, "pass")
            let goodFlickrResponseJsonObject = try NSJSONSerialization.JSONObjectWithData(goodFlickrResponse, options: NSJSONReadingOptions.MutableContainers)
            let goodFlickrResponseJson:JSON = JSON(goodFlickrResponseJsonObject)
            XCTAssertNotEqual("", goodFlickrResponseJson, "pass")
            let flickrPhotoList = FlickrApiUtils.setupPhotoListWithJSON(goodFlickrResponseJson)
            XCTAssertEqual(flickrPhotoList.count, 0, "pass")
        } catch _ {
            print("could not open good flickr response file")
        }
        
    }
    
    func bundleFileContentsAsData(filename: String, filetype: String) -> NSData {
        let bundle = NSBundle(forClass: object_getClass(self))
        let filePath = bundle.pathForResource(filename, ofType: filetype)
        let fileContents:NSData = NSData(contentsOfFile: filePath!)!
        return fileContents
    }


}
