//
//  FlickrPhotoTests.swift
//  localview
//
//  Created by Zach Freeman on 8/14/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit
import XCTest

class FlickrPhotoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPhotoUrlForSize() {
        // This is an example of a functional test case.
      var flickrPhoto = FlickrPhoto()
      let expectedUrlString : String = "https://farm1.static.flickr.com/2/1418878_1e9228336_b.jpg"
      var expectedUrl = NSURL(string: expectedUrlString)
      let photoUrl = flickrPhoto.photoUrlForSize(FlickrPhoto.FlickrPhotoSize.PhotoSizeLarge1024, photoId: "1418878", server: "2", secret: "1e9228336", farm: "1")
      XCTAssertEqual(expectedUrl!, photoUrl, "pass")
      
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
