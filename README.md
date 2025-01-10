


# 🛄 SpotChat 
- 같은 지역(Spot)을 방문한 여행자들이 실시간으로 소통할 수 있는 채팅 앱

<img width="200" height="450" src="https://github.com/user-attachments/assets/2a6215b5-ca50-49a9-98ea-727647b7b6ae" />
<img width="200" height="450" src="https://github.com/user-attachments/assets/9d43811b-3911-4386-bc35-2b191fb4f96e" />
<img width="200" height="450" src="https://github.com/user-attachments/assets/7aa36a71-dde8-45f3-9325-a5c89377edf4" />
<img width="200" height="450" src="https://github.com/user-attachments/assets/4a410f39-a20d-4f16-a2f4-5845f0446e2a" />

<br> <br> 
   
<br> <br> 

# 프로젝트 주요 기능 
- 소셜 로그인(애플, 카카오) / 이메일 로그인
- 사용자의 현재 위치를 기반으로 주변에서 작성된 게시물을 조회할 수 있는 기능 
- 특정 게시물 클릭 시 상세 정보를 확인하거나 게시글 작성자의 프로필 확인
- 게시물 작성 시 사용자가 설정한 DM 가능 여부와 동행 가능 여부를 게시물에 표시하여 사용자 간의 소통과 활동 기회 제공
- Socket.IO를 활용해 실시간 메시지 송수신이 가능한 1:1 채팅 기능 
- 게시물 작성, 댓글, 좋아요 기능
- 사용자 이름이나 게시물에 포함된 해시태그를 검색하여 원하는 콘텐츠를 빠르게 탐색할 수 있는 기능 




<br> <br> 

# 프로젝트 개발환경
- iOS 1인 + 서버 1인
- 개발기간 : 2024.11.07 ~ 2024.12.06
- iOS 최소 버전: iOS 16.0+   


<br> <br> 

   
# 프로젝트 기술스택
    


>User Interface
- UIKit, SnapKit, PhotosUI, Compositional Layout, Diffable DataSource, NiceKeyboard
>아키텍쳐 및 디자인패턴
-  MVVM, Input-Output, Router, Repository, Singleton 패턴
> 반응형 프로그래밍
- Combine
> 네트워크 및 DB
- URLSession, Swift Concurrency, Socket.IO, Kingfisher, Realm
> 지도 및 위치 기반 
-  MapKit, CoreLocation, CLLocationManager
>로그인 인증
-  Apple Sign-In, AuthenticationService, KakaoSDKAuth, KakaoSDKCommon


<br> <br> 

# 프로젝트 개요
>MVVM 아키텍쳐
- 코드의 유지보수성을 향상시키기 위해 MVVM 패턴을 활용하여 뷰와 비즈니스 로직을 분리하고, Combine 기반의 데이터 바인딩을 통해 모델 변경 시,    UI가 자동으로 업데이트되도록 구현
> Massive ViewModel 방지
- 네트워크 및 DB CRUD 작업을 처리하는 객체를 별도로 만들어 뷰 모델이 비대해지는 것을 방지
> SRP & DIP 적용
- 단일 책임 원칙(SRP)과 의존성 역전 원칙(DIP)을 적용하여 객체 간 결합도를 낮추고 유지보수성 향상
> Realm DB
- Realm Database 스키마 생성 시, 중복 저장을 최소화하기 위해 반복 저장되는 요소를 개별 객체로 생성하고, 해당 객체를 참조하는 방식으로 설계
>Swift Concurrency
- 직관적이고 안전한 비동기 코드 구현을 위해 Swift Concurrency의 async/await 활용 


<br> <br> 

# 상세 기능 구현 설명

<br>

### 소셜 로그인 연동

<img width="200" height="450" src="https://github.com/user-attachments/assets/2a6215b5-ca50-49a9-98ea-727647b7b6ae" />

- OAuth 기반의 인증을 통해 카카오 및 애플 로그인을 연동하여, 사용자에게 간편한 로그인 경험을 제공하며, 외부 인증 서버를 활용해 보안성을 강화하고 애플리케이션에서 민감한 사용자 인증 정보를 직접 처리하지 않도록 설계 

> 카카오 로그인
- 앱이 설치된 경우 카카오 앱으로 이동
- 앱이 설치되지 않은 경우 직접 로그인 화면으로 이동
- 카카오 로그인 버튼 가이드에 따라 로그인 버튼 구현


> 애플 로그인
- App Store Review Guidelines에 따라 애플 로그인 버튼 UI 구현
- 애플 로그인 완료 후, ID Token을 받아 서비스 서버로 전송하여 사용자 인증 진행
<img width="572" alt="스크린샷 2025-01-10 오후 3 49 01" src="https://github.com/user-attachments/assets/6466616b-b444-490c-a557-4839f9d5babf" />
<br>
<br>


### 실시간 채팅
 
> **채팅 메시지 저장 및 오프라인 지원**  
- 채팅 메시지를 Realm 데이터베이스에 저장하여 네트워크가 불안정하거나 오프라인 상태에서도 사용자가 채팅 내역을 확인할 수 있도록 지원
- 저장된 데이터는 앱 재시작 시에도 유지되며, 사용자는 언제든지 채팅 기록을 확인 가능
<img width="600" height="400" alt="스크린샷 2025-01-10 오후 3 41 48" src="https://github.com/user-attachments/assets/fd42008c-7512-4ec2-9700-645954669a32" />



