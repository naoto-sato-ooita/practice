//
//  ViewSetting.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/15.
//

import MapKit

//MARK: - 初期位置を定義
extension CLLocationCoordinate2D{
    static var userLocation: CLLocationCoordinate2D{
        return.init(latitude: 35.6895,
                    longitude: 139.6917)
    }
}

//MARK: - 表示領域を定義
extension MKCoordinateRegion{
    static var userRegion:MKCoordinateRegion{
        return .init(center: .userLocation,
                     latitudinalMeters: 50,
                     longitudinalMeters: 50)
    }
}

//MARK: - 検索機能 MapView.resultsに格納
extension MapView {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()                     //検索条件を格納
        request.naturalLanguageQuery = searchText                 //searchTextの自然言語をクエリに渡す
        request.region = MKCoordinateRegion(     //表示範囲の検索
            center: locationManager.userLocation,             //検索結果の表示範囲
            span: MKCoordinateSpan (latitudeDelta: 0.0125,
                                    longitudeDelta: 0.0125))
        
        do {
            let searchPlace = MKLocalSearch(request: request)     //自然言語と座標を渡して検索開始
            let response = try? await searchPlace.start()         //検索開始
            self.results = response?.mapItems ?? []               //検索結果を格納
        }
    }
}

//MARK: - lookAroundPreview
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

//MARK: - CustomAnnotationクラスを定義
class CustomAnnotation : NSObject, MKAnnotation, Identifiable {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var id = UUID() // Identifiableに必要なプロパティ
    
    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
}
