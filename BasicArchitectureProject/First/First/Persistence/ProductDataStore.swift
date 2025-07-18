import Foundation

final class ProductDataStore {
    static let shared = ProductDataStore()
    private init() {}
    
    private var products: [Product] = []
    
    // 모든 상품 조회
    func fetchAllProducts() -> [Product] {
        return products
    }
    
    // 상품 추가
    func addProduct(_ product: Product) {
        products.append(product)
    }
    
    // 상품 수정
    func updateProduct(_ product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index] = product
    }
    
    // 상품 삭제
    func deleteProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
    }
    
    // 별점별 상품 조회
    func fetchProducts(by rating: Rating) -> [Product] {
        return products.filter { $0.rating == rating }
    }
} 