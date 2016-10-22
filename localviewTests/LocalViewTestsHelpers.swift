//
//  LocalViewTestHelpers.swift
//  localview
//
//  Created by Zach Freeman on 1/24/16.
//  Copyright © 2016 sparkwing. All rights reserved.
//

import Foundation
import SwiftyJSON

open class LocalViewTestsHelpers {
    static func bundleFileContentsAsData(_ filename: String, filetype: String) -> Data {
        let bundle = Bundle(for: object_getClass(self))
        let filePath = bundle.path(forResource: filename, ofType: filetype)
        do {
            let fileContents: Data = try Data(contentsOf: URL(fileURLWithPath: filePath!))
            return fileContents
        } catch {
            print("unable to get file contents of \(filename)")
            return Data()
        }
    }
    static func fileContentsAsJson(_ fileContents: NSData) -> JSON {
        var fileContentsJson: JSON = nil
        do {
            let fileContentJsonObject = try JSONSerialization
                .jsonObject(with: fileContents as Data,
                            options: JSONSerialization.ReadingOptions.mutableContainers)
            fileContentsJson = JSON(fileContentJsonObject)
        } catch {
            print("unable to convert file contents to json")
        }
        return fileContentsJson
    }
}
