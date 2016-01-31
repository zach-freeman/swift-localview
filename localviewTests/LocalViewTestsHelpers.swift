//
//  LocalViewTestHelpers.swift
//  localview
//
//  Created by Zach Freeman on 1/24/16.
//  Copyright © 2016 sparkwing. All rights reserved.
//

import Foundation
import SwiftyJSON

public class LocalViewTestsHelpers {
    static func bundleFileContentsAsData(filename: String, filetype: String) -> NSData {
        let bundle = NSBundle(forClass: object_getClass(self))
        let filePath = bundle.pathForResource(filename, ofType: filetype)
        let fileContents:NSData = NSData(contentsOfFile: filePath!)!
        return fileContents
    }
    
    static func fileContentsAsJson(fileContents:NSData) -> JSON {
        var fileContentsJson:JSON = nil
        do {
            let fileContentJsonObject = try NSJSONSerialization.JSONObjectWithData(fileContents, options: NSJSONReadingOptions.MutableContainers)
            fileContentsJson = JSON(fileContentJsonObject)
        } catch {
            print("unable to convert file contents to json")
        }
        return fileContentsJson
    }
}
