//
//  FileManager.swift
//  simpletodotest
//
//  Created by Dmytrii Sinko on 04.02.17.
//  Copyright © 2017 Dmytrii Sinko. All rights reserved.
//

import Foundation
import UIKit

struct FileManager {
    
    static func getDocDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    static func pathToFileInDocumentsDirectory(_ filename: String) -> URL {
        return URL(fileURLWithPath: FileManager.getDocDir()).appendingPathComponent(filename)
    }
    
    static func saveImageToDocumentsDirectory(_ filename: String, image: UIImage) -> URL? {
        let filePath = FileManager.pathToFileInDocumentsDirectory(filename)
        guard let fileData = UIImagePNGRepresentation(image) else {
            // Just dummy printing for now
            print("Failed converting UIImage to Data")
            return nil
        }

        do {
            try fileData.write(to: filePath, options: [])
        } catch let error {
            // We should send some analytics report here, but for testing purpose we just print error
            print("Failed saving image: " + error.localizedDescription)
            return nil
        }

        return filePath
    }
    
    static func getImageFromDocumentsDirectory(_ filename: String) -> UIImage? {
        let filePath = FileManager.pathToFileInDocumentsDirectory(filename)
        do {
            let d = try Data(contentsOf: filePath)
            return UIImage(data: d)
        } catch let error {
            print("Failed loading image: " + error.localizedDescription)
            return nil
        }
    }
    
    static func removeImageFromDocumentsDirectory(_ filename: String) {
        let filePath = FileManager.pathToFileInDocumentsDirectory(filename)
        let fm = Foundation.FileManager()
        do {
            try fm.removeItem(at: filePath)
        } catch let error {
            // We should send some analytics report here, but for testing purpose we just print error
            print("Failed removing image: " + error.localizedDescription)
        }
    }
    
}
