//
//  NYSMineViewModel.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/24.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import Foundation
import NYSKit
import RxSwift
import ExCodable

class NYSMineViewModel: NYSRootViewModel {

    let mineItems = BehaviorSubject<[NYSMineModel]>(value: [])
    let minRefresh = PublishSubject<MJRefreshAction>()
    let errorSubject = PublishSubject<NYSError>()
    
}
