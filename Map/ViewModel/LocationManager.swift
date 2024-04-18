//
//  LocationManager.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/15.
//

import MapKit
import CoreLocation

//MARK: - 位置情報に関するイベントをコントロール
class LocationManager: NSObject,ObservableObject,MKMapViewDelegate,CLLocationManagerDelegate{
    
    @Published var manager:CLLocationManager = .init()
    @Published var userLocation:CLLocationCoordinate2D = .init(latitude: 35.6895, longitude: 139.6917)
    @Published var isLocationAuthorized:Bool = false
    @Published var lastLocation: CLLocation?
    
    override init(){
        
        super.init()
        manager = CLLocationManager()                           // managerでインスタンス化
        manager.delegate = self                                 // デリゲート先が同じ
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest       // 位置精度
        manager.distanceFilter = 4.0                            // 更新頻度、距離
        manager.startUpdatingLocation()                         // 追跡をスタートさせるメソッド
        manager.pausesLocationUpdatesAutomatically = false      // 自動OFFしない
        manager.activityType = .fitness                         // 徒歩で移動
    }
    
    
    //MARK: - 位置情報を取得した場合以下の、関数を呼び出し緯度経度等の情報を取得できます。
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        //.initから変更
        userLocation = CLLocationCoordinate2DMake(lastLocation.coordinate.latitude,
                                                  lastLocation.coordinate.longitude)
        isLocationAuthorized = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    
    //MARK: - プライバシー変更有無確認
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        func checkAuthorization(){
            switch manager.authorizationStatus{
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .restricted:
                break;
            case .denied:
                break;
            case .authorizedWhenInUse:
                manager.startUpdatingLocation()
            case .authorizedAlways:
                manager.requestLocation() //一度だけ位置情報を更新
            default:
                break;
            }
        }
    }
}


