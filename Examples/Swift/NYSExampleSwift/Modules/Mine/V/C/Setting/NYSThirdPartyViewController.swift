//
//  NYSThirdPartyViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/6.
//

import UIKit
import AcknowList

class NYSThirdPartyViewController: NYSRootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        self.navigationItem.title = AcknowLocalization.localizedTitle()
        
        self.view.addSubview(self.tableView)
        self.tableView.refreshControl = nil
        self.tableView.mj_footer = nil
        
        let list = AcknowParser.defaultAcknowList()?.acknowledgements ?? []
        self.dataSourceArr.addObjects(from: list)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.tableView.reloadData(animationType: .moveSpring)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let acknowledgement = self.dataSourceArr[indexPath.row] as! Acknow
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = acknowledgement.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = NYSThirdPartyDetailViewController(acknowledgement: self.dataSourceArr[indexPath.row] as! Acknow)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
