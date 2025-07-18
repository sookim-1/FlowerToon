import UIKit

protocol CustomTabBarDelegate: AnyObject {
    func customTabBar(_ tabBar: CustomTabBar, didSelectTab index: Int)
}

final class CustomTabBar: UIView {
    weak var delegate: CustomTabBarDelegate?
    
    private let myListButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("My List", for: .normal)
        button.tag = 0
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.tag = 1
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [myListButton, searchButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        myListButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        delegate?.customTabBar(self, didSelectTab: sender.tag)
    }
    
    func selectTab(index: Int) {
        // 선택된 탭에 따라 버튼 스타일 변경(선택 효과)
        myListButton.isSelected = (index == 0)
        searchButton.isSelected = (index == 1)
    }
} 