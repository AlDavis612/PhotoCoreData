//
//  Photo+CoreDataClass.swift
//  PhotosCoreData
//
//  Created by Alex Davis on 10/25/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    var addDate: Date? {
            get {
                return rawDate as Date?
            }
            set {
                rawDate = newValue as NSDate?
            }
        }
        
        var image: UIImage? {
            get {
                if let imageData = rawImage as Data? {
                    return UIImage(data: imageData)
                } else {
                    return nil
                }
            }
            set {
                if let image = newValue {
                    rawImage = convertImageToNSData(image: image)
                }
            }
        }
        
        convenience init?(title: String, body: String?, image: UIImage?) {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            guard let managedContext = appDelegate?.persistentContainer.viewContext, !title.isEmpty else {
                return nil
            }
            
            self.init(entity: Photo.entity(), insertInto: managedContext)
            self.title = title
            self.body = body
            self.addDate = Date(timeIntervalSinceNow: 0)
            
            if let image = image {
                self.rawImage = convertImageToNSData(image: image)
            }
        }
    
    func processImage(image: UIImage) -> UIImage {
        if (image.imageOrientation == .up) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        guard let unwrappedCopy = copy else {
            return image
        }
        
        return unwrappedCopy
    }
        
        func convertImageToNSData(image: UIImage) -> NSData? {
            return processImage(image: image).pngData() as NSData?
        }
        
}
