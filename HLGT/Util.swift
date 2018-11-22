//
//  Util.swift
//  HLGT
//
//  Created by MAC on 7/30/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        print(fileURL)
        return fileURL.path
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            print(fromPath)
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            if (error != nil) {
                print("Error Occured")
            } else {
                print("Your database copy successfully")
            }
        }
    }
    
    class func invokeAlertMethod(strTitle: NSString, strBody: NSString, delegate: AnyObject?) {
        //        let alert: UIAlertView = UIAlertView()
        //        alert.message = strBody as String
        //        alert.title = strTitle as String
        //        alert.delegate = delegate
        //        alert.addButton(withTitle: "Ok")
        //        alert.show()
    }
    
}
