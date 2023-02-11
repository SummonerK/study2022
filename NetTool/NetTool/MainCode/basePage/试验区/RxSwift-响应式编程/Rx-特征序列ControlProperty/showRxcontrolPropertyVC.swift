//
//  showRxcontrolPropertyVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/7.
//

import UIKit
import RxCocoa
import RxSwift

class showRxcontrolPropertyVC: BaseVC {
    @IBOutlet weak var label_show: UILabel!
    @IBOutlet weak var tf_show: UITextField!
    @IBOutlet weak var bton_tap: UIButton!
    
    let disposeBag = DisposeBag()
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        // Coding
        registPageLifeCycle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        setupRxFuncX()

        // Do any additional setup after loading the view.
    }


    func setupRxFuncX() -> Void {
        
        tf_show.rx.text.asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { element in
                LKPrint(element)
            })
            .disposed(by: disposeBag)
        
        /// 绑定输入，1000 毫秒更新一次
        tf_show.rx.text
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .bind(to: label_show.rx.text)
            .disposed(by: disposeBag)
        
        
        bton_tap.rx.tap.subscribe(onNext: {
            LKPrint("点击一下")
        }).disposed(by: disposeBag)
        
    }
    
    // MARK: - 监听页面生命周期
    func registPageLifeCycle() -> Void {
        self.rx.viewWillAppear.subscribe(onNext: { animated in
            LKPrint("viewWillAppear")
        }).disposed(by: disposeBag)
        self.rx.viewDidLoad.subscribe(onNext: {
            LKPrint("viewDidLoad")
        }).disposed(by: disposeBag)
        self.rx.viewDidAppear.subscribe(onNext: { animated in
            LKPrint("viewDidAppear")
        }).disposed(by: disposeBag)
        self.rx.viewWillDisappear.subscribe(onNext: { animated in
            LKPrint("viewWillDisappear")
        }).disposed(by: disposeBag)
        self.rx.viewDidDisappear.subscribe(onNext: { animated in
            LKPrint("viewDidDisappear")
        }).disposed(by: disposeBag)
        
        //页面显示状态完毕
        self.rx.isVisible.subscribe(onNext: { visible in
            LKPrint("当前页面显示状态：\(visible)")
        }).disposed(by: disposeBag)
    }

}

extension Reactive where Base: UIViewController {
    public var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
     
    public var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    public var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
     
    public var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    public var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
     
    public var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews))
            .map { _ in }
        return ControlEvent(events: source)
    }
    public var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews))
            .map { _ in }
        return ControlEvent(events: source)
    }
     
    public var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.willMove))
            .map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    public var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.didMove))
            .map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
     
    public var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning))
            .map { _ in }
        return ControlEvent(events: source)
    }
     
    //表示视图是否显示的可观察序列，当VC显示状态改变时会触发
    public var isVisible: Observable<Bool> {
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = self.base.rx.viewWillDisappear
            .map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable,
                                      viewWillDisappearObservable)
    }
     
    //表示页面被释放的可观察序列，当VC被dismiss时会触发
    public var isDismissing: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}

/*
 - 分为两种。
 
 1）：Storyboard

 init(coder:)

 awakeFromNib()

 loadView()

 viewDidLoad()

 viewWillAppear(_:)

 viewWillLayoutSubviews()

 viewDidLayoutSubviews()

 viewDidAppear(_:)

 viewWillDisappear(_:)

 viewDidDisappear(_:)

 deinit

 2）：Code（包括带有Xib）

 init(nibName:bundle:)

 loadView()

 viewDidLoad()

 viewWillAppear(_:)

 viewWillLayoutSubviews()

 viewDidLayoutSubviews()

 viewDidAppear(_:)

 viewWillDisappear(_:)

 viewDidDisappear(_:)

 deinit

 小知识：loadView方法

         当访问UIViewController的view属性时，view如果此时是nil，那么UIViewController会自动调用loadView方法来初始化一个UIView并赋值给view属性。这个方法不应该被直接调用，而是由系统自动调用。

        在创建view的过程中，首先会根据nibName去找对应的nib文件然后加载。如果nibName为空或找不到对应的nib文件，则会创建一个空视图。

        尽量不要重载此方法， 如果重载此方法，没有调用[super loadView]或者没有初始化view，就会造成死循环，因为loadView方法没有初始化view。viewDidLoad方法的时候，发现view没有初始化，就去调用loadView方法，但是loadView没有初始化view，死循环愉快的造成了。

        初始化带有关联nib文件的UIViewController时候，你用init或者init(nibName:bundle:)方法，只有不重载loadView，nib文件都会加载到。如果你重载了loadView方法，哪怕像下面这样，init方法就加载不到nib文件，但是init(nibName:bundle:)可以。

         - (void)loadView{

             [super loadView];

         }

        注意在重写loadView方法的时候，不要调用父类的方法。

 */
