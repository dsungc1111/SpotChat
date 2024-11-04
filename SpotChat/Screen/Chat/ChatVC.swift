//
//  ChatVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.

import UIKit
import KakaoMapsSDK



final class ChatVC: BaseMapVC {
    
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.964286, latitude: 37.529744)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 6)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        createLodLabelLayer()
        
    }
    
    func createLodLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
    
        let custom = LodLabelLayerOptions(layerID: "custom", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10000, radius: _radius)
        
        let _ = manager.addLodLabelLayer(option: custom)
    }
    
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    var _radius: Float = 20.0
    
}
