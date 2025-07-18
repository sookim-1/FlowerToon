import UIKit

protocol AddToMyListViewDelegate: AnyObject {
    func addToMyListView(_ view: AddToMyListView, didSelect rating: Rating)
    func addToMyListViewDidCancel(_ view: AddToMyListView)
}

final class AddToMyListView: UIView {
    weak var delegate: AddToMyListViewDelegate?
    private var selectedRating: Rating = .three
    private let stack = UIStackView()
    private let confirmButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 8
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        for rating in Rating.allCases {
            let button = UIButton(type: .system)
            button.setTitle(rating.starString, for: .normal)
            button.tag = rating.rawValue
            button.titleLabel?.font = .systemFont(ofSize: 24)
            button.addTarget(self, action: #selector(ratingTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        confirmButton.backgroundColor = .systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        addSubview(confirmButton)
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        cancelButton.backgroundColor = .systemGray
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.layer.cornerRadius = 8
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 24),
            confirmButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
        updateRatingButtons()
    }
    
    @objc private func ratingTapped(_ sender: UIButton) {
        if let rating = Rating(rawValue: sender.tag) {
            selectedRating = rating
            updateRatingButtons()
        }
    }
    
    private func updateRatingButtons() {
        for (index, view) in stack.arrangedSubviews.enumerated() {
            guard let button = view as? UIButton, let rating = Rating(rawValue: index + 1) else { continue }
            button.alpha = (rating == selectedRating) ? 1.0 : 0.5
        }
    }
    
    @objc private func confirmTapped() {
        delegate?.addToMyListView(self, didSelect: selectedRating)
    }
    
    @objc private func cancelTapped() {
        delegate?.addToMyListViewDidCancel(self)
    }
} 
