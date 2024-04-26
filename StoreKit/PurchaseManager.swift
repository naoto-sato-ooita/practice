//
//  PurchaseManager.swift
//  Step10
//
//  Created by Josh Holtz on 9/19/22.
//

import Foundation
import StoreKit

//MARK: 購入とトランザクションを処理
@MainActor 
class PurchaseManager: NSObject, ObservableObject {
    
//MARK: 製品データの取得（製品IDはStoreKit Configuration Fileと一致させる）IDはサーバから取ってくるのが理想
    private let productIds = ["pro_monthly", "pro_yearly", "pro_lifetime"]

    @Published
    private(set) var products: [Product] = []
    @Published
    private(set) var purchasedProductIDs = Set<String>() //購入した製品IDを格納

    private let entitlementManager: EntitlementManager
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil

    init(entitlementManager: EntitlementManager) {
        self.entitlementManager = entitlementManager
        super.init()
        self.updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        self.updates?.cancel()
    }
    
//MARK: 製品データを取得する処理
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds) //製品データの取得
        self.productsLoaded = true
    }
    
//MARK: 購入の処理を開始
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

//MARK: 購入処理結果の検証
        switch result {
        case let .success(.verified(transaction)):
            // Successful purchase
            await transaction.finish()
            await self.updatePurchasedProducts() //購入成功で更新
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
    }
    
//MARK: アプリの起動時、購入後、トランザクション更新時に購入状況を取得
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID) //失効してたら購入済から削除する
            }
        }

        self.entitlementManager.hasPro = !self.purchasedProductIDs.isEmpty
    }
    
//MARK: 外部トランザクションの監視(アプリ外での更新や解約、購入失敗)
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
}

//MARK: App Storeアプリからのアプリ内課金の購入に対応する
extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

    }

    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
