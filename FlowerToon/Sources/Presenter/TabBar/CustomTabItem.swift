//
//  CustomTabItem.swift
//  GeekReport
//
//  Created by sookim on 4/5/24.
//

import UIKit

enum CustomTabItem: String, CaseIterable {
    case home
    case search
    case add
    case ranking
    case mypage
}

extension CustomTabItem {

    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        case .search:
            return UIImage(systemName: "magnifyingglass.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        case .add:
            return UIImage(systemName: "magnifyingglass.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        case .ranking:
            return UIImage(systemName: "list.bullet.rectangle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        case .mypage:
            return UIImage(systemName: "person.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        }
    }

    var selectedIcon: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .search:
            return UIImage(systemName: "magnifyingglass.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .add:
            return UIImage(systemName: "magnifyingglass.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .ranking:
            return UIImage(systemName: "list.bullet.rectangle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .mypage:
            return UIImage(systemName: "person.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }

    var name: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .add:
            return "Add"
        case .ranking:
            return "Ranking"
        case .mypage:
            return "MyPage"
        }
    }

}
