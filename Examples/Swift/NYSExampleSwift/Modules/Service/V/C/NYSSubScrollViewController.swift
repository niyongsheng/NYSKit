//
//  NYSSubScrollViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/29.
//

import UIKit
import RxSwift

class NYSSubScrollViewController: NYSRootScrollViewController, NYSWaterfallLayoutDelegate {
    
    private let bag = DisposeBag()
    private let vm = NYSServiceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        let waterfall = NYSWaterfallLayout()
        waterfall.columnCount = 2
        waterfall.columnSpacing = 0
        waterfall.rowSpacing = 0
        waterfall.delegate = self
        
        self.collectionView.collectionViewLayout = waterfall
        self.collectionView.contentInset = UIEdgeInsets(top: pro_subScrollViewContentOffsetY, left: 0, bottom: NBottomHeight, right: 0)
        let nib = UINib(nibName: String(describing: NYSServiceCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: NYSServiceCollectionViewCell.ID)
        
        self.collectionView.refreshControl = nil
        view.addSubview(self.collectionView)
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        vm.serviceRefresh.bind(to: self.collectionView.rx.refreshAction).disposed(by: bag)
        vm.serviceItems.subscribe(onNext: { [weak self] (items: [NYSService]) in
            self?.dataSourceArr = NSMutableArray(array: items)
            self?.collectionView.reloadData()
        }, onError: { (error) in
            print(error)
        }).disposed(by: bag)
    }
    
    override func footerRereshing() {
        super.footerRereshing()
        vm.mockServiceData(headerRefresh: false, parameters: "service_data.json")
    }
    
    func waterfallLayout(_ waterfallLayout: NYSWaterfallLayout, itemHeightForWidth itemWidth: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let model = self.dataSourceArr[indexPath.row] as! NYSService
        return 150 + model.desc.heightWithConstrainedWidth(width: NScreenWidth/2 - 2*NAppSpace, font: UIFont.systemFont(ofSize: 13))
    }
    
}

extension NYSSubScrollViewController {
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -150
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NYSServiceCollectionViewCell.ID, for: indexPath) as! NYSServiceCollectionViewCell
        cell.addInteraction(UIContextMenuInteraction(delegate: self))
        let model = self.dataSourceArr[indexPath.row] as! NYSService
        cell.model = model
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        
        let model = self.dataSourceArr[indexPath.row] as! NYSService
        let webVC = NYSRootWebViewController.init()
        webVC.urlStr = model.url
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
}

extension NYSSubScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 滚动转发
        subScrollViewDidScroll(scrollView)
    }
}

extension NYSSubScrollViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = self.collectionView.indexPathForItem(at: interaction.location(in: interaction.view?.superview)) else {
            return nil
        }
        let model = self.dataSourceArr[indexPath.row] as! NYSService
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            let webVC = NYSRootWebViewController.init()
            webVC.progressView.top = 0
            webVC.urlStr = model.url
            return webVC
            
        }, actionProvider: nil)
    }
    
}
