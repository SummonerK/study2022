import UIKit

var greeting = "Hello, playground"

let money = 100_0000

//类型转换
let int1 = 3
let int2:Int16 = 1
let int3 = int2 + Int16(int1)

//浮点类型转换
let int = 3
let double = 0.14159
let pi = Double(int) + double //3.14159
let intPi = Int(pi) //3

//字面量可以直接相加，因为数字字面量本身没有明确的类型
let result = 3 + 0.1415926 // result类型推导为Double，值为3.1415926

//闭区间运算符：a...b,等价于 a<=取值<=b
let range1 = 1...3//let range1: ClosedRange<Int>
//半开区间运算符:a..<b,等价于 a<=取值<b
let range2 = 1..<3//let range2: Range<Int>
//单侧区间:...a等价于，让区间朝着左侧尽可能远，最大不超过a; b...等价于，让区间朝着右侧尽可能远，最小不低于b
let range3 = ...5//let range3: PartialRangeThrough<Int>
let range4 = ..<5//let range: PartialRangeUpTo<Int>
let range5 = 5... //let range5: PartialRangeFrom<Int>

let range = "cc"..."ff"//let range: ClosedRange<String>
range.contains("cb")//false
range.contains("ge")//false
range.contains("ef")//true

// \0囊括了所有可能要用到的ASCII字符
let characterRange  : ClosedRange<Character> = "\0"..."~"
characterRange.contains("G")//true
let normalValue:String = ""

let hours = 11
let hourInterval = 2
//tickMark的取值：从4开始，累加2，不超过11
for tickMark in stride(from: 4, to: hours, by: hourInterval) {
    print(tickMark)
}//4 6 8 10

