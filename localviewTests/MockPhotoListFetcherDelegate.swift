//
//  MockPhotoListFetcherDelegate.swift
//  localview
//
//  Created by Zach Freeman on 3/6/16.
//  Copyright © 2016 sparkwing. All rights reserved.
//

import Foundation

class MockPhotoListFetcherDelegate: PhotoListFetcherDelegate {
    var delegateCallCount = 0
    func photoListFetcherDidFinish(_ photoListFetcher: PhotoListFetcher) {
        delegateCallCount += 1
    }
}
