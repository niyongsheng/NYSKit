//
//  NYSHomeViewModel.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/8.
//

import Foundation
import RxSwift

class NYSHomeViewModel: NYSRootViewModel {

    let homeItems = BehaviorSubject<[NYSHomeList]>(value: [])
    let homeModels = BehaviorSubject<[NYSHomeListModel]>(value: [])
    let homeRefresh = PublishSubject<MJRefreshAction>()
    
    /// RxSwift+Codable方式数据加载
    /// - Parameter parameters: 参数
    /// - Parameter headerRefresh: 是否头部刷新
    func fetchHomeDataItemes(headerRefresh: Bool, parameters: [String: Any]?) {
        let randomDataArray = generateRandomDataArray(length: NAppPageSize)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: randomDataArray, options: [])
            let items = try JSONDecoder().decode([NYSHomeList].self, from: jsonData)
            if headerRefresh {
                homeItems.onNext(items)
                homeRefresh.onNext(.stopRefresh)
                homeRefresh.onNext(.resetNomoreData)
            } else {
                if items.count > 0 {
                    let updatedItems = try homeItems.value() + items
                    homeItems.onNext(updatedItems)
                    homeRefresh.onNext(.stopLoadmore)
                } else {
                    homeRefresh.onNext(.showNomoreData)
                }
            }
        } catch {
            homeItems.onError(error)
            AlertManager.shared.showAlert(title: "解码失败：\(error)")
        }
    }
    
    /// RxSwift+YYModel方式数据加载
    /// - Parameter parameters: 参数
    /// - Parameter headerRefresh: 是否头部刷新
    func fetchHomeDataModels(headerRefresh: Bool, parameters: [String: Any]?) {
        let randomDataArray = generateRandomDataArray(length: NAppPageSize)
        do {
            let models = NSArray.yy_modelArray(with: NYSHomeListModel.self, json: randomDataArray) as! [NYSHomeListModel]
            if headerRefresh {
                homeModels.onNext(models)
                homeRefresh.onNext(.stopRefresh)
                homeRefresh.onNext(.resetNomoreData)
            } else {
                if models.count > 0 {
                    let updatedItems = try homeModels.value() + models
                    homeModels.onNext(updatedItems)
                    homeRefresh.onNext(.stopLoadmore)
                } else {
                    homeRefresh.onNext(.showNomoreData)
                }
            }
        } catch {
            homeItems.onError(error)
            AlertManager.shared.showAlert(title: "解码失败：\(error)")
        }
    }
    
    /// 闭包方式数据加载
    /// - Parameters:
    ///   - parameters: 参数
    ///   - success: 回调
    /// - Returns: 返回
    func fetchHomeDataItemes(parameters: [String: Any]?, success : @escaping (_ data : [NYSHomeList]) -> ()) -> Void {
        let randomDataArray = generateRandomDataArray(length: NAppPageSize)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: randomDataArray, options: [])
            let items = try JSONDecoder().decode([NYSHomeList].self, from: jsonData)
            success(items)
        } catch {
            print("解码失败：\(error)")
        }
    }
    
}

extension NYSHomeViewModel {
    
    /// 随机生成测试数据
    /// - Parameter length: 数据长度
    /// - Returns: 测试数据
    private func generateRandomDataArray(length: Int) -> [ [String: String] ] {
        var dataArray = [[String: String]]()
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        let letters = "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..."
        for _ in 0..<length {
            let randomDataEntry = [
                "name": String.randomString(length: 5),
                "type": String.randomString(length: 10),
                "date": formattedDate,
                "title": String.randomString(letters: "🍔🍤🍖🍟🌭🍕", length: 15),
                "content": String.randomString(letters: letters, length: Int.random(in: 1...1024))
            ]
            dataArray.append(randomDataEntry)
        }
        return dataArray
    }
}
