import UIKit

protocol SearchBarViewDelegate: AnyObject {
    func searchBarView(_ searchBarView: SearchBarView, didSearch keyword: String)
}

final class SearchBarView: UIView {
    weak var delegate: SearchBarViewDelegate?
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search products..."
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        return tf
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(textField)
        addSubview(searchButton)
        textField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            searchButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            searchButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        textField.delegate = self
    }
    
    @objc private func searchTapped() {
        delegate?.searchBarView(self, didSearch: textField.text ?? "")
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarView(self, didSearch: textField.text ?? "")
        return true
    }
} 