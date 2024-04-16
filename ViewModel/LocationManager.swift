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
        manager.desiredAccuracy = kCLLocationAccuracyBest //位置精度
        manager.distanceFilter = 4.0 // 更新頻度、距離
        manager.startUpdatingLocation() //追跡をスタートさせるメソッド
        //manager.activityType = .fitness //徒歩で移動
    }
    
    //プライバシー変更有無確認
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    //プライバシー確認
    func checkAuthorization(){
        switch manager.authorizationStatus{
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
                log = "Location authorization not determined"\
            
            case .restricted:
                log = "Location authorization restricted"
            
            case .denied:
                log = "Location authorization denied"
            
            case .authorizedWhenInUse:
                manager.startUpdatingLocation()
                log = "Location authorization when in use granted"
            
            case .authorizedAlways:
                manager.requestLocation() //一度だけ位置情報を更新
                log = "Location authorization always granted"
            
            default:
                log = "Unknown authorization status"
                break;
        }
    }
    
    //位置情報を取得した場合以下の、関数を呼び出し緯度経度等の情報を取得できます。
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        //.initから変更
        userLocation = CLLocationCoordinate2DMake(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        isLocationAuthorized = true
    }


    
    //エラー処理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }

}

//表示範囲の初期設定
extension MKCoordinateRegion{
    static var userRegion:MKCoordinateRegion{
        return .init(center: .userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000) 
    }
}
