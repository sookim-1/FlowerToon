import Foundation

enum Rating: Int, CaseIterable, Codable {
    case one = 1
    case two
    case three
    case four
    case five
    
    var starString: String {
        String(repeating: "⭐️", count: rawValue)
    }
} 