//
//  LocationManager.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/15.
//

import MapKit
import CoreLocation


//位置情報に関するイベントをコントロール
class LocationManager: NSObject,ObservableObject,MKMapViewDelegate,CLLocationManagerDelegate{
    
    @Published var manager:CLLocationManager = .init()
    @Published var userLocation:CLLocationCoordinate2D = .init(latitude: 35.6895, longitude: 139.6917)
    @Published var isLocationAuthorized:Bool = false
    @Published var lastLocation: CLLocation?
    
    override init(){ //継承して上書き
        
        super.init()
        manager = CLLocationManager() //managerでインスタンス化
        manager.delegate = self //デリゲート先が同じ
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //位置精度
        manager.distanceFilter = 20.0 // 更新頻度、距離
        manager.startUpdatingLocation() //追跡をスタートさせるメソッド
    }
    
    //プライバシー変更有無確認
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    //ロケーションを更新
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last
        else { return }
        print(lastLocation)
        
        userLocation = .init(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        isLocationAuthorized = true
    }
    
    //エラー処理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    //プライバシー確認
    func checkAuthorization(){
        switch manager.authorizationStatus{
        case .notDetermined:
            print("Location is not determined")
            manager.requestWhenInUseAuthorization()
        case .denied:
            print("Location is denied")
        case .authorizedAlways,.authorizedWhenInUse:
            print("Location permission done")
            manager.requestLocation()
        default:
            break;
        }
    }
}
