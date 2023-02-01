//
//  binaryTreeNoteVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/2.
//

import UIKit
import JKSwiftExtension

class binaryTreeNoteVC: UIViewController {
    @IBOutlet weak var bton_next:UIButton!
    ///扩展跳转
    @IBOutlet weak var bton_nextExtend:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //功能集合
        bton_next.jk.addActionClosure {[weak self] atap, aview, aint in
            guard let self = self else{return}
            self.showRegistFuncs()
        }
        
        //二叉树扩展知识
        bton_nextExtend.jk.addActionClosure {[weak self] atap, aview, aint in
            guard let self = self else{return}
            self.showRegistExtendFuncs()
        }
    }
    
    
}

extension binaryTreeNoteVC{
    // MARK: - 二叉树功能定义
    func showRegistFuncs() -> Void {
        let message = "基础二叉树"
        let alertC = UIAlertController.init(title: "二叉树功能定义", message: message,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("创建节点", .default) {
            self.funcTestNoteTreeNote()
        }
        alertC.addAction("创建二叉树", .default) {
            self.funcTestNoteTreeCreate()
        }
        alertC.addAction("二叉树-先序遍历", .default) {
            self.funcTestNoteTreeOrderXianxu()
        }
        alertC.addAction("二叉树-中序遍历", .default) {
            self.funcTestNoteTreeOrderZhongxu()
        }
        alertC.addAction("二叉树-后序遍历", .default) {
            self.funcTestNoteTreeOrderHouxu()
        }
    }
    
    // MARK: - func-创建节点
    func funcTestNoteTreeNote() -> Void {
        let tree = binaryTreeNoteHandle.shared.createTree()
        print(tree)
    }
    
    // MARK: - func-创建二叉树
    func funcTestNoteTreeCreate() -> Void {
//        对应图片treeNote1
        let array:Array<String> = ["a","b","d","","","E","","","c","","f","",""]
        let tree = binaryTreeNoteHandle.shared.createTree(withList: array,maker: noteIndex())
    }
    // MARK: - func-先序遍历
    func funcTestNoteTreeOrderXianxu() -> Void {
        print("先序遍历")
//        对应图片treeNote1
//        let array:Array<String> = ["a","b","d","","","E","","","c","","f","",""]
        //简单abc三角二叉树
        let array:Array<String> = ["a","b","","","c","",""]
        let tree = binaryTreeNoteHandle.shared.createTree(withList:array,maker: noteIndex())
        binaryTreeNoteHandle.shared.preOrderXianxu(withTree: tree)
        printLine()
    }
    
    // MARK: - func-中序遍历
    func funcTestNoteTreeOrderZhongxu() -> Void {
        print("中序遍历")
//        对应图片treeNote1
//        let array:Array<String> = ["a","b","d","","","E","","","c","","f","",""]
        let array:Array<String> = ["a","b","","","c","",""]
        let tree = binaryTreeNoteHandle.shared.createTree(withList:array,maker: noteIndex())
        binaryTreeNoteHandle.shared.preOrderZhongxu(withTree: tree)
        printLine()
    }
    
    // MARK: - func-后序遍历
    func funcTestNoteTreeOrderHouxu() -> Void {
        print("后序遍历")
//        对应图片treeNote1
//        let array:Array<String> = ["a","b","d","","","E","","","c","","f","",""]
        let array:Array<String> = ["a","b","","","c","",""]
        let tree = binaryTreeNoteHandle.shared.createTree(withList:array,maker: noteIndex())
        binaryTreeNoteHandle.shared.preOrderHouxu(withTree: tree)
        printLine()
    }
}

extension binaryTreeNoteVC{
    // MARK: - 二叉树扩展知识
    func showRegistExtendFuncs() -> Void {
        let message = "扩展"
        let alertC = UIAlertController.init(title: "二叉树扩展知识", message: message,preferredStyle: .actionSheet)
        registExtendAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registExtendAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("红黑树", .default) {
            self.funcExtendRedBlackTree()
        }
    }
    // MARK: - func-红黑树
    func funcExtendRedBlackTree() -> Void {
        let toVC = binaryRedBlackTreeVC()
        toVC.title = "红黑树"
        self.navigationController?.pushViewController(toVC, animated: true)
    }
}




class binaryTreeNote{
    ///树节点所存储的值
    var data:String
    ///指向左节点的内存地址
    var leftNote:binaryTreeNote!
    ///指向右节点的内存地址
    var rightNote:binaryTreeNote!
    
    init(data: String) {
        self.data = data
    }
}

class noteIndex{
    var index:Int = 0
}

class binaryTreeNoteHandle{
    static public let shared = binaryTreeNoteHandle()
    // MARK: - 创建二叉树-节点
    public func createTree()->binaryTreeNote{
        return binaryTreeNote(data: "Hello Tree")
    }
    // MARK: - 创建二叉树
    // -以递归的方式
    public func createTree(withList:Array<String>,maker:noteIndex)->binaryTreeNote!{
        if maker.index >= 0 && maker.index < withList.count{
            let data = withList[maker.index]
            if data == ""{
                maker.index += 1
                return nil
            }
            let note = binaryTreeNote(data: data)
            maker.index += 1
            note.leftNote = createTree(withList: withList, maker: maker)
            note.rightNote = createTree(withList: withList, maker: maker)

            return note
        }
        return nil
    }
    
    // MARK: - 先序遍历
    public func preOrderXianxu(withTree treeNote:binaryTreeNote?) -> Void{
        guard let note = treeNote else {
//            print("空")
            return
        }
        ///根->左->右
        print("\(note.data)")
        preOrderXianxu(withTree: note.leftNote)
        preOrderXianxu(withTree: note.rightNote)
    }
    
    // MARK: - 中序遍历
    public func preOrderZhongxu(withTree treeNote:binaryTreeNote?) -> Void{
        guard let note = treeNote else {
//            print("空")
            return
        }
        ///左->根->右
        preOrderZhongxu(withTree: note.leftNote)
        print("\(note.data)")
        preOrderZhongxu(withTree: note.rightNote)
    }
    // MARK: - 后序遍历
    public func preOrderHouxu(withTree treeNote:binaryTreeNote?) -> Void{
        guard let note = treeNote else {
//            print("空")
            return
        }
        ///左->右->根
        preOrderHouxu(withTree: note.leftNote)
        preOrderHouxu(withTree: note.rightNote)
        print("\(note.data)")
    }
    
}
