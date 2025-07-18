import UIKit

final class MyListViewController: UIViewController {
    private enum Section: Int, CaseIterable {
        case one = 1, two, three, four, five
        var rating: Rating { Rating(rawValue: self.rawValue)! }
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    private var isSkeleton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupDataSource()
//        showSkeleton()
//        // 실제 앱에서는 데이터 fetch 완료 후 hideSkeleton() 호출
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            self?.hideSkeletonAndApplySnapshot()
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showSkeleton()

        // 실제 앱에서는 데이터 fetch 완료 후 hideSkeleton() 호출
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.hideSkeletonAndApplySnapshot()
        }
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(SkeletonViewCell.self, forCellWithReuseIdentifier: SkeletonViewCell.reuseIdentifier)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .estimated(180))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(400), heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 24, trailing: 8)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(36))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [header]
            return section
        }
        return layout
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { [weak self] collectionView, indexPath, product in
            guard let self = self else { return nil }
            if self.isSkeleton {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkeletonViewCell.reuseIdentifier, for: indexPath) as! SkeletonViewCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
                cell.configure(with: product)
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let section = Section.allCases[indexPath.section]
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
            header.configure(with: section.rating)
            return header
        }
    }
    
    private func showSkeleton() {
        isSkeleton = true
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        for section in Section.allCases {
            snapshot.appendSections([section])
            // let dummy = Array(repeating: Product(name: "", imageURL: nil, description: "", rating: section.rating), count: 3)
            // 👇 매번 새로운 고유 인스턴스를 생성하도록 수정
            let dummy = (0..<3).map { _ in
                Product(name: "", imageURL: nil, description: "", rating: section.rating)
            }
            snapshot.appendItems(dummy, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func hideSkeletonAndApplySnapshot() {
        isSkeleton = false
        applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        for section in Section.allCases {
            let products = ProductDataStore.shared.fetchProducts(by: section.rating)
            if products.isEmpty { continue }
            snapshot.appendSections([section])
            snapshot.appendItems(products, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
} 
