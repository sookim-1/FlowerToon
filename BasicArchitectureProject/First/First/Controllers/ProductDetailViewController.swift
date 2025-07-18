import UIKit

final class ProductDetailViewController: UIViewController {
    private var product: Product
    private let nameField = UITextField()
    private let descriptionView = UITextView()
    private let ratingStack = UIStackView()
    private var selectedRating: Rating
    private let imageView = UIImageView()
    private let saveButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    
    init(product: Product) {
        self.product = product
        self.selectedRating = product.rating
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        configure(with: product)
    }
    
    private func setupLayout() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        nameField.font = .systemFont(ofSize: 18, weight: .semibold)
        nameField.borderStyle = .roundedRect
        nameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
        
        descriptionView.font = .systemFont(ofSize: 16)
        descriptionView.layer.cornerRadius = 8
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)
        
        ratingStack.axis = .horizontal
        ratingStack.spacing = 8
        ratingStack.distribution = .fillEqually
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingStack)
        for rating in Rating.allCases {
            let button = UIButton(type: .system)
            button.setTitle(rating.starString, for: .normal)
            button.tag = rating.rawValue
            button.titleLabel?.font = .systemFont(ofSize: 24)
            button.addTarget(self, action: #selector(ratingTapped(_:)), for: .touchUpInside)
            ratingStack.addArrangedSubview(button)
        }
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        deleteButton.backgroundColor = .systemRed
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.layer.cornerRadius = 8
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameField.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionView.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            descriptionView.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            descriptionView.heightAnchor.constraint(equalToConstant: 80),
            
            ratingStack.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            ratingStack.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            ratingStack.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            ratingStack.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            deleteButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            deleteButton.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configure(with product: Product) {
        nameField.text = product.name
        descriptionView.text = product.description
        selectedRating = product.rating
        imageView.image = UIImage(systemName: "photo")
        updateRatingButtons()
    }
    
    @objc private func ratingTapped(_ sender: UIButton) {
        if let rating = Rating(rawValue: sender.tag) {
            selectedRating = rating
            updateRatingButtons()
        }
    }
    
    private func updateRatingButtons() {
        for (index, view) in ratingStack.arrangedSubviews.enumerated() {
            guard let button = view as? UIButton, let rating = Rating(rawValue: index + 1) else { continue }
            button.alpha = (rating == selectedRating) ? 1.0 : 0.5
        }
    }
    
    @objc private func saveTapped() {
        guard let name = nameField.text, !name.isEmpty else { return }
        let updated = Product(name: name, imageURL: product.imageURL, description: descriptionView.text ?? "", rating: selectedRating)
        ProductDataStore.shared.updateProduct(updated)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteTapped() {
        ProductDataStore.shared.deleteProduct(product)
        navigationController?.popViewController(animated: true)
    }
} 
