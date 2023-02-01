//
//  ManagerCollectionVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/20.
//

import UIKit

class ManagerCollectionVC: UIViewController {
    
    var collectionV_main:UICollectionView!
    var indexPath: IndexPath?
    var targetIndexPath: IndexPath?
    
    var arrayTopic:Array<String> = ["数学1","数学2","数学3","数学4","数学5","数学6"]
    var arrayStore:Array<String> = ["数学2-1","数学2-2","数学2-3","数学2-4","数学2-5","数学2-6"]

    lazy var dragingItem: CCellProblemManagerItem = {
        let cell: CCellProblemManagerItem = CCellProblemManagerItem.initWithNib()
        let CellW:CGFloat = (kscreenW-24-10)/2
        let CellH:CGFloat = (kscreenW-24)/350*85
        cell.frame = CGRect(x: 0, y: 0, width: CellW, height: CellH)
        cell.isHidden = true
        return cell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = baseBGColor
        // TODO: - todo something
        initCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initCollectionView() -> Void {
        let mainView_Y:CGFloat = view.safeInsets.top + 44
        let mainView_H:CGFloat = kscreenH - mainView_Y - self.view.safeInsets.bottom
        collectionV_main = UICollectionView.init(frame: CGRect.init(x: 0, y: mainView_Y, width: kscreenW, height:mainView_H), collectionViewLayout: cvFlow())
        setUpListView()
        view.addSubview(collectionV_main)
    }

}

extension ManagerCollectionVC{
    
    func setUpListView() -> Void {
        collectionV_main.backgroundColor = .clear
        collectionV_main.delegate = self
        collectionV_main.dataSource = self
        collectionV_main.showsVerticalScrollIndicator = false
        collectionV_main.showsHorizontalScrollIndicator = false
        collectionV_main.isScrollEnabled = true
        collectionV_main.register(nibCell: CCellProblemManagerItem.self)
        collectionV_main.register(nibHeader: CHeaderViewManager.self)
        collectionV_main.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        collectionV_main.addGestureRecognizer(longPress)
        collectionV_main.addSubview(dragingItem)
    }
    
    func cvFlow() -> UICollectionViewFlowLayout {
        let f = UICollectionViewFlowLayout.init()
        f.minimumLineSpacing = 0
        f.minimumInteritemSpacing = 0
        f.scrollDirection = .vertical
        return f
    }
    
    //MARK: - 长按动作
    @objc func longPressGesture(_ tap: UILongPressGestureRecognizer) {
        let point = tap.location(in: collectionV_main)
        switch tap.state {
        case UIGestureRecognizer.State.began:
                dragBegan(point: point)
        case UIGestureRecognizer.State.changed:
                drageChanged(point: point)
        case UIGestureRecognizer.State.ended:
                drageEnded(point: point)
        case UIGestureRecognizer.State.cancelled:
                drageEnded(point: point)
            default: break
        }
    }
    
    //MARK: - 长按开始
    private func dragBegan(point: CGPoint) {
        indexPath = collectionV_main.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! > 0
        {return}
        
        let item = collectionV_main.cellForItem(at: indexPath!) as? CCellProblemManagerItem
        item?.isHidden = true
        dragingItem.isHidden = false
        dragingItem.frame = (item?.frame)!
        dragingItem.label_title.text = item!.label_title.text
        dragingItem.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    //MARK: - 长按过程
    private func drageChanged(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! > 0 {return}
        dragingItem.center = point
        targetIndexPath = collectionV_main.indexPathForItem(at: point)
        if targetIndexPath == nil || (targetIndexPath?.section)! > 0 || indexPath == targetIndexPath {return}
        // 更新数据
        let obj = arrayTopic[indexPath!.item]
        arrayTopic.remove(at: indexPath!.row)
        arrayTopic.insert(obj, at: targetIndexPath!.item)
        //交换位置
        collectionV_main.moveItem(at: indexPath!, to: targetIndexPath!)
        indexPath = targetIndexPath
    }
    
    //MARK: - 长按结束
    private func drageEnded(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! > 0 {return}
        let endCell = collectionV_main.cellForItem(at: indexPath!)
        
        UIView.animate(withDuration: 0.25, animations: {
        
            self.dragingItem.transform = CGAffineTransform.identity
            self.dragingItem.center = (endCell?.center)!
            
        }, completion: {
        
            (finish) -> () in
            
            endCell?.isHidden = false
            self.dragingItem.isHidden = true
            self.indexPath = nil
            
        })
    }
    
}

extension ManagerCollectionVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return arrayTopic.count
        }
        if section == 1{
            return arrayStore.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            let Cell:CCellProblemManagerItem = collectionView.dequeueReusable(cell: CCellProblemManagerItem.self, for: indexPath)
            Cell.label_title.text = String(format: "%@", arrayTopic[indexPath.row])
            
            return Cell
        }
        
        if indexPath.section == 1{
            let Cell:CCellProblemManagerItem = collectionView.dequeueReusable(cell: CCellProblemManagerItem.self, for: indexPath)
            Cell.label_title.text = String(format: "%@", arrayStore[indexPath.row])
            
            return Cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if indexPath.section == 0{
            let obj = arrayTopic[indexPath.item]
            arrayTopic.remove(at: indexPath.item)
            arrayStore.append(obj)
            collectionView.moveItem(at: indexPath, to: NSIndexPath(item: 0, section: 1) as IndexPath)
        }
        
        if indexPath.section == 1{
            let obj = arrayStore[indexPath.item]
            arrayStore.remove(at: indexPath.item)
            arrayTopic.append(obj)
            collectionView.moveItem(at: indexPath, to: NSIndexPath(item: arrayTopic.count - 1, section: 0) as IndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0{
            let CellW:CGFloat = (kscreenW-24-10)/2
            let CellH:CGFloat = (kscreenW-24)/350*90
            return CGSize(width: CellW, height: CellH)
        }
        
        if indexPath.section == 1{
            let CellW:CGFloat = (kscreenW-24-10)/2
            let CellH:CGFloat = (kscreenW-24)/350*85
            return CGSize(width: CellW, height: CellH)
        }
        
        return CGSize(width: kscreenW, height: 0.01)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0{
            return UIEdgeInsets(top: 0, left: 12, bottom: 5, right: 12)
        }
        if section == 1{
            return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            if indexPath.section == 0{
                let header:CHeaderViewManager = collectionView.dequeueReusable(header: CHeaderViewManager.self, for: indexPath)
                header.label_title.text = "编辑区"
                header.label_subTitle.text = "按住拖动调整排序"
                header.label_subTitle.isHidden = false
                
                return header
            }
            if indexPath.section == 1{
                let header:CHeaderViewManager = collectionView.dequeueReusable(header: CHeaderViewManager.self, for: indexPath)
                header.label_title.text = "待选区"
                header.label_subTitle.isHidden = true
                
                return header
            }
            return UICollectionReusableView()
        }else{
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kscreenW, height: 40)
    }
}
