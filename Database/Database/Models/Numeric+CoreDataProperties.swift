//
//  Numeric+CoreDataProperties.swift
//  
//
//  Created by Andrew Romanov on 09.11.2020.
//
//

import Foundation
import CoreData


extension Numeric {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Numeric> {
        return NSFetchRequest<Numeric>(entityName: "Numeric")
    }
    @NSManaged public var title: String?
    @NSManaged public var value: Int32
}
