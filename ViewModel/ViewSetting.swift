//
//  ViewSetting.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/15.
//

import MapKit

//初期位置を定義 (重複、削除)
extension CLLocationCoordinate2D{
    static var userLocation: CLLocationCoordinate2D{
        return.init(latitude: 35.6895, longitude: 139.6917)
    }
}

//表示領域を定義
extension MKCoordinateRegion{
    static var userRegion:MKCoordinateRegion{
        return .init(center: .userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000) //locationManager.userLocation?
    }
}
//検索結果をMapView.resultsに格納　（今回不要）
extension MapView {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()                 //プレイス検索の結果を格納
        request.naturalLanguageQuery = searchText             //serchTextの自然言語をクエリに渡す
        request.region = MKCoordinateRegion(center: locationManager.userLocation, //userLocationをセンターの座標を渡す
                                            latitudinalMeters: 500, longitudinalMeters: 500)
        
        do {
            let response = try await MKLocalSearch(request: request).start()     //自然言語と座標を渡して検索開始
            self.results = response.mapItems                                     //検索結果を格納
        } catch {
            print("Error searching for places: \(error)") // エラー処理
        }
    }
}

////lookAroundPreviewの実装（今回不要）
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
//locationManagerの定義（重複？）
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

////位置情報の取得許可変更時のパターン別警告 （重複,処理先を確認）
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
