//
//  NYSInstructionViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/5.
//

import UIKit

private let IMAGE_HEIGHT:CGFloat = 280
private let NAVBAR_COLORCHANGE_POINT:CGFloat = IMAGE_HEIGHT - CGFloat(NTopHeight)

class NYSInstructionViewController: NYSRootViewController {
    
    lazy var bgImgView:UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "bottomImage"))
        imgView.frame.size = CGSize(width: NScreenWidth, height: NScreenHeight)
        return imgView
    }()
    
    lazy var titleL:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Nico"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    lazy var iconIV:UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "pic_32px_def_touxiang"))
        imgView.frame.size = CGSize(width: 90, height: 90)
        imgView.addCornerRadius(45, borderWidth: 2, borderColor: .white)
        return imgView
    }()
    
    lazy var topView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: CGFloat(NTopHeight), width: NScreenWidth, height: IMAGE_HEIGHT))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "使用说明"
    }
    
    override func configTheme() {
//        super.configTheme()
        
        navBarBackgroundAlpha = 0
        navBarTintColor = .white
        navBarTitleColor = .white
    }
    
    override func setupUI() {
        super.setupUI()

        view.addSubview(bgImgView)
        tableView.backgroundColor = UIColor.clear
        view.addSubview(tableView)
        topView.addSubview(iconIV)
        iconIV.center = CGPoint(x: topView.center.x, y: topView.center.y - 100)
        topView.addSubview(titleL)
        titleL.frame = CGRect(x: 0, y: iconIV.frame.size.height+iconIV.frame.origin.y+10, width: NScreenWidth, height: 25)
        tableView.tableHeaderView = topView

        dataSourceArr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        let str = String(format: "使用说明 %zd", indexPath.row)
        cell.textLabel?.text = str
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cell.textLabel?.textColor = UIColor.white
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc:NYSRootViewController = NYSRootViewController()
        vc.title = "InstructionViewController"
        navigationController?.pushViewController(vc, animated: true)
    }

}
