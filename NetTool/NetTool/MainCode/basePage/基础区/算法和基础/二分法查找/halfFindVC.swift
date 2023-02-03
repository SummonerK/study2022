//
//  halfFindVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/2.
//

import UIKit

class halfFindVC: BaseVC {
    
    // TODO: - 后续算法，继续坚持。
    /*
     https://www.jianshu.com/u/0a2c4094f94d
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let findIndex1 = halfFind(withNums: [1,2,3,4,5,6,7,8,9,10], targetNum: 2)
        let findIndex2 = halfFind(withNums: [1,2,3,4,5,6,7,8,9,10], targetNum: 8)
        
        LKPrint(findIndex1)
        LKPrint(findIndex2)
    }
    
    /*
     二分法查找

     问题：给定一个顺序的数组nums和一个整数目标值target，查找target在数组nums的下标。

     解题思路

     对比中间坐标值是否为目标值，根据值大小判断在左或右区间
     */
    
    func halfFind(withNums arrNums:[Int],targetNum:Int) -> Int {
        
        var lowIndex = 0,highIndex = arrNums.count-1,targetIndex = -1
        while lowIndex<=highIndex {
            let centerIndex = (lowIndex + highIndex)/2
            ///如果中间值等于目标值，跳出循环，返回Index
            if arrNums[centerIndex] == targetNum{
                targetIndex = centerIndex
                break
            }
            ///如果中间值大于目标值，最大坐标移到中间坐标，查找下一位
            if arrNums[centerIndex]>targetNum{
                highIndex = centerIndex
            }
            ///如果中间值小于目标值，最小坐标移到中间坐标，查找下一位
            if arrNums[centerIndex]<targetNum{
                lowIndex = centerIndex
            }
        }
        
        return targetIndex
    }

}
