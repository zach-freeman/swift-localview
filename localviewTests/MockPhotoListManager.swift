//
//  MockPhotoListManager.swift
//  localview
//
//  Created by Zach Freeman on 2/7/16.
//  Copyright © 2016 sparkwing. All rights reserved.
//

import Foundation

class MockPhotoListManager: PhotoListManager {
    var startNetworkStatusRequestCount = 0
    override func startNetworkStatus() {
        startNetworkStatusRequestCount = 1
    }
}
