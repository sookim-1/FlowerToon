iOS 앱 프로젝트 아키텍처 패턴에 대해서 공부 중입니다.

목표 : 단계별 아키텍처 패턴 진화하면서 아키텍처 패턴들의 특징을 하나의 프로젝트로 파악 가능
- Cocoa MVC (UIKit)
- A Better MVC (UIKit)
- MVVM (UIKit)
- RIBS (UIKit)
- ReactorKit (UIKit)
- MV (SwiftUI)
- TCA (SwiftUI)


#### 전제조건 
반응형 프로그래밍은 Combine 프레임워크
네트워킹 URLSession 등 무조건 1st-party 사용을 권장


#### 프로젝트 설명
특정 상품을 저장하고 관리하는 앱, TODO 앱과 유사한 방식으로 할일이라는 개념이 상품으로 된 것

기술스택
- 데이터 CRUD는 SwiftData를 활용
- API는 REST API 활용

> 홈
- 하단 탭바로 이루어진 화면 구성 - CustomTabBar 사용 탭바컨트롤러 사용하지 않습니다.
- 탭바 목록은 My List, Search 2개의 목록

> MyList 
- 첫 로드시 SwiftData에 저장된 데이터 조회
- UICollectionView를 사용하여 저장된 상품 목록을 리스트로 표시합니다. Section은 여러가지로 저장할 때 지정한 Rating에 따라 5개가 있습니다. ⭐️, ⭐️⭐️, ⭐️⭐️⭐️, ⭐️⭐️⭐️⭐️, ⭐️⭐️⭐️⭐️⭐️ 즉 5개의 Section 그리고 Section별로 저장된 상품 목록을 가로로 넷플릭스 스타일처럼 스크롤이 가능합니다.
- UICollectionView는 DiffableDataSource를 사용하고, UICollectionViewCell은 이미지와 상품명등을 나열합니다.
- 상품을 선택하면 ProductDetail 상세화면으로 이동하고 Rating을 변경하거나 제목, 설명등 내용을 변경할 수 있습니다. -> SwiftData 데이터 수정 및 삭제


> Search
- 해당 화면 상단 검색바 활용 - 확장성을 위해 SearchBar 사용하지 않고 커스텀
- 검색 시작시 keyword 통해서 REST API 목록 요청
- UICollectionView를 사용하여 저장된 상품 목록을 리스트로 표시합니다. TableView와 유사하게 리스트로 표시하고 스크롤시 페이지네이션
- UICollectionView는 DiffableDataSource를 사용하고, UICollectionViewCell은 이미지와 상품명등을 나열합니다. 그리고 + 버튼으로 MyList에 추가할 수 있습니다. 이 때 Rating을 지정하여 확인을 누릅니다. SwiftData로 데이터 저장
