import UIKit

final class SearchViewController: UIViewController {
    private let searchBarView = SearchBarView()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Product>!
    private var products: [Product] = []
    private var currentPage = 1
    private var isLoading = false
    private var hasMore = true
    private var currentKeyword = ""
    private let pageSize = 10
    private var addToMyListView: AddToMyListView?
    private var selectedProduct: Product?
    private var isSkeleton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchBarView()
        setupCollectionView()
        setupDataSource()
    }
    
    private func setupSearchBarView() {
        searchBarView.delegate = self
        view.addSubview(searchBarView)
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SearchProductCell.self, forCellWithReuseIdentifier: SearchProductCell.reuseIdentifier)
        collectionView.register(SkeletonViewCell.self, forCellWithReuseIdentifier: SkeletonViewCell.reuseIdentifier)
        collectionView.delegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(140))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Product>(collectionView: collectionView) { [weak self] collectionView, indexPath, product in
            guard let self = self else { return nil }
            if self.isSkeleton {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkeletonViewCell.reuseIdentifier, for: indexPath) as! SkeletonViewCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchProductCell.reuseIdentifier, for: indexPath) as! SearchProductCell
                cell.configure(with: product)
                cell.addButtonAction = { [weak self] in
                    self?.showAddToMyList(for: product)
                }
                return cell
            }
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Product>()
        snapshot.appendSections([0])
        if isSkeleton {
            // 6개 Skeleton 표시
            // let dummy = Array(repeating: Product(name: "", imageURL: nil, description: "", rating: .three), count: 6)
            // 👇 매번 새로운 고유 인스턴스를 생성하도록 수정
            let dummy = (0..<6).map { _ in
                Product(name: "", imageURL: nil, description: "", rating: .three)
            }
            snapshot.appendItems(dummy)
        } else {
            snapshot.appendItems(products)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func search(keyword: String, page: Int) {
        guard !isLoading else { return }
        if keyword.count < 2 {
            products = []
            isSkeleton = false
            applySnapshot()
            return
        }
        isLoading = true
        isSkeleton = true
        applySnapshot()
        if page == 1 {
            products = []
            hasMore = true
        }
        ProductAPIService.shared.searchProducts(keyword: keyword, page: page, pageSize: pageSize) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.isSkeleton = false
            if result.count < self.pageSize { self.hasMore = false }
            if page == 1 {
                self.products = result
            } else {
                self.products += result
            }
            self.applySnapshot()
        }
    }
    
    private func showAddToMyList(for product: Product) {
        let addView = AddToMyListView()
        addView.delegate = self
        addView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addView)
        NSLayoutConstraint.activate([
            addView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        addToMyListView = addView
        selectedProduct = product
    }
    
    private func hideAddToMyList() {
        addToMyListView?.removeFromSuperview()
        addToMyListView = nil
        selectedProduct = nil
    }
}

extension SearchViewController: SearchBarViewDelegate {
    func searchBarView(_ searchBarView: SearchBarView, didSearch keyword: String) {
        currentKeyword = keyword
        currentPage = 1
        search(keyword: keyword, page: 1)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height * 1.5, hasMore, !isLoading {
            currentPage += 1
            search(keyword: currentKeyword, page: currentPage)
        }
    }
}

extension SearchViewController: AddToMyListViewDelegate {
    func addToMyListView(_ view: AddToMyListView, didSelect rating: Rating) {
        guard let product = selectedProduct else { return }
        let newProduct = Product(name: product.name, imageURL: product.imageURL, description: product.description, rating: rating)
        ProductDataStore.shared.addProduct(newProduct)
        hideAddToMyList()
    }
    func addToMyListViewDidCancel(_ view: AddToMyListView) {
        hideAddToMyList()
    }
}

// SearchProductCell: ProductCollectionViewCell + +버튼
final class SearchProductCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: SearchProductCell.self)

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .systemGray5
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    let addButton = UIButton(type: .system)
    var addButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 16

        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.imageView.image = nil
        self.nameLabel.text = nil
        self.addButtonAction = nil
    }

    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addButton)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),


            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    func configure(with product: Product) {
        nameLabel.text = product.name
        // 이미지 로딩(실제 앱에서는 비동기 이미지 로딩 필요)
        imageView.image = UIImage(systemName: "photo")
    }

    @objc private func addTapped() {
        addButtonAction?()
    }
} 
