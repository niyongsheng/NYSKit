//
//  NYSMissionViewModel.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/11.
//

import UIKit
import NYSKit
import RxSwift

class NYSMissionViewModel: NYSRootViewModel {
    
    let errorSubject = PublishSubject<NYSError>()
    let weatherSubject = PublishSubject<NYSWeater>()
    let weatherRefresh = PublishSubject<MJRefreshAction>()
    
    /// 天气数据加载
    /// - Parameter parameters: 参数
    /// - Parameter headerRefresh: 是否头部刷新
    func fetchWeatherData(headerRefresh: Bool, parameters: [String: Any]?) {
        NYSNetRequest.jsonNoCheckNetworkRequest(
            with: .GET,
            url: Api_Weather_Url,
            parameters: parameters,
            remark: "天气数据",
            success: { [weak self] response in
                let respDict = response as? [String: Any]
                if respDict!["errcode"] as? Int == 100 {
                    let msg = respDict!["errmsg"] as! String
                    AlertManager.shared.showAlert(title: msg)
                    self?.errorSubject.onNext(NYSError(domain: msg, code: -1, userInfo: nil))
                    return
                }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: response as Any, options: [])
                    let weather = try JSONDecoder().decode(NYSWeater.self, from: jsonData)
                    self?.weatherSubject.onNext(weather)
                } catch {
                    print("Error: \(error)")
                    self?.weatherSubject.onError(error)
                }
                self?.weatherRefresh.onNext(.stopRefresh)
                
            }, failed:{ [weak self] error in
                self?.weatherRefresh.onNext(.stopRefresh)
                print("Error: \(String(describing: error))")
            })
    }
    
    /// Mock天气数据
    func mockWeatherData(headerRefresh: Bool, parameters: String) {
        NYSNetRequest.mockRequest(with: .GET,
                                  url: parameters,
                                  parameters: nil,
                                  remark: "天气数据",
                                  success: { [weak self] response in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response as Any, options: [])
                let weather = try JSONDecoder().decode(NYSWeater.self, from: jsonData)
                self?.weatherSubject.onNext(weather)
            } catch {
                print("Error: \(error)")
                self?.weatherSubject.onError(error)
            }
            self?.weatherRefresh.onNext(.stopRefresh)
            
        }, failed:{ [weak self] error in
            self?.weatherRefresh.onNext(.stopRefresh)
            print("Error: \(String(describing: error))")
        })
    }
}
