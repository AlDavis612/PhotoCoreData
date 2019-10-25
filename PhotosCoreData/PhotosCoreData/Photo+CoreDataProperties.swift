//
//  Photo+CoreDataProperties.swift
//  PhotosCoreData
//
//  Created by Alex Davis on 10/25/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var body: String?
    @NSManaged public var rawDate: Date?
    @NSManaged public var rawImage: Data?
    @NSManaged public var title: String?

}
