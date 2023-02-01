//
//  UITableViewExt.swift
//  JJEntitlementCard
//
//  Created by luoke_ios on 2022/8/19.
//

import UIKit

public protocol UINibCreater {
    func nib(in bundle:Bundle?) -> UINib
    func storyboard(in bundle:Bundle?) -> UIStoryboard
}

extension String : UINibCreater {
    
    public func nib(in bundle:Bundle? = nil) -> UINib {
        return UINib(nibName: self, bundle: bundle)
    }
    
    public func storyboard(in bundle:Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: self, bundle: bundle)
    }
    
}

extension RawRepresentable where RawValue == String {
    
    public func nib(in bundle:Bundle? = nil) -> UINib {
        return UINib(nibName: rawValue, bundle: bundle)
    }
    
    public func storyboard(in bundle:Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: bundle)
    }
    
}

extension UICollectionView {

    public func register<C>(cell clz:C.Type) where C : UICollectionViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(clz as AnyClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func register<C>(nibCell clz:C.Type) where C : UICollectionViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(identifier.nib(), forCellWithReuseIdentifier: identifier)
    }
    
    public func register<C>(header clz:C.Type) where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(clz as AnyClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    public func register<C>(nibHeader clz:C.Type) where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(identifier.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    public func register<C>(footer clz:C.Type) where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(clz as AnyClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }
    public func register<C>(nibFooter clz:C.Type) where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(identifier.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }
    
    public func dequeueReusable<C>(cell clz: C.Type, for indexPath: IndexPath) -> C where C : UICollectionViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! C
    }

    public func dequeueReusable<C>(header clz: C.Type, for indexPath: IndexPath) -> C where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as! C
    }
    
    public func dequeueReusable<C>(footer clz: C.Type, for indexPath: IndexPath) -> C where C : UICollectionReusableView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as! C
    }
}

extension UITableView {

    public func register<C>(nibHeaderOrFooter reused:C) where C : RawRepresentable, C.RawValue == String {
        register(reused.nib(), forHeaderFooterViewReuseIdentifier: reused.rawValue)
    }
    public func register<C>(headerOrFooter clz:C.Type) where C : UITableViewHeaderFooterView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(clz as AnyClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    public func register<C>(nibHeaderOrFooter clz:C.Type) where C : UITableViewHeaderFooterView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(identifier.nib(), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func register<C>(nibCell reused:C) where C : RawRepresentable, C.RawValue == String {
        register(reused.nib(), forCellReuseIdentifier: reused.rawValue)
    }
    public func register<C>(cell clz:C.Type) where C : UITableViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(clz as AnyClass, forCellReuseIdentifier: identifier)
    }
    public func register<C>(nibCell clz:C.Type) where C : UITableViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        register(identifier.nib(), forCellReuseIdentifier: identifier)
    }
    
    public func dequeueReusable<C>(cell reused: C, for indexPath: IndexPath) -> UITableViewCell where C : RawRepresentable, C.RawValue == String {
        return dequeueReusableCell(withIdentifier: reused.rawValue, for: indexPath)
    }
    public func dequeueReusable<C>(cell clz: C.Type, for indexPath: IndexPath) -> C where C : UITableViewCell {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! C
    }
    
    public func dequeueReusable<C>(headerOrFooter reused: C) -> UITableViewHeaderFooterView? where C : RawRepresentable, C.RawValue == String {
        return dequeueReusableHeaderFooterView(withIdentifier: reused.rawValue)
    }
    public func dequeueReusable<C>(headerOrFooter clz: C.Type) -> C? where C : UITableViewHeaderFooterView {
        let identifier = NSStringFromClass(clz as AnyClass).split(separator: ".").last!.description
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as? C
    }
    
    public func update(with block: (_ tableView: UITableView) -> ()) {
        self.beginUpdates()
        block(self)
        self.endUpdates()
    }
    
    public func scrollTo(row: NSInteger, in section: NSInteger, at ScrollPosition: UITableView.ScrollPosition, animated: Bool){
        let indexPath = IndexPath(row: row, section: section)
        self.scrollToRow(at: indexPath, at: ScrollPosition, animated: animated)
    }
    
    public func insert(row: NSInteger, in section: NSInteger, with rowAnimation: UITableView.RowAnimation) {
        let indexPath = IndexPath(row: row, section: section)
        self.insertRows(at: [indexPath], with: rowAnimation)
    }
    
    public func reload(row: NSInteger, in section: NSInteger, with rowAnimation: UITableView.RowAnimation) {
        let indexPath = IndexPath(row: row, section: section)
        self.reloadRows(at: [indexPath], with: rowAnimation)
    }
    
    public func delete(row: NSInteger, in section: NSInteger, with rowAnimation: UITableView.RowAnimation) {
        let indexPath = IndexPath(row: row, section: section)
        self.deleteRows(at: [indexPath], with: rowAnimation)
    }
    
    public func insert(at indexPath: IndexPath, with rowAnimation: UITableView.RowAnimation) {
        self.insertRows(at: [indexPath], with: rowAnimation)
    }
    
    public func reload(at indexPath: IndexPath, with rowAnimation: UITableView.RowAnimation) {
        self.reloadRows(at: [indexPath], with: rowAnimation)
    }
    
    public func delete(at indexPath: IndexPath, with rowAnimation: UITableView.RowAnimation) {
        self.deleteRows(at: [indexPath], with: rowAnimation)
    }
    
    public func reload(section: NSInteger, with rowAnimation: UITableView.RowAnimation) {
        self.reloadSections([section], with: rowAnimation)
    }
    
    public func clearSelectedRows(animated: Bool) {
        guard let indexs = self.indexPathsForSelectedRows else { return }
        for path in indexs {
            self.deselectRow(at: path, animated: animated)
        }
    }
}
