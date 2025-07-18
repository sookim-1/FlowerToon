import UIKit

final class MainTabBarController: UIViewController {
    private let customTabBar = CustomTabBar()
    private let containerView = UIView()
    
    private let myListVC = MyListViewController()
    private let searchVC = SearchViewController()
    private var currentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        customTabBar.delegate = self
        selectTab(index: 0)
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        view.addSubview(customTabBar)
        
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 56),
            
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: customTabBar.topAnchor)
        ])
    }
    
    private func selectTab(index: Int) {
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
        
        let selectedVC = (index == 0) ? myListVC : searchVC
        addChild(selectedVC)
        containerView.addSubview(selectedVC.view)
        selectedVC.view.frame = containerView.bounds
        selectedVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectedVC.didMove(toParent: self)
        currentVC = selectedVC
        customTabBar.selectTab(index: index)
    }
}

extension MainTabBarController: CustomTabBarDelegate {
    func customTabBar(_ tabBar: CustomTabBar, didSelectTab index: Int) {
        selectTab(index: index)
    }
} 