//
//  ContentView.swift
//  Shared
//
//  Created by Josh Holtz on 9/19/22.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @EnvironmentObject
    private var entitlementManager: EntitlementManager

    @EnvironmentObject
    private var purchaseManager: PurchaseManager

    var body: some View {
        VStack(spacing: 20) {
            //MARK: 購入済
            if entitlementManager.hasPro {
                Text("Thank you for purchasing pro!")
            } else {
                //MARK: 未購入-購入ボタン
                Text("Products")
                ForEach(purchaseManager.products) { product in
                    Button {
                        _ = Task<Void, Never> {
                            do {
                                try await purchaseManager.purchase(product)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("\(product.displayPrice) - \(product.displayName)")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Capsule())
                    }
                }
//MARK: 購入の復元ボタン
                Button {
                    _ = Task<Void, Never> {
                        do {
                            try await AppStore.sync()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Restore Purchases")
                }
            }
        }.task {
            _ = Task<Void, Never> {
                do {
                    try await purchaseManager.loadProducts()
                } catch {
                    print(error)
                }
            }
        }
    }
}
