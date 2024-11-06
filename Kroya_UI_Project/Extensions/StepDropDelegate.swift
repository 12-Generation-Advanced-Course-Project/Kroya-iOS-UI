//
//  StepDropDelegate.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 20/10/24.
//

import SwiftUI

struct StepDropDelegate: DropDelegate {
    let destinationItem: CookingStep
    @Binding var steps: [CookingStep]
    @Binding var draggedItem: CookingStep?

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
            if let fromIndex = steps.firstIndex(where: { $0.id == draggedItem.id }),
               let toIndex = steps.firstIndex(where: { $0.id == destinationItem.id }),
               fromIndex != toIndex {
                withAnimation {
                    // Move the item from the old index to the new index
                    steps.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
                }
            }
        }
    }
}
