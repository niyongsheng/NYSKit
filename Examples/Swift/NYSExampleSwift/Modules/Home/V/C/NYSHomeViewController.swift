//
//  NYSHomeViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/26.
//

import UIKit
import SGPagingView

class NYSHomeViewController: NYSRootViewController, SGPagingTitleViewDelegate, SGPagingContentViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarBackgroundAlpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navBarBackgroundAlpha = 1
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.isHidenNaviBar = true
        searchView.delegate = self
        view.addSubview(searchView)
        view.addSubview(pagingTitleView)
        view.addSubview(pagingContentView)
    }
    
    let searchView: NYSSearchView = {
        let view = NYSSearchView(frame: CGRect(x: NAppSpace, y: NStatusBarHeight, width: NScreenWidth - 2 * NAppSpace, height: RealValueX(x: 40)))
        view.placeholderText = "搜索起始地/目的地"
        return view
    }()
    
    lazy var pagingTitleView: SGPagingTitleView = {
        let configure = SGPagingTitleViewConfigure()
        configure.indicatorType = .Default
        configure.gradientEffect = true
        configure.showBottomSeparator = false
        configure.textZoom = true
        configure.textZoomRatio = 0.2
        configure.color = .darkGray
        configure.selectedColor = NAppThemeColor
        let size = CGSizeMake(48, 6)
        let indicatorImage = UIImage(named: "changeBg")!.resized(to: size)!
        configure.indicatorColor = UIColor.init(patternImage: indicatorImage)
        configure.indicatorHeight = size.height
        configure.indicatorDynamicWidth = size.width
        configure.indicatorToBottomDistance = 10
        configure.badgeHeight = 15
        configure.badgeCornerRadius = 7.5
        configure.badgeOff = CGPoint(x: -10, y: 5)
        
        let frame = CGRect.init(x: 0, y: searchView.bottom + 10, width: UIScreen.width, height: RealValueX(x: 40))
        let titles = ["待确认", "待装货", "待卸货", "待签收", "已完成"]
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        pagingTitle.addBadge(text: "99+", index: 0)
        pagingTitle.backgroundColor = .clear
        pagingTitle.delegate = self
        return pagingTitle
    }()
    
    lazy var pagingContentView: SGPagingContentCollectionView = {
        let indexs = ["1", "2", "3", "4", "5"];
        var vcs = [NYSHomeListViewController]()
        for index in indexs {
            let vc = NYSHomeListViewController()
            vc.indexStr = index
            vcs.append(vc)
        }
        
        let y: CGFloat = pagingTitleView.frame.maxY
        let tempRect: CGRect = CGRect.init(x: 0, y: y, width: UIScreen.width, height: UIScreen.height - y - NBottomHeight)
        let pagingContent = SGPagingContentCollectionView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        return pagingContent
    }()
    
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
    func pagingContentViewDidEndDecelerating() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension NYSHomeViewController: NYSSearchViewDelegate {
    func didChangeKeyword(_ keyword: String) {
        
    }
}
