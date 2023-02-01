//
//  LXBlueToothExtend.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/17.
//

import Foundation
extension LXBlueToothVC{
    ///构建列表
    func setUpTableView() -> Void {
        tableV_main.delegate = self
        tableV_main.dataSource = self
        tableV_main.backgroundColor = UIColor.white
        tableV_main.register(cell: UITableViewCell.self)
        tableV_main.register(nibCell: TCellBlueToothItem.self)
        tableV_main.showsVerticalScrollIndicator = false
        tableV_main.showsHorizontalScrollIndicator = false
        tableV_main.separatorStyle = .none
        tableV_main.alwaysBounceVertical = true
        tableV_main.bounces = false
        tableV_main.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableV_main.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
}

extension LXBlueToothVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPeripherals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TCellBlueToothItem = tableView.dequeueReusable(cell: TCellBlueToothItem.self, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        let peripheral = arrayPeripherals[indexPath.row]
//        cell.textLabel?.text = String(format: "%@-%@", peripheral.name ?? "",peripheral.identifier.uuidString)
        cell.label_title.text = peripheral.name ?? ""
        cell.label_subTitle.text = peripheral.identifier.uuidString
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = arrayPeripherals[indexPath.row]
        self.bluetooth_connect(with: peripheral)
    }
}
