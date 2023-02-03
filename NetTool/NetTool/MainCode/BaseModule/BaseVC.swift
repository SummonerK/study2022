//
//  BaseVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/10/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    let disposeBagBase = DisposeBag()
    
    var bton_basenext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.backgroundColor = UIColor.hexStringColor(hexString: "f5f5f5")
        setNavigationView()
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //启用滑动返回（swipe back）
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        
        // MARK: - 如果是webView，左滑手势又会失效，新增一个左滑手势
        //新建一个滑动手势
//        let tap = UISwipeGestureRecognizer(target:self, action:nil)
//        tap.delegate = self
//        self.webView.addGestureRecognizer(tap)
    }
    
    //返回true表示所有相同类型的手势辨认都会得到处理
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer:
        UIGestureRecognizer) -> Bool {
        return true
    }
    
    //是否允许手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer) {
            //只有二级以及以下的页面允许手势返回
            return self.navigationController!.viewControllers.count > 1
        }
        return true
    }
    
    func setNavigationView() -> Void {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
             //设置取消按钮的字
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: baseTextColor33]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        } else {
            UINavigationBar.appearance().barTintColor = baseTextColor33
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().tintColor = .white
        }
        
        setUpBackItem()
        
        
//        let setBtnItem: UIBarButtonItem = UIBarButtonItem.init(customView: self.setBtn)
//        let negativeSpacer: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        negativeSpacer.width = 20
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem](arrayLiteral: negativeSpacer, setBtnItem)
        
        
    }
    
    func setClearBar() -> Void {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    func setUpBackItem() -> Void {
        let view = UIView()
        view.frame = CGRectMake(0, 0, 60, 44)
        view.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.hexStringColor(hexString: "333333")
        view.addSubview(label)
        label.frame = CGRectMake(0, 0, 60, 44)
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "返回"
        
        
        let setBtnItem: UIBarButtonItem = UIBarButtonItem.init(customView: view)
        let negativeSpacer: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = 8
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem](arrayLiteral: negativeSpacer, setBtnItem)
        
        view.jk.addActionClosure { tap, aview, num in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupBtonBaseNext() -> Void {
        bton_basenext = UIButton.init(type: .custom)
        bton_basenext.setTitle("测试一些东西", for: .normal)
        bton_basenext.setTitleColor(.white, for: .normal)
        bton_basenext.backgroundColor = baseIronColor
        
        view.addSubview(bton_basenext)
        
        bton_basenext.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeInsets.bottom).offset(-50)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(50)
        }
        
        let observable = Observable<CGFloat>.just(18.0)
        
        observable
            .bind(to: (bton_basenext.titleLabel?.rx.fontSize)!)
            .disposed(by: disposeBagBase)
        
        //功能集合
        bton_basenext.jk.setHandleClick {[weak self] button in
            guard let self = self else{return}
            self.showBaseRegistFuncs()
        }
        
    }
    // MARK: - 底部方法集合
    func showBaseRegistFuncs() -> Void {
        let alertC = UIAlertController.init(title: "测试", message: nil,preferredStyle: .actionSheet)
        registBaseAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registBaseAlertCActions(withAlertC alertC:UIAlertController)->Void{
//        alertC.addAction("蓝牙搜索-开始🚀", .default) {
//            self.bluetooth_search()
//        }
    }

}

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"gǒu tóu jūn shī\", \"sug\": \"狗(gou3)头(tou2)军(jun1)师(shi1)\"}]',
 basic_define_list='[{\"pinyin\": \"gǒu tóu jūn shī\", \"definition\": [\"比喻爱给人出主意而主意又不高明的人。\"]}]',
 detail_define_list='[\"<dl><dt><a>狗头军师 [gǒu tóu jūn shī]</a></dt><dd><ol><li><p>狗头军师，汉语成语，拼音是gǒu tóu jūn shī，意思是比喻爱给人出主意而主意又不高明的人。也比喻专门出坏主意的人。出自《何典》。</p></li></ol></dd></dl>\"]'
 where id=10823;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"yǔ shàn guān jīn\", \"sug\": \"羽(yu3)扇(shan4)纶(guan1)巾(jin1)\"}]',
 basic_define_list='[{\"pinyin\": \"yǔ shàn guān jīn\", \"definition\": [\"意思是拿着羽毛扇子，戴着青丝绶的头巾。形容态度从容。\"]}]',
 detail_define_list='[\"<dl><dt><a>羽扇纶巾 [yǔ shàn guān jīn]</a></dt><dd><ol><li><p>羽扇纶巾，汉语成语，拼音是yǔ shàn guān jīn，意思是拿着羽毛扇子，戴着青丝绶的头巾。形容态度从容。</p><p>出自宋·苏轼《念奴娇·赤壁怀古》，指代汉末儒将周瑜的便装打扮。</p></li></ol></dd></dl>\"]'
 where id=11694;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"jū gōng jìn cuì\", \"sug\": \"鞠(ju1)躬(gong1)尽(jin4)瘁(cui4)\"}]',
 basic_define_list='[{\"pinyin\": \"jū gōng jìn cuì\", \"definition\": [\"不辞辛劳，尽力于国事，形容小心谨慎，贡献出全部精力。\"]}]',
 detail_define_list='[\"<dl><dt><a>鞠躬尽瘁 [jū gōng jìn cuì]</a></dt><dd><ol><li><p>鞠躬尽瘁，是汉语中来源于古代奏表的一则成语，语出三国·蜀·诸葛亮《后出师表》：“臣鞠躬尽力，死而后已。”</p><p>这则成语指不辞辛劳，尽力于国事，形容小心谨慎，贡献出全部精力。其自身结构为补充式，在句子中可作谓语，含褒义。</p></li></ol></dd></dl>\"]'
 where id=12659;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"guò hé chāi qiáo\", \"sug\": \"过(guo4)河(he2)拆(chai1)桥(qiao2)\"}]',
 basic_define_list='[{\"pinyin\": \"guò hé chāi qiáo\", \"definition\": [\"比喻达到目的后，就把曾经帮助自己的人一脚踢开。\"]}]',
 detail_define_list='[\"<dl><dt><a>过河拆桥 [guò hé chāi qiáo]</a></dt><dd><ol><li><p>过河拆桥（拼音：guò hé chāi qiáo）是一个成语，最早出自于宋·大慧宗杲禅师《大慧普觉禅师语录》。</p><p>过河拆桥指过河后便拆掉桥；比喻达到目的后，就把曾经帮助自己的人一脚踢开。含贬义；作谓语、宾语、分句。</p></li></ol></dd></dl>\"]'
 where id=12712;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"sān tóu liù bì\", \"sug\": \"三(san1)头(tou2)六(liu4)臂(bi4)\"}]',
 basic_define_list='[{\"pinyin\": \"sān tóu liù bì\", \"definition\": [\"三个脑袋，六条胳臂，原为佛家语，指佛的法相，后比喻神奇的本领。\"]}]',
 detail_define_list='[\"<dl><dt><a>三头六臂 [sān tóu liù bì]</a></dt><dd><ol><li><p>三头六臂，汉语成语，拼音：sān tóu liù bì，释义：三个脑袋，六条胳臂，原为佛家语，指佛的法相，后比喻神奇的本领。出自《历代神仙通鉴》。</p></li></ol></dd></dl>\"]'
 where id=12906;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"shuǐ dī shí chuān\", \"sug\": \"水(shui3)滴(di1)石(shi2)穿(chuan1)\"}]',
 basic_define_list='[{\"pinyin\": \"shuǐ dī shí chuān\", \"definition\": [\"水滴不断地滴，可以滴穿石头；比喻坚持不懈，集细微的力量也能成就难能的功劳。\"]}]',
 detail_define_list='[\"<dl><dt><a>水滴石穿 [shuǐ dī shí chuān]</a></dt><dd><ol><li><p>水滴石穿是一个成语，最早出自东汉·班固《汉书·枚乘传》。</p><p>该成语的意思是指水滴不断地滴，可以滴穿石头；比喻坚持不懈，集细微的力量也能成就难能的功劳。在句子一般作谓语、状语。“水滴石穿”不宜写作“滴水穿石”。</p></li></ol></dd></dl>\"]'
 where id=12926;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"mǎn fù jīng lún\", \"sug\": \"满(man3)腹(fu4)经(jing1)纶(lun2)\"}]',
 basic_define_list='[{\"pinyin\": \"mǎn fù jīng lún\", \"definition\": [\"形容人很有才学和智谋。\"]}]',
 detail_define_list='[\"<dl><dt><a>满腹经纶 [mǎn fù jīng lún]</a></dt><dd><ol><li><p>满腹经纶，汉语成语，读音是mǎn fù jīng lún，形容人很有才学和智谋。出自《周易·屯》。</p></li></ol></dd></dl>\"]'
 where id=13077;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"zhōng líng yù xiù\", \"sug\": \"钟(zhong1)灵(ling2)毓(yu4)秀(xiu4)\"}]',
 basic_define_list='[{\"pinyin\": \"zhōng líng yù xiù\", \"definition\": [\"指山川秀美，人才辈出。\"]}]',
 detail_define_list='[\"<dl><dt><a>钟灵毓秀 [zhōng líng yù xiù]</a></dt><dd><ol><li><p>钟灵毓秀（zhōng líng yù xiù），汉语成语，形容词，意思是凝聚了天地间的灵气，孕育着优秀的人物。指山川秀美，人才辈出。出自唐·柳宗元《马退山茅亭记》。</p></li></ol></dd></dl>\"]'
 where id=13195;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"lín zhèn mó qiāng\", \"sug\": \"临(lin2)阵(zhen4)磨(mo2)枪(qiang1)\"}]',
 basic_define_list='[{\"pinyin\": \"lín zhèn mó qiāng\", \"definition\": [\"到阵前要作战时才磨枪，比喻事到临头才做准备。\"]}]',
 detail_define_list='[\"<dl><dt><a>临阵磨枪 [lín zhèn mó qiāng]</a></dt><dd><ol><li><p>临阵磨枪，汉语成语，拼音是lín zhèn mó qiāng，意思是到阵前要作战时才磨枪，比喻事到临头才做准备。出自清·曹雪芹《红楼梦》第七十回。</p></li></ol></dd></dl>\"]'
 where id=13664;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"duì bù gōng táng\", \"sug\": \"对(dui4)簿(bu4)公(gong1)堂(tang2)\"}]',
 basic_define_list='[{\"pinyin\": \"duì bù gōng táng\", \"definition\": [\"被告方当堂受审，现常被用来表示原被告双方在法庭上公开审问、争讼，以辨是非。\"]}]',
 detail_define_list='[\"<dl><dt><a>对簿公堂 [duì bù gōng táng]</a></dt><dd><ol><li><p>对簿公堂，汉语成语，拼音是duì bù gōng táng，原意指被告方当堂受审，现常被用来表示原被告双方在法庭上公开审问、争讼，以辨是非。出自《史记·李将军列传》。</p></li></ol></dd></dl>\"]'
 where id=13821;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"shā shēn zhī huò\", \"sug\": \"杀(sha1)身(shen1)之(zhi1)祸(huo4)\"}]',
 basic_define_list='[{\"pinyin\": \"shā shēn zhī huò\", \"definition\": [\"自身性命遭杀害的大祸。\"]}]',
 detail_define_list='[\"<dl><dt><a>杀身之祸 [shā shēn zhī huò]</a></dt><dd><ol><li><p>杀身之祸，汉语成语，拼音是shā shēn zhī huò，意思是自身性命遭杀害的大祸。出自《老残游记》。</p></li></ol></dd></dl>\"]'
 where id=14089;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"tǐng ér zǒu xiǎn\", \"sug\": \"挺(ting3)而(er2)走(zou3)险(xian3)\"}]',
 basic_define_list='[{\"pinyin\": \"tǐng ér zǒu xiǎn\", \"definition\": [\"在无路可走的时候采取冒险行动。\"]}]',
 detail_define_list='[\"<dl><dt><a>挺而走险 [tǐng ér zǒu xiǎn]</a></dt><dd><ol><li><p>挺而走险，拼音为tǐng ér zǒu xiǎn，汉语词语，释义：在无路可走的时候采取冒险行动。</p></li></ol></dd></dl>\"]'
 where id=14103;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"duō nàn xīng bāng\", \"sug\": \"多(duo1)难(nan4)兴(xing1)邦(bang1)\"}]',
 basic_define_list='[{\"pinyin\": \"duō nàn xīng bāng\", \"definition\": [\"多灾多难的局面有时反能使民众发奋图强、战胜困境，使国家兴盛起来\"]}]',
 detail_define_list='[\"<dl><dt><a>多难兴邦 [duō nàn xīng bāng]</a></dt><dd><ol><li><p>多难兴邦（拼音：duō nàn xīng bāng）是一则来源于历史故事的成语，成语有关典故最早见于《左传·昭公四年》。</p><p>“多难兴邦”指多灾多难的局面有时反能使民众发奋图强、战胜困境，使国家兴盛起来（邦：国家）。该成语在句中一般作分句或独立成句，也作谓语、定语。</p></li></ol></dd></dl>\"]'
 where id=14172;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"shùn shuǐ tuī zhōu\", \"sug\": \"顺(shun4)水(shui3)推(tui1)舟(zhou1)\"}]',
 basic_define_list='[{\"pinyin\": \"shùn shuǐ tuī zhōu\", \"definition\": [\"顺着水流的方向推船，比喻顺着某个趋势或某种方式说话办事。\"]}]',
 detail_define_list='[\"<dl><dt><a>顺水推舟 [shùn shuǐ tuī zhōu]</a></dt><dd><ol><li><p>顺水推舟，汉语成语，拼音是shùn shuǐ tuī zhōu，意思是顺着水流的方向推船，比喻顺着某个趋势或某种方式说话办事。出自《窦娥冤》。</p></li></ol></dd></dl>\"]'
 where id=14284;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"shùn shǒu qiān yáng\", \"sug\": \"顺(shun4)手(shou3)牵(qian1)羊(yang2)\"}]',
 basic_define_list='[{\"pinyin\": \"shùn shǒu qiān yáng\", \"definition\": [\"顺手把人家的羊牵走；比喻趁势将敌手捉住或乘机利用别人。\"]}]',
 detail_define_list='[\"<dl><dt><a>顺手牵羊 [shùn shǒu qiān yáng]</a></dt><dd><ol><li><p>顺手牵羊是一个汉语成语，最早出自《论语》。</p><p>该成语的意思是指顺手把人家的羊牵走；比喻趁势将敌手捉住或乘机利用别人。在句子一般作谓语、定语、状语。</p></li></ol></dd></dl>\"]'
 where id=14290;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"shùn téng mō guā\", \"sug\": \"顺(shun4)藤(teng2)摸(mo1)瓜(gua1)\"}]',
 basic_define_list='[{\"pinyin\": \"shùn téng mō guā\", \"definition\": [\"比喻按照某个线索查究事情。\"]}]',
 detail_define_list='[\"<dl><dt><a>顺藤摸瓜 [shùn téng mō guā]</a></dt><dd><ol><li><p>顺藤摸瓜，汉语成语，拼音是shùn téng mō guā，意思是比喻按照某个线索查究事情。出自《人民日报》。</p></li></ol></dd></dl>\"]'
 where id=14293;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"yǎng jīng xù ruì\", \"sug\": \"养(yang3)精(jing1)蓄(xu4)锐(rui4)\"}]',
 basic_define_list='[{\"pinyin\": \"yǎng jīng xù ruì\", \"definition\": [\"意思是保养精神，蓄集力量。\"]}]',
 detail_define_list='[\"<dl><dt><a>养精蓄锐 [yǎng jīng xù ruì]</a></dt><dd><ol><li><p>养精蓄锐，汉语成语，拼音是yǎng jīng xù ruì，意思是保养精神，蓄集力量。出自《三国演义》。
