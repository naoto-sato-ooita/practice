//
//  LocationdetailView.swift
//  Tenna2
//
//  Created by Naoto Sato on 2024/04/15.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationDetailView: View {
    @Binding var mapSelection : MKMapItem?
    @Binding var show: Bool
    @State var lookAroundScene: MKLookAroundScene?
    @Binding var getDirections: Bool
    
    var body: some View {
        VStack{
            HStack{
                //地名、住所
                VStack(alignment: .leading) {
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                Spacer()
                Divider()
                Button{
                    show.toggle()
                    mapSelection = nil
                }label: {
                    Image(systemName: "xmark.circle .fill")
                        .resizable()
                        .frame(width: 24,height: 24)
                        .foregroundStyle(.gray , Color(.systemGray6))
                }
            }
            
            
            .padding(.top)
            
            //周辺の写真
            if let scene = lookAroundScene{
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            }
            else{
                ContentUnavailableView("No preview available",systemImage: "eye.slash")
            }
            //下部のボタン
            HStack(spacing: 24){
                Button{
                    
                } label: {
                    Text("Stop by")
                        .frame(width: 170,height: 40)
                        .foregroundColor(.white)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    
                }
                Button{
                    
                } label: {
                    Text("Go home")
                        .frame(width: 170,height: 40)
                        .foregroundColor(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                }
            }
        }
        .onAppear{
            print("DEBUG: Did call on appier")
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection){oldValue,newValue in
            print("DEBUG: Did call on change")
            fetchLookAroundPreview()
        }
        .padding(.horizontal)
    }
}

#Preview {
    LocationDetailView(mapSelection: .constant(nil), show: .constant(false),getDirections: .constant(false))
}
