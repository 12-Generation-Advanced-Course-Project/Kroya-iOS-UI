////
////  MainView.swift
////  Kroya_UI_Project
////
////  Created by Macbook on 10/22/24.
////
//
//import SwiftUI
//
//struct MainView: View {
//    @State private var currentImage = "Songvak" // The main image state controlled here
//    @State private var isBottomSheetOpen = true
//
//    var body: some View {
//        VStack{
//            ZStack {
//                // Calling FoodDetailView a
//                FoodDetailView(
//                    theMainImage: "Songvak",
//                    subImage1: "ahmok",
//                    subImage2: "brohok",
//                    subImage3: "SomlorKari",
//                    subImage4: "Songvak"
//                )
//                
//                BottomSheetView(
//                    isOpen: $isBottomSheetOpen, // Initially open
//                    maxHeight: .screenHeight * 1.4, // Half screen height
//                    minHeight: .screenHeight * 1.075 // Half screen height when collapsed
//                )
//            }
//            
//            
//            .navigationBarBackButtonHidden(true)
//            
//            .onAppear {
//                isBottomSheetOpen = false
//            }
//            .edgesIgnoringSafeArea(.all)
//        }}
//}
//
//
//
//#Preview {
//    MainView()
//}
