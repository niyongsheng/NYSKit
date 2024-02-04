//
//  NYSMissionViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/27.
//

import UIKit
import NYSUIKit
import RxSwift
import BRPickerView
import JDStatusBarNotification

class NYSMissionViewController: NYSRootViewController {
    
    private let bag = DisposeBag()
    private let vm = NYSMissionViewModel()
    
    private var city = "北京"
    private var isMock = false
    
    lazy var imageViewBg: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: NScreenWidth, height: 140))
        imageView.image = UIImage(named: "find_bg")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var searchView: NYSSearchView = {
        let view = NYSSearchView(frame: CGRect(x: NAppSpace, y: NStatusBarHeight, width: NScreenWidth - 2 * NAppSpace, height: RealValueX(x: 40)))
        view.placeholderText = "发货方/收货方"
        view.delegate = self
        return view
    }()
    
    lazy var shippingOrigin: NYSIconLeftButton = {
        let button = NYSIconLeftButton(type: .custom)
        let width: CGFloat = 80
        let iconWidth: CGFloat = 30
        button.titleRect = CGRect(x: 0, y: 0, width: width - iconWidth, height: 50)
        button.imageRect = CGRect(x: width - iconWidth, y: 10, width: iconWidth, height: iconWidth)
        button.frame = CGRect(x: NAppSpace, y: searchView.bottom, width: width, height: 50)
        button.setImage(UIImage(named: "icon_16px_downarrow_nor"), for: .normal)
        button.setTitle("全国", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = UIColor.darkGray
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(NAppThemeColor, for: .selected)
        button.addBlock(for: .touchUpInside, block: { (sender: Any) in
            (sender as! UIButton).isSelected = true
            self.receiptOrigin.isSelected = false
            self.showAddressPicker(button: (sender as! UIButton))
        })
        return button
    }()
    
    lazy var imageViewArrow: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 80, y: searchView.bottom, width: 80, height: 50))
        imageView.image = UIImage(named: "icon_40_rightarrow")
        imageView.contentMode = .center
        return imageView
    }()
    
    lazy var receiptOrigin: NYSIconLeftButton = {
        let button = NYSIconLeftButton(type: .custom)
        let width: CGFloat = 80
        let iconWidth: CGFloat = 30
        button.titleRect = CGRect(x: 0, y: 0, width: width - iconWidth, height: 50)
        button.imageRect = CGRect(x: width - iconWidth, y: 10, width: iconWidth, height: iconWidth)
        button.frame = CGRect(x: 150, y: searchView.bottom, width: width, height: 50)
        button.setImage(UIImage(named: "icon_16px_downarrow_nor"), for: .normal)
        button.setTitle("全国", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = UIColor.darkGray
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(NAppThemeColor, for: .selected)
        button.addBlock(for: .touchUpInside, block: { (sender: Any) in
            (sender as! UIButton).isSelected = true
            self.shippingOrigin.isSelected = false
            self.showAddressPicker(button: (sender as! UIButton))
        })
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isHidenNaviBar = true;
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
        
        imageViewBg.addSubview(searchView)
        imageViewBg.addSubview(shippingOrigin)
        imageViewBg.addSubview(imageViewArrow)
        imageViewBg.addSubview(receiptOrigin)
        view.addSubview(imageViewBg)
        
        self.tableView.mj_footer = nil
        self.tableView.separatorStyle = .singleLine
        self.tableView.frame = CGRect(x: 0, y: imageViewBg.bottom, width: NScreenWidth, height: NScreenHeight - imageViewBg.bottom - NBottomHeight)
        self.view.addSubview(self.tableView)
    }
    
    
    func showAddressPicker(button: UIButton) {
        self.view.endEditing(true)
        
        let style = BRPickerStyle(themeColor: NAppThemeColor)
        style.selectRowTextColor = NAppThemeColor
        style.topCornerRadius = Int(NAppRadius)
        
        let addressPickerView = BRAddressPickerView()
        addressPickerView.pickerMode = .area
        addressPickerView.title = "请选择地区"
        addressPickerView.pickerStyle = style
        addressPickerView.isAutoSelect = false
        addressPickerView.resultBlock = { province, city, area in
            if let cityName = city?.name, cityName.count > 0  {
                self.city = String(cityName.prefix(cityName.count - 1))
                button.setTitle(area?.name, for: .normal)
                self.headerRereshing()
            }
        }
        addressPickerView.show()
    }
}

