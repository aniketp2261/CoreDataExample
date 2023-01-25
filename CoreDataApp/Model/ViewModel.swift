//
//  ViewModel.swift
//  CoreDataApp
//
//  Created by Aniket Patil on 23/01/23.
//

import Foundation

// MARK: - ViewModel
struct ViewModel: Codable {
    let data: String
    let data1: [EmployeeData]
}

// MARK: - EmployeeData
struct EmployeeData: Codable {
    let memberID: Int
    let memberName: String
    let profilePhoto: String
    let mobileNo, organizationid, organizationName, address: String
    let description, firstName, middleName, lastName: String
    let name: String
    let isChatBlock: Bool

    enum CodingKeys: String, CodingKey {
        case memberID = "MemberId"
        case memberName = "MemberName"
        case profilePhoto = "ProfilePhoto"
        case mobileNo = "MobileNo"
        case organizationid = "Organizationid"
        case organizationName = "OrganizationName"
        case address = "Address"
        case description = "Description"
        case firstName = "FirstName"
        case middleName = "MiddleName"
        case lastName = "LastName"
        case name = "Name"
        case isChatBlock = "IsChatBlock"
    }
}
