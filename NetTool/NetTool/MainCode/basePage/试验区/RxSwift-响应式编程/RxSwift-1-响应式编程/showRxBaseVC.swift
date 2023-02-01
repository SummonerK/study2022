//
//  showRxBaseVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/1.
//

import UIKit
import RxSwift
import RxCocoa

//歌曲结构体
struct Music {
    let name: String //歌名
    let singer: String //演唱者
     
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}
 
//实现 CustomStringConvertible 协议，方便输出调试
extension Music: CustomStringConvertible {
    var description: String {
        return "name：\(name) singer：\(singer)"
    }
}

class showRxBaseVC: BaseVC {
    //负责对象销毁
    let disposeBag = DisposeBag()
    
    var tableV_main:UITableView!
    
    //歌曲列表数据源
    let musicListViewModel = MusicListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        
        registTableObserver()
        // Do any additional setup after loading the view.
    }
    
    func initTableView() -> Void {
        let mainView_Y:CGFloat = view.safeInsets.top + 44
        let mainView_H:CGFloat = kscreenH - mainView_Y - self.view.safeInsets.bottom
        tableV_main = UITableView.init(frame: CGRect.init(x: 0, y: mainView_Y, width: kscreenW, height:mainView_H))
        tableV_main.backgroundColor = .clear
        tableV_main.register(nibCell: TCellRxBaseListItem.self)
        view.addSubview(tableV_main)
    }
    
    func registTableObserver() -> Void {
        musicListViewModel.data
            .bind(to: tableV_main.rx.items(cellIdentifier:"TCellRxBaseListItem",cellType: TCellRxBaseListItem.self)) { _, music, cell in
                cell.selectionStyle = .none
                cell.label_title.text = music.name
                cell.label_subTitle.text = music.singer
            }.disposed(by: disposeBag)
         
        //tableView点击响应
        tableV_main.rx.modelSelected(Music.self).subscribe(onNext: { music in
            print("你选中的歌曲信息【\(music)】")
        }).disposed(by: disposeBag)
        
        tableV_main
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

}

extension showRxBaseVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//歌曲列表数据源
struct MusicListViewModel {
    let data = Observable.just([
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
    ])
}
