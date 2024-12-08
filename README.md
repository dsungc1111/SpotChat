










# 🛄 SpotChat 
- 같은 지역(Spot)을 방문한 여행자들이 실시간으로 소통할 수 있는 채팅 앱




<br> <br> 
    ![poster](./Moring.png) 
<br> <br> 

# 🙋‍♀️ 프로젝트 주요 기능 
- 소셜 로그인(애플, 카카오) / 이메일 로그인
- 지도기반 게시물, 스토리 화면(메인화면)
- 1:1 채팅 기능
- 게시물 작성, 댓글, 좋아요 기능

<br> <br> 

# 🧑🏻‍💻 프로젝트 개발환경
- 1인 개발(iOS)
- 개발기간 : 2024.11.07 ~ 2024.12.06
- iOS 최소 버전: iOS 16.0+   


<br> <br> 

   
# 🛠 프로젝트 기술스택
    

- UI 및 반응형 프로그래밍: UIKit, SnapKit, Compositional Layout, Diffable DataSource, PhosUI, MapKit, Kingfisher, Combine
- 아키텍쳐 및 디자인패턴: MVVM, Input - Output / Router / Repository 패턴
- 네트워크: URLSession, Swift Concurrency, Socket.IO
- 데이터 관리: Realm
- 로그인 인증: AuthenticationService, KakaoSDKAuth, KakaoSDKCommon 



<br> <br> 

# 👉  상세 기능 구현 설명

### 공통 기능 설계


- 컬렉션 뷰 데이터 소스 관리와 이미지 선택 기능을 각 객체로 분리하여 SRP를 준수하며, DIP를 적용하여 코드의 가독성, 재사용성, 유지보수성 향상
- MVVM 패턴을 적용해 View와 비즈니스 로직을 분리하여 유지보수성과 확장성을 개선하고, Combine을 활용한 데이터 바인딩으로 상태 변경에 따른 UI 자동 업데이트 구현



#### **객체간의 흐름 및 역할**

1. ViewController(VC)

- 사용자의 입력을 처리하고 출력된 결과를 바탕으로 UI에 적용하는 중개자 역할


2.  BindManager
   - VC와 다른 객체 간의 중개자 역할
   - 객체 간의 결합도를 낮추고, 데이터 흐름 관리
   - View <-> ViewModel 
   - View <-> ImagePickerService
   - View <-> DataSource

3. ViewModel
   - VC에서 발생한 사용자 액션을 받아 비즈니스 로직을 처리한 후, Output으로 전달
   - Input: 사용자의 텍스트 입력, 버튼 클릭 등의 이벤트 처리
   - Repository 및 네트워크 계층과 통신하여 데이터를 가져오거나 갱신.
   - Output: 데이터 상태 변화를 감지하고 View에 업데이트할 정보 전달


4. Repository or Network
   - 데이터의 영속성 및 네트워크 통신 담당
   - ViewModel의 요청을 받아 데이터를 조회, 저장, 삭제 등의 작업을 수행 후 ViewModel로 전달


5. ImagePickerManager
   - 이미지 선택 및 관리 전담
   - 사용자가 이미지 선택 버튼을 눌렀을 때 갤러리를 열어 이미지 선택 가능할 수 있도록 처리
   - 선택된 이미지를 bindManager로 전달(이미지의 경우에만 bindManager에서 data형식으로 변환 후, ViewModel로 이동)

6. DataSourceProvider
   - 컬렉션뷰 / 테이블뷰와의 연결 담당
   - 데이터 변화에 따라 셀 UI 업데이트

<br>



- 보안성 강화
   - xcconfig 파일을 활용해 API Key와 Kakao Native App Key 등 민감한 데이터를 안전하게 저장하고 활용
- UI / UX 관리
   - CAGradientLayer와 CAShapeLayer를 활용해 사용자 프로필 이미지에 그라데이션 효과와 커스텀 보더를 적용 시각적 효과 추가
   - UIView.animate(withDuration:)를 활용해 레이아웃 변경을 부드럽게 처리




<br>

### Map 기반 게시글

- MKMapKit을 활용하여 사용자 위치를 기반으로 특정 반경 내 게시물을 지도에 어노테이션으로 표시하고, 반경 조정 기능을 통해 사용자가 원하는 범위에 따라 게시물을 실시간으로 업데이트
- UIScrollViewDelegate를 활용하여 컬렉션뷰 셀 정렬 > 셀 밀림 현상 방지
- 컬렉션 뷰를 활용하여 사용자 스토리와 게시글을 표시하고, 클릭 시 상세 정보를 확인하거나 DM을 보낼 수 있도록 구현


<br>

### 실시간 채팅


<br>

### 소셜 로그인 연동
 - OAuth 기반의 인증을 통해 카카오 및 애플 로그인을 연동하여, 사용자에게 간편한 로그인 경험을 제공하며, 외부 인증 서버를 활용해 보안성을 강화하고 애플리케이션에서 민감한 사용자 인증 정보를 직접 처리하지 않도록 설계

<br>

<br> <br> 
# 👿 트러블슈팅 


### 문제상황 - 컬렉션뷰의 셀 정렬

- 사용자가 컬렉션 뷰를 드래그할 때 스크롤 위치가 셀의 정중앙에 정렬되지 않고 어색하게 멈추는 현상이 발생.


### 해결 
1. 셀 크기 및 간격 계산
- UICollectionViewFlowLayout에서 셀의 크기(itemSize)와 셀 간 간격(minimumLineSpacing)을 가져와, 하나의 셀 크기(셀 너비 + 간격)를 계산
2. 스크롤 방향 및 이동 거리 파악
- UIScrollViewDelegate의  `scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)` 메서드에서 targetContentOffset 값을 활용해 사용자가 스크롤한 위치를 계산
3. 페이징 계산
- 현재 스크롤 위치(contentOffset.x)와 계산된 셀 크기를 비교하여 사용자가 이동한 셀 인덱스를 산출
- 스크롤 방향에 따라 floor(왼쪽 스크롤), ceil(오른쪽 스크롤), round(멈춤)를 사용해 roundedIndex 계산 >> 빠르게 스크롤 시, ceil.floor를 통해 한쪽 방향으로 넘기고, 천천히 스크롤 시, round를 사용하여 더 가까운 셀로 이동

4. 스크롤 위치 조정
- roundedIndex를 기반으로 스크롤이 멈추는 위치를 targetContentOffset에 설정해 셀이 화면 중앙에 정렬되도록 처리
5. 현재 페이지 추적
- currentIndex 변수를 활용해 현재 페이징 상태를 추적하며, 스크롤 방향에 따라 currentIndex 값을 업데이트해 사용자가 어떤 페이지에 있는지 관리

<br>
<br>
<br>


