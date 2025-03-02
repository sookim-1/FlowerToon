//
//  CustomTabBar.swift
//  GeekReport
//
//  Created by sookim on 4/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

final class CustomTabBar: UIView, UIConfigurable {

    var itemTapped: Observable<Int> { itemTappedSubject.asObservable() }

    private lazy var customItemViews: [CustomItemView] = [homeItem, searchItem, addItem, rankingItem, myPageItem]

    private lazy var tapMenuStackView = UIStackView(arrangedSubviews: customItemViews).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .lastBaseline
    }

    private let homeItem = CustomItemView(with: .home, index: 0)
    private let searchItem = CustomItemView(with: .search, index: 1)
    private let addItem = CustomItemView(with: .add, index: 2)
    private let rankingItem = CustomItemView(with: .ranking, index: 3)
    private let myPageItem = CustomItemView(with: .mypage, index: 4)

    private let dividerView = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }

    private let itemTappedSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)

        setupHierarchy()
        setupProperties()
        setupLayout()
        bind()

        setNeedsLayout()
        layoutIfNeeded()
        selectItem(index: 0)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHierarchy() {
        self.addSubviews(dividerView, tapMenuStackView)
    }

    func setupLayout() {
        dividerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.leading.trailing.equalToSuperview()
        }

        tapMenuStackView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func setupProperties() {
    }

    private func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = ($0.index == index) }
        itemTappedSubject.onNext(index)
    }

    private func bind() {
        homeItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self 
                else { return }
                
                self.homeItem.animateClick {
                    self.selectItem(index: self.homeItem.index)
                }
            }
            .disposed(by: disposeBag)

        searchItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self 
                else { return }
                
                self.searchItem.animateClick {
                    self.selectItem(index: self.searchItem.index)
                }
            }
            .disposed(by: disposeBag)

        addItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self
                else { return }

                self.addItem.animateClick {
                    self.selectItem(index: self.addItem.index)
                }
            }
            .disposed(by: disposeBag)
        
        rankingItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self 
                else { return }
                
                self.rankingItem.animateClick {
                    self.selectItem(index: self.rankingItem.index)
                }
            }
            .disposed(by: disposeBag)

        myPageItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self
                else { return }
                
                self.myPageItem.animateClick {
                    self.selectItem(index: self.myPageItem.index)
                }
            }
            .disposed(by: disposeBag)
    }

    func tabBarHidden(hidden: Bool) {
        self.dividerView.snp.updateConstraints {
            $0.height.equalTo(hidden ? 0 : 0.5)
        }

        self.tapMenuStackView.snp.updateConstraints {
            $0.top.equalTo(self.dividerView.snp.bottom).offset(hidden ? 0 : 5)
        }
    }

}
