//
//  BottomSheetView.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 15/12/2024.
//

import SwiftUI
import Combine

struct Country {
    let name: String
}

struct BottomSheetView: View {
    private var selectedIds: Binding<[UUID]>
    let options: [UserGroupMemberPresentable]
    var onDismissClick: () -> Void
    
    init(selectedIds: Binding<[UUID]>, options: [UserGroupMemberPresentable], onDismissClick: @escaping () -> Void) {
        self.selectedIds = selectedIds
        self.options = options
        self.onDismissClick = onDismissClick
    }
    
    var body: some View {
        
        VStack {
            Form {
                Selectables(options, selectedIds: selectedIds) { item, isSelected in
                    BottomSheetViewListItem(item: item)
                        .font(.title)
                        .foregroundColor(isSelected.wrappedValue ? .green : .primary)
                        .onTapGesture {
                            isSelected.wrappedValue.toggle()
                        }
                    //                HStack {
                    //                    Text(item.name)
                    //                        .font(.title)
                    //                    Spacer()
                    //                    Toggle("", isOn: isSelected)
                    //                        .labelsHidden()
                    //                }
                }
            }
            Button("Dismiss", action: onDismissClick)
            
        }
    }
}


#Preview {
    BottomSheetView(
        selectedIds: .init(
            get: { [] }, set: { _ in
            }
        ), options: []) {
            
        }
}
