//
//  ViewSetting.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/15.
//

import MapKit

//MARK - 初期位置を定義
extension CLLocationCoordinate2D{
    static var userLocation: CLLocationCoordinate2D{
        return.init(latitude: 35.6895,
                    longitude: 139.6917)
    }
}

//MARK - 表示領域を定義
extension MKCoordinateRegion{
    static var userRegion:MKCoordinateRegion{
        return .init(center: .userLocation, 
                     latitudinalMeters: 500, 
                     longitudinalMeters: 500)
    }
}

//MARK - 検索機能 MapView.resultsに格納
extension MapView {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()                     //検索条件を格納
        request.naturalLanguageQuery = searchText                 //searchTextの自然言語をクエリに渡す
        request.region = visibleRegion ?? MKCoordinateRegion(     //表示範囲の検索
                center: locationManager.userLocation,             //検索結果の表示範囲
                span: MKCoodinateSpan (latitudinalDelta: 0.0125,
                                       longitudinalDelta: 0.0125))
        
        do {
            let searchPlace = MKLocalSearch(request: request)     //自然言語と座標を渡して検索開始
            let response = try? await searchPlace.start()         //検索開始
            self.results = response?.mapItems ?? []               //検索結果を格納
        } catch {
            print("Error searching for places: \(error)")         // エラー処理
        }
    }
}

//MARK - locationManagerの定義
import CoreLocation

class LocationViewModel:NSObject,ObservableObject, CLLocationManagerDelegate {
    private var locationManager : CLLocationManager?
    
    init(locationManager : CLLocationManager = CLLocationManager()){
        super.init()
        self.locationManager = locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

//MARK - lookAroundPreviewの実装（不要）
extension LocationDetailView{
    func fetchLookAroundPreview(){
        if let mapSelection{
            lookAroundScene = nil
            Task{
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
}


//位置情報の取得許可変更時のパターン別警告 （重複,処理先を確認）
//extension LocationViewModel : CLLocationManagerDelegate{
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus{
//        case .notDetermined:
//            log = "Location authorization not determined"
//        case .restricted:
//            log = "Location authorization restricted"
//        case .denied:
//            log = "Location authorization denied"
//        case .authorizedAlways:
//            manager.requestLocation()
//            log = "Location authorization always granted"
//        case .authorizedWhenInUse:
//            manager.startUpdatingLocation()
//            log = "Location authorization when in use granted"
//        @unknown default:
//            log = "Unknown authorization status"
//            
//        }
//    }
//}
