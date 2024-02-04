//
//  NYSSearchView.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/26.
//

import UIKit

protocol NYSSearchViewDelegate: AnyObject {
    func didChangeKeyword(_ keyword: String)
}

class NYSSearchView: UIView, UITextFieldDelegate {
    weak var delegate: NYSSearchViewDelegate?
    
    var placeholderText: String = "请输入搜索内容" {
        didSet {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.init(hexString: "#C7CBDB"),
                .font: UIFont.systemFont(ofSize: 14)
            ]
            let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
            searchField.attributedPlaceholder = attributedPlaceholder
        }
    }
    
    private let searchField: UITextField = {
        let field = UITextField()
        field.returnKeyType = .search
        field.leftViewMode = .always
        field.clearButtonMode = .whileEditing
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .init(hexString: "#C7CBDB")
        field.leftView = imageView
        
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _ = self.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! UIView).backgroundColor = .init(hexString: "#EEEFF5")
        })
        _ = self.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! UIView).backgroundColor = .init(hexString: "#2B2B2B")
        })
        
        addRadius(NAppRadius/2)
        addSubview(searchField)
        searchField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchField.frame = bounds
        
        // 设置边距
        let leftPadding: CGFloat = 10
        if let imageView = searchField.leftView as? UIImageView {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width + leftPadding, height: imageView.frame.height))
            imageView.frame = CGRect(x: leftPadding, y: 0, width: imageView.frame.width, height: imageView.frame.height)
            paddingView.addSubview(imageView)
            searchField.leftView = paddingView
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didChangeKeyword(searchField.text ?? "")
        return true
    }
    
}
