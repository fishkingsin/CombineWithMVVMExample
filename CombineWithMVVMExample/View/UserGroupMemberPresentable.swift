//
//  UserGroupMemberPresentable.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 18/7/2022.
//

import UIKit

public struct UserGroupMemberPresentable: Equatable, Hashable, Identifiable {
    
    public var id: UUID = { UUID() }()
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(role)
        hasher.combine(avatarBackgroundColor)
    }
    

    let name: String
    let role: String
    let avatarBackgroundColor: UIColor

}