</p></li></ol></dd></dl>\"]'
 where id=14363;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"chì bó shàng zhèn\", \"sug\": \"赤(chi4)膊(bo2)上(shang4)阵(zhen4)\"}]',
 basic_define_list='[{\"pinyin\": \"chì bó shàng zhèn\", \"definition\": [\"意思是光着上身，指不穿盔甲，形容作战英勇，全力以赴地进行战斗。后比喻没有准备或毫无掩饰地从事。\"]}]',
 detail_define_list='[\"<dl><dt><a>赤膊上阵 [chì bó shàng zhèn]</a></dt><dd><ol><li><p>赤膊上阵，汉语成语，读音是chì bó shàng zhèn，意思是光着上身，指不穿盔甲，形容作战英勇，全力以赴地进行战斗。后比喻没有准备或毫无掩饰地从事。出自《三国演义》。</p></li></ol></dd></dl>\"]'
 where id=14396;
 
 */


/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"fù bèi shòu dí\", \"sug\": \"腹(fu4)背(bei4)受(shou4)敌(di2)\"}]',
 basic_define_list='[{\"pinyin\": \"fù bèi shòu dí\", \"definition\": [\"意思是指前后受到敌人的夹攻。\"]}]',
 detail_define_list='[\"<dl><dt><a>腹背受敌 [fù bèi shòu dí]</a></dt><dd><ol><li><p>腹背受敌，汉语成语，拼音是fù bèi shòu dí，意思是指前后受到敌人的夹攻，出自《魏书·崔浩传》。</p></li></ol></dd></dl>\"]'
 where id=14467;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"míng huǒ zhí zhàng\", \"sug\": \"明(ming2)火(huo3)执(zhi2)杖(zhang4)\"}]',
 basic_define_list='[{\"pinyin\": \"míng huǒ zhí zhàng\", \"definition\": [\"形容明目张胆地为非作歹，毫无顾忌 。\"]}]',
 detail_define_list='[\"<dl><dt><a>明火执杖 [míng huǒ zhí zhàng]</a></dt><dd><ol><li><p>明火执仗，汉语成语，拼音是míng huǒ zhí zhàng，形容明目张胆地为非作歹，毫无顾忌 。出自元 无名氏 《盆儿鬼》第二折。</p></li></ol></dd></dl>\"]'
 where id=14551;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"fēng yǔ jiāo jiā\", \"sug\": \"风(feng1)雨(yu3)交(jiao1)加(jia1)\"}]',
 basic_define_list='[{\"pinyin\": \"fēng yǔ jiāo jiā\", \"definition\": [\"风雨一起袭来。形容天气十分恶劣。有时也比喻几种灾难一起袭来。\"]}]',
 detail_define_list='[\"<dl><dt><a>风雨交加 [fēng yǔ jiāo jiā]</a></dt><dd><ol><li><p>风雨交加，汉语成语，拼音为fēng yǔ jiāo jiā，指的是风雨一起袭来。形容天气十分恶劣。有时也比喻几种灾难一起袭来。</p></li></ol></dd></dl>\"]'
 where id=14656;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"jīn yǔ xīn zhī\", \"sug\": \"今(jin1)雨(yu3)新(xin1)知(zhi1)\"}]',
 basic_define_list='[{\"pinyin\": \"jīn yǔ xīn zhī\", \"definition\": [\"意思是比喻新近结交的朋友。\"]}]',
 detail_define_list='[\"<dl><dt><a>今雨新知 [jīn yǔ xīn zhī]</a></dt><dd><ol><li><p>今雨新知，汉语成语，拼音是jīn yǔ xīn zhī，意思是比喻新近结交的朋友。出自《秋述》。</p></li></ol></dd></dl>\"]'
 where id=14658;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"hàn miáo dé yǔ\", \"sug\": \"旱(han4)苗(miao2)得(de2)雨(yu3)\"}]',
 basic_define_list='[{\"pinyin\": \"hàn miáo dé yǔ\", \"definition\": [\"意思是将要枯死的禾苗得到地场好雨，比喻在危难中得到援助。\"]}]',
 detail_define_list='[\"<dl><dt><a>旱苗得雨 [hàn miáo dé yǔ]</a></dt><dd><ol><li><p>旱苗得雨，汉语成语，拼音是hàn miáo dé yǔ，意思是将要枯死的禾苗得到地场好雨，比喻在危难中得到援助。出自《孟子·梁惠王上》。</p></li></ol></dd></dl>\"]'
 where id=14715;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"zhù cí\", \"sug\": \"助(zhu4)词(ci2)\"}]',
 basic_define_list='[{\"pinyin\": \"zhù cí\", \"definition\": [\"一种词类，属于虚词，附着在其他词汇、词组，或是句子上，作为辅助之用。\"]}]',
 detail_define_list='[\"<dl><dt><a>助词 [zhù cí]</a></dt><dd><ol><li><p>助词，又称为语助词。文法术语，指的是一种词类，属于虚词，附着在其他词汇、词组，或是句子上，作为辅助之用。通常用于句子前、中、后，表示各种语气；或是用于语句中间，表示结构上的关系。必须附着在别的词语的后面或前面，凡是后附的都读轻声，前附的不读轻声。</p></li></ol></dd></dl>\"]'
 where id=14716;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"kuáng fēng bào yǔ\", \"sug\": \"狂(kuang2)风(feng1)暴(bao4)雨(yu3)\"}]',
 basic_define_list='[{\"pinyin\": \"kuáng fēng bào yǔ\", \"definition\": [\"指大风大雨。亦比喻猛烈的声势或处境险恶。\"]}]',
 detail_define_list='[\"<dl><dt><a>狂风暴雨 [kuáng fēng bào yǔ]</a></dt><dd><ol><li><p>狂风暴雨是汉语成语，读音为：kuáng fēng bào yǔ，指大风大雨。亦比喻猛烈的声势或处境险恶。出自《老子》。</p></li></ol></dd></dl>\"]'
 where id=14733;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"yǔ suō fēng lì\", \"sug\": \"雨(yu3)蓑(suo1)风(feng1)笠(li4)\"}]',
 basic_define_list='[{\"pinyin\": \"yǔ suō fēng lì\", \"definition\": [\"意思是防雨用的蓑衣笠帽，为渔夫的衣饰。\"]}]',
 detail_define_list='[\"<dl><dt><a>雨蓑风笠 [yǔ suō fēng lì]</a></dt><dd><ol><li><p>雨蓑风笠，汉语词语，拼音是yǔ suō fēng lì，意思是防雨用的蓑衣笠帽，为渔夫的衣饰。亦借指渔夫。出自《沁园春·丙辰归里和八窗叔韵》。</p></li></ol></dd></dl>\"]'
 where id=14766;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"āi fēng jī fèng\", \"sug\": \"捱(ai1)风(feng1)缉(ji1)缝(feng4)\"}]',
 basic_define_list='[{\"pinyin\": \"āi fēng jī fèng\", \"definition\": [\"意思是指多方钻营，找门路。\"]}]',
 detail_define_list='[\"<dl><dt><a>捱风缉缝 [āi fēng jī fèng]</a></dt><dd><ol><li><p>捱风缉缝，汉语成语，拼音是āi fēng jī fèng，意思是指多方钻营，找门路。出自《醒世恒言·卢太学诗酒傲公侯》。</p></li></ol></dd></dl>\"]'
 where id=14805;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"wēi fēng sǎo dì\", \"sug\": \"威(wei1)风(feng1)扫(sao3)地(di4)\"}]',
 basic_define_list='[{\"pinyin\": \"wēi fēng sǎo dì\", \"definition\": [\"意思是完全丧失了威严和信誉。\"]}]',
 detail_define_list='[\"<dl><dt><a>威风扫地 [wēi fēng sǎo dì]</a></dt><dd><ol><li><p>威风扫地，汉语成语，拼音是wēi fēng sǎo dì，意思是完全丧失了威严和信誉。出自赵树理《三里湾》。</p></li></ol></dd></dl>\"]'
 where id=14958;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"fēng liú qiān gǔ\", \"sug\": \"风(feng1)流(liu2)千(qian1)古(gu3)\"}]',
 basic_define_list='[{\"pinyin\": \"fēng liú qiān gǔ\", \"definition\": [\"意思是指风雅之事久远流传。\"]}]',
 detail_define_list='[\"<dl><dt><a>风流千古 [fēng liú qiān gǔ]</a></dt><dd><ol><li><p>风流千古，汉语成语，拼音是fēng liú qiān gǔ，意思是指风雅之事久远流传。出自《青玉案》。</p></li></ol></dd></dl>\"]'
 where id=15235;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"hǔ tóu yàn hàn\", \"sug\": \"虎(hu3)头(tou2)燕(yan4)颔(han4)\"}]',
 basic_define_list='[{\"pinyin\": \"hǔ tóu yàn hàn\", \"definition\": [\"意思是旧时形容王侯的贵相或武将相貌的威武。\"]}]',
 detail_define_list='[\"<dl><dt><a>虎头燕颔 [hǔ tóu yàn hàn]</a></dt><dd><ol><li><p>虎头燕颔，汉语成语，拼音是hǔ tóu yàn hàn，意思是旧时形容王侯的贵相或武将相貌的威武。出自《后汉书·班超传》。</p></li></ol></dd></dl>\"]'
 where id=15395;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"qián lóng fú hǔ\", \"sug\": \"潜(qian2)龙(long2)伏(fu2)虎(hu3)\"}]',
 basic_define_list='[{\"pinyin\": \"qián lóng fú hǔ\", \"definition\": [\"比喻人才尚未被擢用。\"]}]',
 detail_define_list='[\"<dl><dt><a>潜龙伏虎 [qián lóng fú hǔ]</a></dt><dd><ol><li><p>潜龙伏虎，成语，指潜藏的蛟龙，潜伏的猛虎。比喻人才尚未被擢用。出自 明·何文焕《双珠记·西市认母》。</p></li></ol></dd></dl>\"]'
 where id=15507;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"lóng lóu fèng gé\", \"sug\": \"龙(long2)楼(lou2)凤(feng4)阁(ge2)\"}]',
 basic_define_list='[{\"pinyin\": \"lóng lóu fèng gé\", \"definition\": [\"意思是帝王的宫殿、楼阁。喻指封建统治者的巢穴。\"]}]',
 detail_define_list='[\"<dl><dt><a>龙楼凤阁 [lóng lóu fèng gé]</a></dt><dd><ol><li><p>龙楼凤阁，汉语成语，拼音是lóng lóu fèng gé，意思是帝王的宫殿、楼阁。喻指封建统治者的巢穴。出自元·马致远《拨不断》。</p></li></ol></dd></dl>\"]'
 where id=15532;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"dǐng chéng lóng qù\", \"sug\": \"鼎(ding3)成(cheng2)龙(long2)去(qu4)\"}]',
 basic_define_list='[{\"pinyin\": \"dǐng chéng lóng qù\", \"definition\": [\"意思是指帝王去世。\"]}]',
 detail_define_list='[\"<dl><dt><a>鼎成龙去 [dǐng chéng lóng qù]</a></dt><dd><ol><li><p>鼎成龙去，汉语成语，拼音是dǐng chéng lóng qù，意思是指帝王去世。出自《史记》。</p></li></ol></dd></dl>\"]'
 where id=15648;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"shǔ rù niú jiǎo\", \"sug\": \"鼠(shu3)入(ru4)牛(niu2)角(jiao3)\"}]',
 basic_define_list='[{\"pinyin\": \"shǔ rù niú jiǎo\", \"definition\": [\"意思是比喻势力愈来愈小。\"]}]',
 detail_define_list='[\"<dl><dt><a>鼠入牛角 [shǔ rù niú jiǎo]</a></dt><dd><ol><li><p>鼠入牛角，汉语成语，拼音是shǔ rù niú jiǎo，意思是比喻势力愈来愈小。出自《新五代史·南汉世家·刘玢》。</p></li></ol></dd></dl>\"]'
 where id=15690;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"sì mǎ yǎng mò\", \"sug\": \"驷(si4)马(ma3)仰(yang3)秣(mo4)\"}]',
 basic_define_list='[{\"pinyin\": \"sì mǎ yǎng mò\", \"definition\": [\"意思是驾车的马驻足仰首，谛听琴声。形容音乐美妙动听。\"]}]',
 detail_define_list='[\"<dl><dt><a>驷马仰秣 [sì mǎ yǎng mò]</a></dt><dd><ol><li><p>驷马仰秣，汉语成语，拼音是sì mǎ yǎng mò，意思是驾车的马驻足仰首，谛听琴声。形容音乐美妙动听。出自《荀子·劝学》。</p></li></ol></dd></dl>\"]'
 where id=15741;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"guāng chē jùn mǎ\", \"sug\": \"光(guang1)车(che1)骏(jun4)马(ma3)\"}]',
 basic_define_list='[{\"pinyin\": \"guāng chē jùn mǎ\", \"definition\": [\"意思是指装饰华丽的车马。\"]}]',
 detail_define_list='[\"<dl><dt><a>光车骏马 [guāng chē jùn mǎ]</a></dt><dd><ol><li><p>光车骏马，汉语成语，拼音是guāng chē jùn mǎ，意思是指装饰华丽的车马。出自《百年歌》。</p></li></ol></dd></dl>\"]'
 where id=15749;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"quǎn mǎ zhī lì\", \"sug\": \"犬(quan3)马(ma3)之(zhi1)力(li4)\"}]',
 basic_define_list='[{\"pinyin\": \"quǎn mǎ zhī lì\", \"definition\": [\"表示心甘情愿受人驱使，为人效劳。\"]}]',
 detail_define_list='[\"<dl><dt><a>犬马之力 [quǎn mǎ zhī lì]</a></dt><dd><ol><li><p>犬马之力，汉语成语，拼音：quǎn mǎ zhī lì，意思是愿象犬马那样为君主奔走效力。表示心甘情愿受人驱使，为人效劳。</p></li></ol></dd></dl>\"]'
 where id=15804;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"lì gē mò mǎ\", \"sug\": \"砺(li4)戈(ge1)秣(mo4)马(ma3)\"}]',
 basic_define_list='[{\"pinyin\": \"lì gē mò mǎ\", \"definition\": [\"比喻作好战斗准备。\"]}]',
 detail_define_list='[\"<dl><dt><a>砺戈秣马 [lì gē mò mǎ]</a></dt><dd><ol><li><p>砺戈秣马，汉语成语，拼音是 lì gē mò mǎ，意思是指磨戈喂马。比喻作好战斗准备。出自《旧唐书·刘仁轨传》。</p></li></ol></dd></dl>\"]'
 where id=15894;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"fàng mǎ huá yáng\", \"sug\": \"放(fang4)马(ma3)华(hua2)阳(yang2)\"}]',
 basic_define_list='[{\"pinyin\": \"fàng mǎ huá yáng\", \"definition\": [\"意思是指不再用兵。\"]}]',
 detail_define_list='[\"<dl><dt><a>放马华阳 [fàng mǎ huá yáng]</a></dt><dd><ol><li><p>放马华阳，汉语成语，拼音是fàng mǎ huá yáng，意思是指不再用兵。出自《尚书·武成》。</p></li></ol></dd></dl>\"]'
 where id=15902;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"chē mǎ tián mén\", \"sug\": \"车(che1)马(ma3)填(tian2)门(men2)\"}]',
 basic_define_list='[{\"pinyin\": \"chē mǎ tián mén\", \"definition\": [\"意思是车子布满门庭，比喻宾客很多，同“车马盈门”。\"]}]',
 detail_define_list='[\"<dl><dt><a>车马填门 [chē mǎ tián mén]</a></dt><dd><ol><li><p>车马填门，汉语成语，拼音是chē mǎ tián mén，意思是车子布满门庭，比喻宾客很多，同“车马盈门”。出自《北史·拓跋深传》。</p></li></ol></dd></dl>\"]'
 where id=15978;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"bǐ dǐ lóng shé\", \"sug\": \"笔(bi3)底(di3)龙(long2)蛇(she2)\"}]',
 basic_define_list='[{\"pinyin\": \"bǐ dǐ lóng shé\", \"definition\": [\"意思是指人的书法或文笔。\"]}]',
 detail_define_list='[\"<dl><dt><a>笔底龙蛇 [bǐ dǐ lóng shé]</a></dt><dd><ol><li><p>笔底龙蛇，汉语成语，拼音是bǐ dǐ lóng shé，意思是指人的书法或文笔。出自明·兰陵笑笑生《金瓶梅词话》。</p></li></ol></dd></dl>\"]'
 where id=16090;
 
 */


