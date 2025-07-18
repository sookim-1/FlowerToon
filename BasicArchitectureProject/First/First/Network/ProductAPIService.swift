import Foundation

final class ProductAPIService {
    static let shared = ProductAPIService()
    private init() {}
    
    // Mock 상품 데이터
    private let mockProducts: [Product] = [
        Product(name: "iPhone 15 Pro", imageURL: nil, description: "Apple의 최신 스마트폰.", rating: .five),
        Product(name: "MacBook Air M3", imageURL: nil, description: "초경량 노트북.", rating: .four),
        Product(name: "iPad Pro", imageURL: nil, description: "프로를 위한 태블릿.", rating: .five),
        Product(name: "Apple Watch Ultra", imageURL: nil, description: "프리미엄 스마트워치.", rating: .four),
        Product(name: "AirPods Pro", imageURL: nil, description: "노이즈 캔슬링 이어폰.", rating: .three),
        Product(name: "Magic Keyboard", imageURL: nil, description: "iPad용 키보드.", rating: .three),
        Product(name: "HomePod mini", imageURL: nil, description: "스마트 스피커.", rating: .two),
        Product(name: "Apple TV 4K", imageURL: nil, description: "4K 스트리밍 박스.", rating: .four),
        Product(name: "Studio Display", imageURL: nil, description: "5K 모니터.", rating: .five),
        Product(name: "AirTag", imageURL: nil, description: "분실 방지 트래커.", rating: .one)
    ]
    
    // 상품 검색 (Mock, 페이지네이션)
    func searchProducts(keyword: String, page: Int, pageSize: Int, completion: @escaping ([Product]) -> Void) {
        DispatchQueue.global().async {
            let filtered = self.mockProducts.filter {
                $0.name.localizedCaseInsensitiveContains(keyword) ||
                $0.description.localizedCaseInsensitiveContains(keyword)
            }
            let start = (page - 1) * pageSize
            let end = min(start + pageSize, filtered.count)
            let pageItems = (start < end) ? Array(filtered[start..<end]) : []
            DispatchQueue.main.async {
                completion(pageItems)
            }
        }
    }
} 
