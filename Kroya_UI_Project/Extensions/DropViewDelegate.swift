//
//  DropViewDelegate.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 19/10/24.
//

import SwiftUI

struct DropViewDelegate: DropDelegate {
    let destinationItem: Ingredient
    @Binding var ingredients: [Ingredient]
    @Binding var draggedItem: Ingredient?

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }

    func dropEntered(info: DropInfo) {
        if let draggedItem = draggedItem {
            // Find the index of the dragged item and the destination item
            if let fromIndex = ingredients.firstIndex(where: { $0.id == draggedItem.id }),
               let toIndex = ingredients.firstIndex(where: { $0.id == destinationItem.id }),
               fromIndex != toIndex {
                withAnimation {
                    // Move the item from the old index to the new index
                    ingredients.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
                }
            }
        }
    }
}
