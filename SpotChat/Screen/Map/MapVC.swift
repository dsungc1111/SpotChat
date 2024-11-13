//
//  MapVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import Combine
import CoreLocation
import MapKit


struct ImageItem: Hashable {
    let id = UUID()
    let image: UIImage
}

final class MapVC: BaseVC {
    
    private let mapView = MapView()
    private var cancellables = Set<AnyCancellable>()
    private let temp = CLLocationCoordinate2D(latitude: 37.79181196691732, longitude: 128.9071798324585)
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapView()
        setAnnotation()
        mapView.map.delegate = self
        addTemporaryUserLocation()
    }
    
    override func bind() {
        mapView.myPinBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                let region = MKCoordinateRegion(center: temp, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.map.setRegion(region, animated: true)
            }
            .store(in: &cancellables)
    }
    
    func setMapView() {
        // 지도의 중심 좌표와 줌 레벨 설정
        let center = CLLocationCoordinate2D(latitude: 37.7950773, longitude: 128.8966344)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.map.setRegion(region, animated: true)
    }
    
    func setAnnotation() {
        
        Task {
            let geolocationQuery = GeolocationQuery(longitude: "128.90782356262207", latitude: "37.805477856609954", maxDistance: "2000")
            
            do {
                let result = try await NetworkManager2.shared.performRequest(router: .geolocationBasedSearch(query: geolocationQuery), responseType: GeolocationBasedDataModel.self)
                print(result, "🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶")
                for i in 0..<result.data.count {  // `locations`는 GeolocationBasedDataModel 내의 위치 배열이라고 가정합니다.
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: result.data[i].geolocation.latitude, longitude: result.data[i].geolocation.longitude)
                    //                    annotation.title = result.data[i].content.
                    annotation.subtitle = result.data[i].content1  // `description`은 위치에 대한 설명
                    
                    mapView.map.addAnnotation(annotation)
                }
            } catch {
                print("Error fetching geolocation data: \(error)")
            }
        }
        
    }
    func addTemporaryUserLocation() {
            let tempAnnotation = MKPointAnnotation()
            tempAnnotation.coordinate = temp
            tempAnnotation.title = "내 위치"
            mapView.map.addAnnotation(tempAnnotation)
        }
}


extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let identifier = "CustomAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor =  AppColorSet.keyColor
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
}