extension NYSMissionViewController: NYSSearchViewDelegate {
    func didChangeKeyword(_ keyword: String) {
        
    }
}

extension NYSMissionViewController {
    
    override func bindViewModel() {
        super.bindViewModel()
        
        vm.weatherRefresh.bind(to: self.tableView.rx.refreshAction).disposed(by: bag)
        vm.weatherSubject.subscribe(onNext: { [weak self] (item: NYSWeater) in
            self?.dataSourceArr.insert(item, at: 0)
            self?.tableView.reloadData(animationType: .rote)
        }, onError: { (error) in
            print("Error: \(error)")
        }).disposed(by: bag)
        // 网络出错时加载Mock数据，也可以尝试catchError
        vm.errorSubject.subscribe(onNext: { [weak self] (item: NYSError) in
            self?.isMock = true
        }).disposed(by: bag)
    }
    
    override func headerRereshing() {
        super.headerRereshing()
        
        if isMock {
            // pragma mark - Mock测试
            vm.mockWeatherData(headerRefresh: true, parameters: "weather_data.json")
        } else {
            let parameters = [
                "unescape": 1,
                "version": "v1",
                "appid": 43656176,
                "appsecret": "I42og6Lm",
                "city": city
            ] as [String : Any]
            vm.fetchWeatherData(headerRefresh: true, parameters: parameters)
        }
    }
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -80;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier : String = "NYSWeaterCell"
        var cell : NYSWeaterCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? NYSWeaterCell
        
        if cell == nil {
            cell = NYSWeaterCell(style: .default, reuseIdentifier: "EventCellIdentifier")
        }
        cell?.model = self.dataSourceArr[indexPath.row] as? NYSWeater
        return cell!;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.dataSourceArr[indexPath.row] as! NYSWeater
        let vc:NYSContentViewController = NYSContentViewController()
        vc.titleL.text = model.city
        do {
            let data = try JSONEncoder().encode(model)
            let jsonString = String(data: data, encoding: .utf8)
            vc.contentL.text = jsonString
        } catch {
            print("Error encoding the model to JSON: \(error)")
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let model = self.dataSourceArr[indexPath.row] as! NYSWeater
        
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { [weak self] (action, view, completion) in
            // 删除            
            self?.dataSourceArr.removeObject(at: indexPath.row)
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            self?.tableView.endUpdates()
            
            completion(true)
        }
        deleteAction.backgroundColor = UIColor(hexString: "#FF5552")
        
        let archiveAction = UIContextualAction(style: .normal, title: "归档") { (action, view, completion) in
            // 归档
            AlertManager.shared.showAlert(title: "归档操作")
            
            completion(true)
        }
        archiveAction.backgroundColor = UIColor(hexString: "#00C042")
        
        let promptAction = UIContextualAction(style: .normal, title: "提示") { (action, view, completion) in
            // 提示
            let image = UIImageView(image: UIImage(systemName: "person.icloud.fill"))
            NotificationPresenter.shared.present("出行建议", subtitle: model.data?[0].air_tips ?? "")
            NotificationPresenter.shared.displayLeftView(image)
            NotificationPresenter.shared.dismiss(animated: true, after: 1.5) { presenter in
                
            }
            
            completion(true)
        }
        promptAction.backgroundColor = UIColor(hexString: "#FFB33B")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, archiveAction, promptAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
}
