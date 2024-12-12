# 🛄 SpotChat 
- 같은 지역(Spot)을 방문한 여행자들이 실시간으로 소통할 수 있는 채팅 앱

<img width="200" height="450" src="https://github.com/user-attachments/assets/2a6215b5-ca50-49a9-98ea-727647b7b6ae" />
<img width="200" height="450" src="https://github.com/user-attachments/assets/9d43811b-3911-4386-bc35-2b191fb4f96e" />
<img width="200" height="450" src="https://github.com/user-attachments/assets/7aa36a71-dde8-45f3-9325-a5c89377edf4" />
<img width="200" height="450" src="https://github.com/user-attachments/assets/4a410f39-a20d-4f16-a2f4-5845f0446e2a" />

<br> <br> 
   
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


4. Repository & Network
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
   - `UIView.animate(withDuration:)`를 활용해 레이아웃 변경을 부드럽게 처리




<br>

### Map 기반 게시글

- MKMapKit을 활용하여 사용자 위치를 기반으로 특정 반경 내 게시물을 지도에 어노테이션으로 표시하고, 반경 조정 기능을 통해 사용자가 원하는 범위에 따라 게시물을 실시간으로 업데이트
- UIScrollViewDelegate를 활용하여 컬렉션뷰 셀 정렬 > 셀 밀림 현상 방지
- 컬렉션 뷰를 활용하여 사용자 스토리와 게시글을 표시하고, 클릭 시 상세 정보를 확인하거나 DM을 보낼 수 있도록 구현


<br>

### 실시간 채팅
 
**채팅 메시지 저장 및 오프라인 지원**  
- 채팅 메시지를 Realm 데이터베이스에 저장하여 네트워크가 불안정하거나 오프라인 상태에서도 사용자가 채팅 내역을 확인할 수 있도록 지원
- 저장된 데이터는 앱 재시작 시에도 유지되며, 사용자는 언제든지 채팅 기록을 확인 가능

**최초 데이터 로드 및 페이지네이션 구현**  
- 채팅방 최초 진입 시, Realm에서 최신 데이터 20개를 로드한 뒤, 저장된 가장 최신 날짜 이후의 데이터를 서버에서 동기화하여 결합한 후 화면에 표시
- 스크롤 이벤트를 활용해 페이지네이션 방식으로 추가 데이터 로드
- 페이지네이션은 `tableView(_:willDisplay:forRowAt:)` 델리게이트를 통해 임계값 도달 시 실행, isLoading 플래그를 사용해 중복 요청을 방지

**인덱스를 활용한 성능 최적화**
-   `createdAt`필드에 인덱스를 추가하여, 특정 시간대 검색 시에는 O(logN)의 시간 복잡도를 보장하며, 가장 최근 시간을 탐색할 때는 O(1)의 시간 복잡도를 보장하여 탐색 성능 최적화


**UI 구성의 동적 처리**
- SnapKit의 Constraints와 UIStackView를 활용하여 메시지 발신자 및 메시지 종류(텍스트, 이미지)에 따라 UI를 동적으로 구현

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

<br>



<br>
<br>
<br>


