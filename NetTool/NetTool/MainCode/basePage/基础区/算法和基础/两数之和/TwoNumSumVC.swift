//
//  TwoNumSumVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/2.
//

import UIKit

class TwoNumSumVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let array1 = twoNumSum(withNums: [1,2,3,3,5,6], targetSum: 5)
        
        LKPrint(array1)
        
        let array2 = twoNumSum(withNums: [1,2,3,3,5,6], targetSum: 3)
        
        LKPrint(array2)
        
    }
    
    /*
     两数之和
     问题：给定一个整数数组nums和一个整数目标值target，请在该数组中找到和为目标值的两个整数，并返回他们值的数组。
     
     解题思路

     将数据依次存到临时数组中，判断总值-当前值是否存在临时数组，如果存在返回两个数
     */
    func twoNumSum(withNums arrayNums:[Int],targetSum:Int) -> [Int] {
        // 创建返回值数组
        var array_res = [Int]()
        // 创建数组-保存遍历过的值
        var array_temp = [Int]()
        
        for i in 0..<arrayNums.count{
            let other = targetSum - arrayNums[i]
            if array_temp.contains(other){
                array_res.append(arrayNums[i])
                array_res.append(other)
                return array_res
            }
            array_temp.append(arrayNums[i])
        }
        // 返回空的数组
        return array_res
    }

}
