//
//import Foundation
//import Alamofire
//
////@Observable
//class FoodOrderVM : ObservableObject{
//    @Published var foodSells : [FoodSell] = []
//
//    func getAllFoodSell(){
//        let baseUrl = "https://kroya-api-production.up.railway.app/api/v1/food-sell/list"
//        AF.request (baseUrl).responseData { response in
//            switch response.result{
//            case.success(let data):
//                do {
//                    let decodeResponse = try
//                    JSONDecoder().decode(FoodSellListResponse.self, from: data)
//                    self.foodSells = decodeResponse.payload
//                } catch {
//                    print("rror decoding foodsell: \(error)")
//                }
//            case.failure(let error):
//                print("Request error: \(error)")
//            }
//            
//        }
//    }
////    func getData(complecationHandler: @escaping (_ success: Bool) -> Void?) {
////        DispatchQueue.global().async {
////            while self.disconnect{
////                
////                AF.request(self.baseUrl).responseData{
////                    response in
////                    switch response.result{
////                        
////                    case.success(_):
////                        do {
////                            let res = try JSONDecoder().decode(FoodSellListResponse.self, from: response.data!)
////                            DispatchQueue.main.async {
////                                self.foodSell = res
////                            }
////                            complecationHandler(true)
////                        } catch {
////                            print("Error")
////                            complecationHandler(false)
////                        }
////                    case .failure(_):
////                        print("fail")
////                        complecationHandler(false)
////                    }
////                }
////                sleep(3)
////            }
////        }
////    }
////        func isDisconnect(){
////            disconnect = false
////        }
//}
//
//
