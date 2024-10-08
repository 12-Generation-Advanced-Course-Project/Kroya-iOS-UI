//
//  FlowLayoutSuggest.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/10/24.
//
import SwiftUI

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let items: Data
    let itemSpacing: CGFloat
    let lineSpacing: CGFloat 
    let content: (Data.Element) -> Content

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .padding([.horizontal], itemSpacing)
                        .alignmentGuide(.leading, computeValue: { dimension in
                            if (abs(width - dimension.width) > geometry.size.width) {
                                width = 0
                                height -= dimension.height + lineSpacing
                            }
                            let result = width
                            if item == items.last! {
                                width = 0
                            } else {
                                width -= dimension.width + itemSpacing
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: { _ in height })
                }
            }
        }
        .frame(height: height)
    }
}