/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"yú chén yàn miǎo\", \"sug\": \"鱼(yu2)沉(chen2)雁(yan4)渺(miao3)\"}]',
 basic_define_list='[{\"pinyin\": \"yú chén yàn miǎo\", \"definition\": [\"意思是比喻书信不通，音信断绝。\"]}]',
 detail_define_list='[\"<dl><dt><a>鱼沉雁渺 [yú chén yàn miǎo]</a></dt><dd><ol><li><p>鱼沉雁渺，汉语成语，拼音是yú chén yàn miǎo，意思是比喻书信不通，音信断绝。出自《花月痕》。</p></li></ol></dd></dl>\"]'
 where id=16255;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"yú shuǐ shēn qíng\", \"sug\": \"鱼(yu2)水(shui3)深(shen1)情(qing2)\"}]',
 basic_define_list='[{\"pinyin\": \"yú shuǐ shēn qíng\", \"definition\": [\"意思指像鱼儿离不开水那样，关系密切，感情深厚。\"]}]',
 detail_define_list='[\"<dl><dt><a>鱼水深情 [yú shuǐ shēn qíng]</a></dt><dd><ol><li><p>鱼水深情，汉语成语，拼音是yú shuǐ shēn qíng，意思指像鱼儿离不开水那样，关系密切，感情深厚。出自《蓬莱先生传》。</p></li></ol></dd></dl>\"]'
 where id=16261;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"shì cái rú mìng\", \"sug\": \"视(shi4)财(cai2)如(ru2)命(ming4)\"}]',
 basic_define_list='[{\"pinyin\": \"shì cái rú mìng\", \"definition\": [\"意思是形容人的吝啬，把钱财看得有如生命一般。\"]}]',
 detail_define_list='[\"<dl><dt><a>视财如命 [shì cái rú mìng]</a></dt><dd><ol><li><p>视财如命，汉语成语，拼音是shì cái rú mìng，意思是形容人的吝啬，把钱财看得有如生命一般。出自《洪秀全演义》。</p></li></ol></dd></dl>\"]'
 where id=16321;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"fàng yú rù hǎi\", \"sug\": \"放(fang4)鱼(yu2)入(ru4)海(hai3)\"}]',
 basic_define_list='[{\"pinyin\": \"fàng yú rù hǎi\", \"definition\": [\"比喻放走敌人，留下祸根。\"]}]',
 detail_define_list='[\"<dl><dt><a>放鱼入海 [fàng yú rù hǎi]</a></dt><dd><ol><li><p>指自留祸根，比喻放走敌人，留下祸根。可作谓语、定语、宾语。</p></li></ol></dd></dl>\"]'
 where id=16369;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"yī zǐ yāo jīn\", \"sug\": \"衣(yi1)紫(zi3)腰(yao1)金(jin1)\"}]',
 basic_define_list='[{\"pinyin\": \"yī zǐ yāo jīn\", \"definition\": [\"意思是大官装束，亦指做大官。\"]}]',
 detail_define_list='[\"<dl><dt><a>衣紫腰金 [yī zǐ yāo jīn]</a></dt><dd><ol><li><p>衣紫腰金，汉语成语，拼音是yī zǐ yāo jīn，意思是大官装束，亦指做大官。出自《灯下闲谈·掠剩大夫》。</p></li></ol></dd></dl>\"]'
 where id=16427;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"shǐ hǔ chuán é\", \"sug\": \"豕(shi3)虎(hu3)传(chuan2)讹(e2)\"}]',
 basic_define_list='[{\"pinyin\": \"shǐ hǔ chuán é\", \"definition\": [\"意思是书籍传写或刊印中的文字错误。\"]}]',
 detail_define_list='[\"<dl><dt><a>豕虎传讹 [shǐ hǔ chuán é]</a></dt><dd><ol><li><p>豕虎传讹，汉语成语，拼音是shǐ hǔ chuán é，意思是书籍传写或刊印中的文字错误。出自清·钱大昕《〈甘二史考异〉序》。</p></li></ol></dd></dl>\"]'
 where id=16454;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"yú shū yàn tiě\", \"sug\": \"鱼(yu2)书(shu1)雁(yan4)帖(tie3)\"}]',
 basic_define_list='[{\"pinyin\": \"yú shū yàn tiě\", \"definition\": [\"意思是泛指书信。\"]}]',
 detail_define_list='[\"<dl><dt><a>鱼书雁帖 [yú shū yàn tiě]</a></dt><dd><ol><li><p>鱼书雁帖是一个汉语成语，拼音是yú shū yàn tiě，意思是泛指书信。出自：《绛都春序·题情》。</p></li></ol></dd></dl>\"]'
 where id=16463;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"hún shuǐ mō yú\", \"sug\": \"混(hun2)水(shui3)摸(mo1)鱼(yu2)\"}]',
 basic_define_list='[{\"pinyin\": \"hún shuǐ mō yú\", \"definition\": [\"比喻趁混乱的时候从中捞取不正当的利益。\"]}]',
 detail_define_list='[\"<dl><dt><a>混水摸鱼 [hún shuǐ mō yú]</a></dt><dd><ol><li><p>混水摸鱼是一个汉语成语，最早出自《三十六计》。</p><p>该成语的意思是比喻趁混乱的时候从中捞取不正当的利益。在句子中一般作作谓语、定语。</p></li></ol></dd></dl>\"]'
 where id=16486;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"huáng fā tái bèi\", \"sug\": \"黄(huang2)发(fa1)鲐(tai2)背(bei4)\"}]',
 basic_define_list='[{\"pinyin\": \"huáng fā tái bèi\", \"definition\": [\"指长寿老人，也泛指老年人。\"]}]',
 detail_define_list='[\"<dl><dt><a>黄发鲐背 [huáng fā tái bèi]</a></dt><dd><ol><li><p>黄发：老年人头发由白转黄，后常指老年人。鲐背；鲐鱼背上有黑斑，老人背上也有，因常借指老人。指长寿老人，也泛指老年人。亦作“黄发台背”、“黄耈台背”、“鲐背苍耈”。</p></li></ol></dd></dl>\"]'
 where id=16512;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"mǎ rú yóu yú\", \"sug\": \"马(ma3)如(ru2)游(you2)鱼(yu2)\"}]',
 basic_define_list='[{\"pinyin\": \"mǎ rú yóu yú\", \"definition\": [\"形容人马熙熙攘攘的景象，同“马如游龙”。\"]}]',
 detail_define_list='[\"<dl><dt><a>马如游鱼 [mǎ rú yóu yú]</a></dt><dd><ol><li><p>马如游鱼，汉语成语，拼音是mǎ rú yóu yú，意思是形容人马熙熙攘攘的景象，同“马如游龙”。出自《初学记》。</p></li></ol></dd></dl>\"]'
 where id=16532;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"zàng shēn yū fù\", \"sug\": \"葬(zang4)身(shen1)鱼(yu1)腹(fu4)\"}]',
 basic_define_list='[{\"pinyin\": \"zàng shēn yū fù\", \"definition\": [\"尸体为鱼所食，意思是淹死于水中。\"]}]',
 detail_define_list='[\"<dl><dt><a>葬身鱼腹 [zàng shēn yū fù]</a></dt><dd><ol><li><p>葬身鱼腹，汉语成语，拼音是zàng shēn yú fù，意思是尸体为鱼所食，意思是淹死于水中。出自《渔父》。</p></li></ol></dd></dl>\"]'
 where id=16607;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"dú zhàn áo tóu\", \"sug\": \"独(du2)占(zhan4)鳌(ao2)头(tou2)\"}]',
 basic_define_list='[{\"pinyin\": \"dú zhàn áo tóu\", \"definition\": [\"原指科举时代考试中了状元。现泛指占首位或第一名。\"]}]',
 detail_define_list='[\"<dl><dt><a>独占鳌头 [dú zhàn áo tóu]</a></dt><dd><ol><li><p>独占鳌头是一个汉语成语，读音为dú zhàn áo tóu，原指科举时代考试中了状元。现泛指占首位或第一名。出自元·无名氏《陈州粜米》楔子。</p></li></ol></dd></dl>\"]'
 where id=16641;
 
 */

/*
 update `laixue_course`.`word` set pinyin_list='[{\"pinyin\": \"lòu wǎng zhī yú\", \"sug\": \"漏(lou4)网(wang3)之(zhi1)鱼(yu2)\"}]',
 basic_define_list='[{\"pinyin\": \"lòu wǎng zhī yú\", \"definition\": [\"指从网眼里漏出去的鱼，常比喻侥幸逃脱的敌人和罪犯。\"]}]',
 detail_define_list='[\"<dl><dt><a>漏网之鱼 [lòu wǎng zhī yú]</a></dt><dd><ol><li><p>漏网之鱼是一个成语，最早出自西汉·司马迁《史记·酷吏列传序》</p><p>该成语指从网眼里漏出去的鱼，常比喻侥幸逃脱的敌人和罪犯。含贬义，漏网之鱼多作宾语，也作主语</p></li></ol></dd></dl>\"]'
 where id=16647;
 
 */
