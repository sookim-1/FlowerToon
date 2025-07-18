import UIKit

final class SkeletonViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SkeletonViewCell"
    private let skeletonView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        skeletonView.backgroundColor = UIColor.systemGray5
        skeletonView.layer.cornerRadius = 10
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(skeletonView)
        NSLayoutConstraint.activate([
            skeletonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            skeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            skeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            skeletonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} 