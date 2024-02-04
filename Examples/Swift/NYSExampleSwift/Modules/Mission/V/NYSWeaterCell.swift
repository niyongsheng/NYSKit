//
//  NYSWeaterCell.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/12.
//

import UIKit

class NYSWeaterCell: UITableViewCell {
    
    let iconImageView = UIImageView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(named: "fontColor")
        label.numberOfLines = 0
        return label
    }()
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = NAppThemeColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        // 添加子视图
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(locationLabel)
        
        // 使用SnapKit设置约束
        iconImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(NAppSpace)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-NAppSpace)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-NAppSpace)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-NAppSpace)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-2)
        }
        
        self.accessoryType = .disclosureIndicator
    }
    
    var model: NYSWeater! {
        didSet {
            var iconName: String = ""
            
            switch model.data?[0].wea_img ?? "" {
            case "qing":
                iconName = "clear-day"
                break
            case "yin":
                iconName = "cloudy"
                break
            case "yu":
                iconName = "rain"
                break
            case "yun":
                iconName = "fog"
                break
            case "bingbao":
                iconName = "snow"
                break
            case "wu":
                iconName = "wind"
                break
            case "shachen":
                iconName = "sleet"
                break
            case "lei":
                iconName = "partly-cloudy"
                break
            case "xue":
                iconName = "snow"
                break
            default:
                iconName = "clear-day"
            }
            iconImageView.image = UIImage(named: iconName)
            titleLabel.text = model.data?[0].wea ?? ""
            subtitleLabel.text = "温度：" + (model.data?[0].tem ?? "--") + "℃  湿度：" + (model.data?[0].humidity ?? "--")
            
            timeLabel.text = model.updateTime
            locationLabel.text = model.city
        }
    }
    
}
