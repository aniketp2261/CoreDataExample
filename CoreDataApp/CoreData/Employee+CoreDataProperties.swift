//
//  Employee+CoreDataProperties.swift
//  CoreDataApp
//
//  Created by Aniket Patil on 23/01/23.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var memberName: String?
    @NSManaged public var profilePhoto: String?
    @NSManaged public var mobileNo: String?
    @NSManaged public var organizationName: String?
    @NSManaged public var fullName: String?

}

extension Employee : Identifiable {

}
