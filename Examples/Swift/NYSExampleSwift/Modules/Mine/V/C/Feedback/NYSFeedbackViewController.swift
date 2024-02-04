//
//  NYSFeedbackViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/24.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import UIKit
import FlexLib
import NYSKit
import NYSUIKit
import ZLPhotoBrowser

let maxSelectCount = 9
let col: CGFloat = 3
let margin: CGFloat = 5.0
let w: CGFloat = (NScreenWidth - 30 - col * 2 * margin) / col

@objc(NYSFeedbackViewController)
class NYSFeedbackViewController: NYSRootViewController {
    
    private var contentView: FlexFrameView!
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: NScreenWidth, height: NScreenHeight))
        return scrollView
    }()
    
    @objc var typeItem0: FlexTouchView!
    @objc var typeItem1: FlexTouchView!
    @objc var typeItem2: FlexTouchView!
    @objc var typeItem3: FlexTouchView!
    @objc var typeItem4: FlexTouchView!
    @objc var typeL0: UILabel!
    @objc var typeL1: UILabel!
    @objc var typeL2: UILabel!
    @objc var typeL3: UILabel!
    @objc var typeL4: UILabel!
    @objc var imgParentContainer: FlexContainerView!
    @objc var addTouchV: FlexTouchView!
    @objc var commitTouchV: FlexTouchView!
    
    private lazy var typeItems: [FlexTouchView] = {
        return [typeItem0, typeItem1, typeItem2, typeItem3, typeItem4]
    }()
    private lazy var typeLabels: [UILabel] = {
        return [typeL0, typeL1, typeL2, typeL3, typeL4]
    }()
    
    @objc var contentTV: UITextView!
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.darkGray.withAlphaComponent(0.4)
        label.text = "请输入反馈内容"
        label.font = self.contentTV.font
        label.sizeToFit()
        return label
    }()

    var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeItem0Onpress()
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.navigationItem.title = "反馈"
        
        self.view.addSubview(scrollView)
        contentView = FlexFrameView.init(flex: "NYSFeedbackView", frame: CGRect(x: 0, y: 0, width: NScreenWidth, height: 0), owner: self)!
        contentView.flexibleHeight = true
        scrollView.addSubview(contentView)

        // 更新添加按钮尺寸
        addTouchV.enableFlexLayout(true)
        addTouchV.setLayoutAttrStrings([
            "width","\(w)",
            "height","\(w)",
            "margin","\(margin)",
        ])
        
        // TextView添加占位符
        contentTV.addSubview(placeHolderLabel)
        contentTV.setValue(placeHolderLabel, forKey: "_placeholderLabel")

        updateUI()
    }
    
    func updateUI () {
        addTouchV.isHidden = images.count == maxSelectCount

        imgParentContainer.markDirty()
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSizeMake(0, contentView.height)
    }
    
}

extension NYSFeedbackViewController {
    
    func updateTypeItems () {
        for typeItem in typeItems {
            typeItem.backgroundColor = .white
        }
        for typeLable in typeLabels {
            typeLable.textColor = UIColor.init(hexString: "#A0A0A0")
        }
    }
    
    @objc func typeItem0Onpress() {
        updateTypeItems()
        typeItem0.backgroundColor = NAppThemeColor
        typeL0.textColor = .white
    }
    
    @objc func typeItem1Onpress() {
        updateTypeItems()
        typeItem1.backgroundColor = NAppThemeColor
        typeL1.textColor = .white
    }
    
    @objc func typeItem2Onpress() {
        updateTypeItems()
        typeItem2.backgroundColor = NAppThemeColor
        typeL2.textColor = .white
    }
    
    @objc func typeItem3Onpress() {
        updateTypeItems()
        typeItem3.backgroundColor = NAppThemeColor
        typeL3.textColor = .white
    }
    
    @objc func typeItem4Onpress() {
        updateTypeItems()
        typeItem4.backgroundColor = NAppThemeColor
        typeL4.textColor = .white
    }
    
    /// 选择图片
    @objc func addImageTouchVOnpress() {
        let config = ZLPhotoConfiguration.default()
        config.allowSelectImage = true
        config.allowSelectVideo = false
        config.allowSelectGif = false
        config.allowSelectLivePhoto = false
        config.allowSelectOriginal = false
        config.cropVideoAfterSelectThumbnail = true
        config.allowEditVideo = true
        config.allowMixSelect = false
        config.maxSelectCount = maxSelectCount - images.count
        config.maxEditVideoTime = 15

        let photoPicker = ZLPhotoPreviewSheet()
        photoPicker.selectImageBlock = { [weak self] (results, _) in
            let images = results.map { $0.image }
            self?.images.append(contentsOf: images)
            self?.layoutSelecteImages(images: images)
        }
        photoPicker.showPhotoLibrary(sender: self)
    }
    
    /// 预览图片
    @objc func previewImage(sender : UIGestureRecognizer) -> Void {
        let itemV: NYSImageItemView = sender.view as! NYSImageItemView
        let image = itemV.selectedIV.image
        let index = self.images.firstIndex(of: image!)!
        
        let previewVC = ZLImagePreviewController(datas: self.images, index: index, showSelectBtn: false)
        previewVC.modalPresentationStyle = .fullScreen
        showDetailViewController(previewVC, sender: nil)
    }
    
    /// 布局图片
    func layoutSelecteImages(images: [UIImage]) {
        for image in images {
            let itemV = NYSImageItemView()
            itemV.selectedIV.image = image
            itemV.enableFlexLayout(true)
            itemV.setLayoutAttrStrings([
                "width","\(w)",
                "height","\(w)",
                "margin","\(margin)",
                "alignItems","center",
                "justifyContent","center",
            ])
            self.imgParentContainer.insertSubview(itemV, at: imgParentContainer.subviews.count - 1)
            self.updateUI()
            
            let previewTap = UITapGestureRecognizer.init(target: self, action: #selector(self.previewImage(sender:)))
            itemV.addGestureRecognizer(previewTap)
            
            itemV.delBlock = { [weak self] in
                self?.images.remove(at: (self?.images.firstIndex(of: image)!)!)
                itemV.removeFromSuperview()
                self?.updateUI()
            }
        }
    }
    
    @objc func commitTouchVOnpress() {
        if contentTV.text.isEmpty {
            NYSTools.shakeAnimation(commitTouchV.layer)
            NYSTools.showToast("请输入反馈内容")
            return
        }
        
        if images.count == 0 {
            NYSTools.shakeAnimation(commitTouchV.layer)
            NYSTools.showToast("请选择图片")
            return
        }
        
        NYSTools.zoom(toShow: commitTouchV.layer)
        
    }
    
}

