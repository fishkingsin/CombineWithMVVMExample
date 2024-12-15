//
//  BottomSheetViewListItem.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 16/12/2024.
//

import SwiftUI


struct BottomSheetViewListItem: View {
    var item: UserGroupMemberPresentable
    var body: some View {
        HStack {
            Text(item.name)
            Text(item.role)
            Rectangle()
                .fill(item.avatarBackgroundColor.toSUIColor)
                .frame(width: 10, height: 10)
                
        }
    }
}
