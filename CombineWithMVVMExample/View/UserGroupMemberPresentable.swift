//
//  UserGroupMemberPresentable.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 18/7/2022.
//

import UIKit

public struct UserGroupMemberPresentable: Equatable, Hashable, Identifiable {
    let _id = UUID()
    public var id: UUID  = UUID()
    

    let name: String
    let role: String
    let avatarBackgroundColor: UIColor

}