> **최초 데이터 로드 및 페이지네이션 구현**  
- 채팅방 최초 진입 시, Realm에서 최신 데이터 20개를 로드한 뒤, 저장된 가장 최신 날짜 이후의 데이터를 서버에서 동기화하여 결합한 후 화면에 표시
- 스크롤 이벤트를 활용해 페이지네이션 방식으로 추가 데이터 로드
- 페이지네이션은 `tableView(_:willDisplay:forRowAt:)` 델리게이트를 통해 임계값 도달 시 실행, isLoading 플래그를 사용해 중복 요청을 방지

> **인덱스를 활용한 성능 최적화**
-   `createdAt`필드에 인덱스를 추가하여, 특정 시간대 검색 시에는 O(logN)의 시간 복잡도를 보장하며, 가장 최근 시간을 탐색할 때는 O(1)의 시간 복잡도를 보장하여 탐색 성능 최적화

> **UI 구성의 동적 처리**
- SnapKit의 Constraints와 UIStackView를 활용하여 메시지 발신자 및 메시지 종류(텍스트, 이미지)에 따라 UI를 동적으로 구현
> **채팅방 이미지 관리**
- 이미지 개수에 따라 UIStackView를 활용하여  다른 셀 모양으로 구현
- 이미지와 텍스트를 포함하여 서버에 전송하기 위해 multipart/form-data 형식 활용
- Kingfisher를 활용하여 이미지 캐싱 최적화
- 이미지 로드 시, 메모리 사용량을 줄이기 위해 DownsamplingImageProcessor 활용하여 이미지를 필요한 크기로 다운샘플링

<br><br>

### 지도 기반 게시물 화면

> 주요 기능
- 사용자가 지도 화면을 중심으로 주변에서 작성된 게시물과 사용자 활동을 직관적으로 확인할 수 있는 기능을 제공하고, 스토리 뷰, 게시물 뷰, 검색 화면 등 다양한 인터페이스를 통해 사용자 경험을 극대화하도록 구현
> 스토리뷰
- 24시간 내 업로드한 게시물 있을 때, 스토리 뷰에 로드
- 클릭 시, DM화면 및 유저 프로필 화면 이동 선택
> 게시물 화면
- 게시물 업로드 시 설정된 DM 가능 여부와 동행 여부를 뱃지 형태로 표시
- UIScrollViewDelegate를 활용하여 스크롤 방향에 따라 셀이 정중앙에 위치하도록 구현
> 위치 이동, 반경 조정, 검색 기능
- 사용자가 다른 지역을 탐색한 후, 현위치 이동 버튼을 통해 현재 위치로 복귀하고 주변 게시물 로드
- 유저 혹은 해시태그를 통한 검색 기능 지원
- 사용자가 500 ~ 2000m 까지의 반경을 선택하여 해당 범위 내의 게시물 로드

<br><br>

### 공통 기능 구현
>ViewController(VC)

- 사용자의 입력을 처리하고 출력된 결과를 바탕으로 UI에 적용하는 중개자 역할


> BindManager
   - VC와 다른 객체 간의 중개자 역할
   - 객체 간의 결합도를 낮추고, 데이터 흐름 관리
   - View <-> ViewModel 
   - View <-> ImagePickerService
   - View <-> DataSource

> ViewModel
  - VC에서 발생한 사용자 액션을 받아 비즈니스 로직을 처리한 후, Output으로 전달
   - Input: 사용자의 텍스트 입력, 버튼 클릭 등의 이벤트 처리
   - Repository 및 네트워크 계층과 통신하여 데이터를 가져오거나 갱신.
   - Output: 데이터 상태 변화를 감지하고 View에 업데이트할 정보 전달


> Repository & Network
  - 데이터의 영속성 및 네트워크 통신 담당
   - ViewModel의 요청을 받아 데이터를 조회, 저장, 삭제 등의 작업을 수행 후 ViewModel로 전달




> ImagePickerManager
  - 이미지 선택 및 관리 전담
   - 사용자가 이미지 선택 버튼을 눌렀을 때 갤러리를 열어 이미지 선택 가능할 수 있도록 처리
   - 선택된 이미지를 bindManager로 전달(이미지의 경우에만 bindManager에서 data형식으로 변환 후, ViewModel로 이동)

> DataSourceProvider
  - 컬렉션뷰 / 테이블뷰와의 연결 담당
   - 데이터 변화에 따라 셀 UI 업데이트

<br>



>보안성 강화
   - xcconfig 파일을 활용해 API Key와 Kakao Native App Key 등 민감한 데이터를 안전하게 저장하고 활용
>UI / UX 관리
   - CAGradientLayer와 CAShapeLayer를 활용해 사용자 프로필 이미지에 그라데이션 효과와 커스텀 보더를 적용 시각적 효과 추가
   - `UIView.animate(withDuration:)`를 활용해 레이아웃 변경을 부드럽게 처리

<br>

### Map 기반 게시글

- MKMapKit을 활용하여 사용자 위치를 기반으로 특정 반경 내 게시물을 지도에 어노테이션으로 표시하고, 반경 조정 기능을 통해 사용자가 원하는 범위에 따라 게시물을 실시간으로 업데이트
- UIScrollViewDelegate를 활용하여 컬렉션뷰 셀 정렬 > 셀 밀림 현상 방지
- 컬렉션 뷰를 활용하여 사용자 스토리와 게시글을 표시하고, 클릭 시 상세 정보를 확인하거나 DM을 보낼 수 있도록 구현






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


