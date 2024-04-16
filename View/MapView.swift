//
//  MapView.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/15.
//

import SwiftUI
import MapKit
import CoreLocation
import UIKit

struct MapView: View {
    @State private var mapRegion: MKCoordinateRegion = .userRegion //表示範囲の更新
    @ObservedObject var locationViewModel = LocationViewModel() //Locationの更新用
    @StateObject var locationManager = LocationManager() //ロケーションマネジャーの設定更新
    
    @State private var showMap = true //地図が表示後かの判断フラグ
    @State var searchText = "" //検索窓の初期値
    @State var results = [MKMapItem]() //検索結果
    @State private var mapSelection: MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    
    @State  var trackingMode = MapUserTrackingMode.follow //追従モード
    //@State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    var body: some View {
        
        VStack {
            

            
           Map(coordinateRegion: $mapRegion,
               showsUserLocation: true, //ユーザーを表示
               userTrackingMode: $trackingMode, //追従モード
               annotationItems: results.map { mapItem in //検索結果を表示
               CustomAnnotation(coordinate: mapItem.placemark.coordinate, title: mapItem.name ?? "")})
           { annotation in
               MapMarker(coordinate: annotation.coordinate, tint: .red) //MapPinを配置
               
           }
            
            .mapControls{
                MapUserLocationButton()
                
            }
            .ignoresSafeArea()
            
            .overlay(alignment: .top) {
                TextField("Search for a location", text: $searchText)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color.white)
                    .padding()
                    .shadow(radius: 10)
            }
            .onSubmit(of: .text) {
                Task { await searchPlaces() }
            }
            
            .onAppear {
                mapRegion = MKCoordinateRegion(center: locationManager.userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000) //表示範囲を更新
            }
            .onChange(of: locationManager.isLocationAuthorized, {oldValue , newValue in //位置取得変更有無の確認
                showMap = true
            })
            .onChange(of: mapSelection, { oldValue,newValue in
                showDetails = newValue != nil
            })
            .sheet(isPresented: $showDetails,content: {
                LocationDetailView(mapSelection: $mapSelection, show: $showDetails, getDirections: $getDirections)
                    .presentationDetents([.height(340)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
            })
            
            
            
            
        }
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}


            // Map(position: $cameraPosition , selection : $mapSelection){
            //     Annotation("",coordinate: .userLocation) {
            //         ZStack{
            //             Circle()
            //                 .frame(width: 32,height: 32)
            //                 .foregroundColor(.blue.opacity(0.25))
            //             Circle()
            //                 .frame(width: 20,height: 20)
            //                 .foregroundColor(.white)
            //             Circle()
            //                 .frame(width: 12,height: 12)
            //                 .foregroundColor(.blue)
            //         }
            //     }
            //     ForEach(results, id: \.self){ item in
            //         let placemark = item.placemark
            //         Marker(placemark.name ?? "", coordinate :placemark.coordinate)}
            // }
