import Foundation

struct Product: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var imageURL: URL?
    var description: String
    var rating: Rating
}
