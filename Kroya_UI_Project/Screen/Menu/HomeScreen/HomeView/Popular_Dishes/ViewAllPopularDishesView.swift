import SwiftUI
import Combine

struct ViewAllPopularDishesView: View {
    @State private var selectedSegment = 0
    @StateObject private var popularAllFood = PopularFoodVM()
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0
    let images = ["slide1", "slide2", "slide3"]
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
 
    var body: some View {
        VStack(spacing: 10) {
            // Image Slider
            ImageSliderView(currentPage: $currentPage, images: images, timer: timer)
                .padding(.horizontal)
                .padding(.top, 10)
            // Segmented Control
            SegmentedControlView(selectedSegment: $selectedSegment)
                .frame(height: 30)
            // Content for Each Tab
            TabView(selection: $selectedSegment) {
                AllPopularTabView(isSelected: selectedSegment, popularFood: [])
                    .tag(0)
                SaleTab(isselected: selectedSegment)
                    .tag(1)
                RecipeTab(isselected: selectedSegment)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationTitle(LocalizedStringKey("Popular Dishes"))
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
    struct ImageSliderView: View {
        @Binding var currentPage: Int
        let images: [String]
        let timer: Publishers.Autoconnect<Timer.TimerPublisher>
        
        var body: some View {
            ZStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFill()
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: 120)
                .cornerRadius(12)
                .onReceive(timer) { _ in
                    withAnimation {
                        currentPage = (currentPage + 1) % images.count
                    }
                }
                HStack(spacing: 5) {
                    ForEach(0..<images.count, id: \.self) { index in
                        if index == currentPage {
                            // Active dot (oval and yellow)
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.yellow)
                                .frame(width: 20, height: 10) // Oval shape
                        } else {
                            // Inactive dot (circular)
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
                .padding(.top,80)
            }
        }
    }
    
    
    struct SegmentedControlView: View {
        
        @Binding var selectedSegment: Int
        let tabTitles: [String] = ["All", "Sale", "Recipes"]
        @Environment(\.locale) var locale

        
        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 20) {
                    ForEach(tabTitles.indices, id: \.self) { index in
                        Text(LocalizedStringKey(tabTitles[index]))
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .foregroundColor(selectedSegment == index ? .black.opacity(0.8) : .black.opacity(0.5))
                            .onTapGesture {
                                selectedSegment = index
                            }
                    }
                }
                .padding(.leading, 15)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Divider()
                            .background(Color.gray.opacity(0.2)) // Full-width gray line
                        
                        Rectangle()
                            .fill(Color.yellow)
                            .frame(width: underlineWidth(for: selectedSegment), height: 2)
                            .offset(x: underlineOffset(for: selectedSegment, in: geometry))
                            .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                    }
                }
                .frame(height: 2)
            }
        }
        
        private func underlineWidth(for selectedSegment: Int) -> CGFloat {
            let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            let title = tabTitles[selectedSegment]
            let titleWidth = title.size(withAttributes: [NSAttributedString.Key.font: font]).width
            let padding: CGFloat = 15 // Add a bit of padding to the underline
            return locale.identifier == "ko" ? titleWidth + padding : locale.identifier == "km-KH" ? titleWidth + padding + 20 : titleWidth + padding
        }
        
        private func underlineOffset(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
            let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            var offset: CGFloat = 10 // Starting padding from the leading edge
            
            for index in 0..<selectedSegment {
                let titleWidth = tabTitles[index].size(withAttributes: [NSAttributedString.Key.font: font]).width
                // Add spacing between titles
                offset += titleWidth + (locale.identifier == "ko" ? 18 : locale.identifier == "km-KH" ? 30 : 20)
            }
            
            return offset
        }
    }
}
