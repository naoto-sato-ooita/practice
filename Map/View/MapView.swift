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

//MARK: - MapView-var
struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var mapSelection: MKMapItem?                      //選択したアノテーションがあれば返す
    @State private var mapRegion: MKCoordinateRegion = .userRegion   //表示範囲の更新 .userLocation?
    @ObservedObject var locationManager = LocationManager()          //Locationの更新
    @State private var showMap = true                                //地図が表示されたかのフラグ
    @State var searchText = ""                                       //検索窓の初期値
    @State var results = [MKMapItem]()                               //検索結果をresultsに格納
    @State private var showDetails = false
    @State private var getDirections = false
    
    
    //MARK: - MapView-View
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition,selection: $mapSelection){
                Annotation("",coordinate: .userLocation) {                 //User位置に以下の形状を表示
                    ZStack{
                        Circle()
                            .frame(width: 32,height: 32)
                            .foregroundColor(.blue.opacity(0.25))
                        Circle()
                            .frame(width: 20,height: 20)
                            .foregroundColor(.white)
                        Circle()
                            .frame(width: 12,height: 12)
                            .foregroundColor(.blue)
                    }
                }
                ForEach(results, id: \.self){ item in
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate :placemark.coordinate)}
            }
            
            //MARK: - MapView-View
            
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
                mapRegion = MKCoordinateRegion(center: locationManager.userLocation,    //表示範囲を更新
                                               latitudinalMeters: 50,
                                               longitudinalMeters: 50)
            }
            .onChange(of: locationManager.isLocationAuthorized, {oldValue , newValue in //位置取得変更有無の確認
                showMap = true
            })
            
            .onChange(of: mapSelection, { oldValue,newValue in
                showDetails = newValue != nil
            })
            
            .sheet(isPresented: $showDetails,content: {                        //LocationDetailViewをモーダル表示
                LocationDetailView(mapSelection: $mapSelection, show: $showDetails, getDirections: $getDirections)
                    .presentationDetents([.height(340)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
            })
            
        }
        .mapControls(){
            MapUserLocationButton()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
