//
//  NYSServiceViewModel.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/15.
//

import UIKit
import NYSKit
import RxSwift
import ExCodable

class NYSServiceViewModel: NYSRootViewModel {
    
    let serviceItems = BehaviorSubject<[NYSService]>(value: [])
    let serviceRefresh = PublishSubject<MJRefreshAction>()
    
    /// Mock数据
    func mockServiceData(headerRefresh: Bool, parameters: String) {
        NYSNetRequest.mockRequest(with: .GET,
                                  url: parameters,
                                  parameters: nil,
                                  remark: nil,
                                  success: { [weak self] response in
            do {
                let respDict = response as? [String: Any]
                let items = try [NYSService].decoded(from: respDict?["list"] as! [Any])
                if headerRefresh {
                    self?.serviceItems.onNext(items)
                    self?.serviceRefresh.onNext(.stopRefresh)
                    self?.serviceRefresh.onNext(.resetNomoreData)
                } else {
                    if items.count > 0 {
                        let updatedItems = try (self?.serviceItems.value())! + items
                        self?.serviceItems.onNext(updatedItems)
                        self?.serviceRefresh.onNext(.stopLoadmore)
                    } else {
                        self?.serviceRefresh.onNext(.showNomoreData)
                    }
                }
            } catch {
                self?.serviceItems.onError(error)
                AlertManager.shared.showAlert(title: "解码失败：\(error)")
            }
            
        }, failed:{ [weak self] error in
            self?.serviceRefresh.onNext(.stopRefresh)
            print("Error: \(String(describing: error))")
        })
    }
    
}
