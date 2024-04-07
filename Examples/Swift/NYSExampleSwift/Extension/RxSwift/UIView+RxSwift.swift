//
//  UIView+RxSwift.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

/// 供ViewModel使用
enum MJRefreshAction {
    /// 开始刷新
    case begainRefresh
    /// 停止刷新
    case stopRefresh
    /// 开始加载更多
    case begainLoadmore
    /// 停止加载更多
    case stopLoadmore
    /// 显示无更多数据
    case showNomoreData
    /// 重置无更多数据
    case resetNomoreData
}

// MARK: - UIScrollView Refresh
extension Reactive where Base: UIScrollView {
    
    /// 执行的操作类型
    var refreshAction: Binder<MJRefreshAction> {
        
        return Binder(base) { (target, action) in
            
            switch action {
            case .begainRefresh:
                if let header = target.mj_header {
                    header.beginRefreshing()
                }
                if let header = target.refreshControl {
                    header.beginRefreshing()
                }
            case .stopRefresh:
                if let header = target.mj_header {
                    header.endRefreshing()
                }
                if let header = target.refreshControl {
                    header.endRefreshing()
                }
            case .begainLoadmore:
                if let footer = target.mj_footer {
                    footer.beginRefreshing()
                }
            case .stopLoadmore:
                if let footer = target.mj_footer {
                    footer.endRefreshing()
                }
            case .showNomoreData:
                if let footer = target.mj_footer as? MJRefreshAutoNormalFooter {
                    footer.setTitle("没有更多了", for: MJRefreshState.noMoreData)
                    footer.endRefreshingWithNoMoreData()
                }
            case .resetNomoreData:
                if let footer = target.mj_footer {
                    footer.resetNoMoreData()
                }
            }
        }
    }
}


// MARK: - NYSBaseViewController Refresh
extension Reactive where Base: NYSBaseViewController {
    
    /// 执行的操作类型
    var refreshAction: Binder<MJRefreshAction> {
        
        return Binder(base) { (target, action) in
            
            switch action {
            case .begainRefresh:
                if let header = target.tableView.mj_header {
                    header.beginRefreshing()
                }
                if let header = target.tableView.refreshControl {
                    header.beginRefreshing()
                }
                if let header = target.collectionView.mj_header {
                    header.beginRefreshing()
                }
                if let header = target.collectionView.refreshControl {
                    header.beginRefreshing()
                }
                target.emptyError = NSError(code: .codeUnKnow, description: "加载中...", reason: "", suggestion: "重试", placeholderImg: "icon_loading_nys")
            case .stopRefresh:
                if let header = target.tableView.mj_header {
                    header.endRefreshing()
                }
                if let header = target.tableView.refreshControl {
                    header.endRefreshing()
                }
                if let header = target.collectionView.mj_header {
                    header.endRefreshing()
                }
                if let header = target.collectionView.refreshControl {
                    header.endRefreshing()
                }
                target.emptyError = NSError(code: .codeUnKnow, description: "没有更多了", reason: "", suggestion: "重试", placeholderImg: "icon_error_nys")
            case .begainLoadmore:
                if let footer = target.tableView.mj_footer {
                    footer.beginRefreshing()
                }
                if let footer = target.collectionView.mj_footer {
                    footer.beginRefreshing()
                }
                target.emptyError = NSError(code: .codeUnKnow, description: "加载中...", reason: "", suggestion: "重试", placeholderImg: "icon_loading_nys")
            case .stopLoadmore:
                if let footer = target.tableView.mj_footer {
                    footer.endRefreshing()
                }
                if let footer = target.collectionView.mj_footer {
                    footer.endRefreshing()
                }
                target.emptyError = NSError(code: .codeUnKnow, description: "没有更多了", reason: "", suggestion: "重试", placeholderImg: "icon_error_nys")
            case .showNomoreData:
                if let footer = target.tableView.mj_footer as? MJRefreshAutoNormalFooter {
                    footer.setTitle("没有更多了", for: MJRefreshState.noMoreData)
                    footer.endRefreshingWithNoMoreData()
                }
                if let footer = target.collectionView.mj_footer as? MJRefreshAutoNormalFooter {
                    footer.setTitle("没有更多了", for: MJRefreshState.noMoreData)
                    footer.endRefreshingWithNoMoreData()
                }
                target.emptyError = NSError(code: .codeUnKnow, description: "没有更多了", reason: "", suggestion: "重试", placeholderImg: "icon_error_nys")
            case .resetNomoreData:
                if let footer = target.tableView.mj_footer {
                    footer.resetNoMoreData()
                }
                if let footer = target.collectionView.mj_footer {
                    footer.resetNoMoreData()
                }
            }
        }
    }
}
