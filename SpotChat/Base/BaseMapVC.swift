//
//  BaseMapVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/4/24.
//
import UIKit
import KakaoMapsSDK
import SnapKit


class BaseMapVC: UIViewController, MapControllerDelegate {
    
    private let mapView = MapView()
    
    deinit {
        print("deinit!")
        mapController?.pauseEngine()
        mapController?.resetEngine()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //KMController 생성.
        mapController = KMController(viewContainer: mapContainer)
        mapController!.delegate = self
        let ac = UIView()
        ac.backgroundColor = .red
        view.addSubview(mapContainer)
        mapContainer.addSubview(mapView)
        mapContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mapView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
        bind()
    }
    func bind() {}

    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        
        if mapController?.isEnginePrepared == false {
            mapController?.prepareEngine()
        }
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let view = mapController?.getView("mapview") as? KakaoMap {
            let cameraUpdate = CameraUpdate.make(target: MapPoint(longitude: 128.9072, latitude: 37.7918), zoomLevel: 11, rotation: 0.0, tilt: 0.0, mapView: view)
            view.moveCamera(cameraUpdate)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        print("없어지긴해!")
//        removeObservers()
//        mapController?.resetEngine()
//    }
    
    func authenticationSucceeded() {
        
        if _auth == false {
            _auth = true
        }
        
        if _appear && mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        _auth = false
        switch errorCode {
        case 400:
            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
            break;
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
            break;
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
            break;
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
            break;
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.prepareEngine()
            }
            break;
        default:
            break;
        }
    }
    
    func addViews() {
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        let defaultPosition: MapPoint = MapPoint(longitude: 128.9072, latitude: 37.7918)
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 6)
        //KakaoMap 추가.
        mapController?.addView(mapviewInfo)
    }

    func viewInit(viewName: String) {
        print("OK")
    }
    
    //(카카오)view hierarchy 상 KMViewContainer 의 child view 까지 resize가 잘 수행됐는지, containerResized delegate에서 수정된 사이즈로 kakaomap 의 크기가 잘 지정됐는지 확인해 보시기 바랍니다.
    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        print("뷰 추가 성공")
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer.bounds
        viewInit(viewName: viewName)
    }
    
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
    }
    
    func viewWillDestroyed(_ view: ViewBase) {
        
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
        _observerAdded = true
    }
     
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)

        _observerAdded = false
    }

    @objc func willResignActive(){
        mapController?.pauseEngine()
    }

    @objc func didBecomeActive(){
        mapController?.activateEngine()
    }
    
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        UIView.animate(withDuration: 0.4,
                       delay: duration - 0.4,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                                        toastLabel.alpha = 0.0
                                    },
                       completion: { (finished) in
                                        toastLabel.removeFromSuperview()
                                    })
    }
    
    
    var mapContainer: KMViewContainer = KMViewContainer()
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear: Bool = false
}

