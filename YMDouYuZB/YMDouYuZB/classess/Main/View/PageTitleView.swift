//
//  PageTitleView.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/10.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

// MARK:-代理定义协议
protocol PageTitleViewDelegate : class {
    //seletedIndex 外部参数
    //index 内部参数
    func pageTitleView(titleView:PageTitleView ,seletedIndex index: Int)
}


// MARK:- 定义c常量
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectedColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)
private let kScrollLineH : CGFloat = 2

 // MARK:-自定义类
class PageTitleView: UIView {
    //MARK:- 定义属性
    weak var delegate : PageTitleViewDelegate?
    private var titles : [String]
    private var currentIndex : Int = 0
    private var titleLabels : [UILabel] = [UILabel]()
    private var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = .orange
        return scrollLine
    }()
    
    //MARK:-自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        
        //设置UI
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

 //MARK: - 设置UI界面
extension PageTitleView{
    private func setupUI (){
        //添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //添加label
        setupTitleLabels()
        
        //设置底线和滚动条
        setBottomMenuAndScrollLine()
        
     }
    
    //添加label
    private func setupTitleLabels(){
        let labelW = frame.width / CGFloat(titles.count)
        let labelH = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        for (index,title) in titles.enumerated(){
            let label = UILabel()
            
            label.text = title
            label.tag = index
            label.textColor = UIColor(r: kNormalColor.0, g:  kNormalColor.1, b:  kNormalColor.2)
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
        
            //添加点击手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.categoryTap(tapGes:)))
            label.addGestureRecognizer(tapGes)
            let labelX = CGFloat(index) * labelW
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            scrollView.addSubview(label)
            titleLabels.append(label)
        }
    }
    
    //设置底线和滚动条
    private func setBottomMenuAndScrollLine(){
        //设置底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lightGray
        let bottomLineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - bottomLineH, width: kScreenW, height: bottomLineH)
        addSubview(bottomLine)
        
        scrollView.addSubview(scrollLine)
        guard let label = titleLabels.first else{return }
        label.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        scrollLine.frame = CGRect(x: label.frame.origin.x, y: frame.height - kScrollLineH, width: label.frame.width, height: kScrollLineH)
    }
}


// MARK:- label 点击
extension PageTitleView{
    @objc private func categoryTap(tapGes : UITapGestureRecognizer){
        //1.获取当前lable的下标值
        guard let currentLabel = tapGes.view as? UILabel else {return }
        //2.获取之前的label
        let oldLabel =  titleLabels[currentIndex]
        
        //3.切换颜色
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g:  kNormalColor.1, b:  kNormalColor.2)
        
        //4.滚动条frame 修改
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = currentLabel.frame.origin.x
        }
        currentIndex = currentLabel.tag
        print("label 点击\(currentIndex)")
        
        //通知代理
        delegate?.pageTitleView(titleView: self, seletedIndex: currentIndex)
        
    }
}


// MARK:- 外部公开方法
extension PageTitleView {
    func setTitleWithProgress(progrerss: CGFloat, sourceIndex :Int, targetIndex: Int){
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //处理底部滑块逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progrerss
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        //颜色渐变处理(复杂)
        //1.取出变化的范围
        let colorDelta = (kSelectedColor.0 - kNormalColor.0,kSelectedColor.1 - kNormalColor.1,kSelectedColor.2 - kNormalColor.2)
        //2.变化soucreLabel
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDelta.0 * progrerss, g: kSelectedColor.1 - colorDelta.1 * progrerss, b: kSelectedColor.2 - colorDelta.2 * progrerss)
        //3.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progrerss, g: kNormalColor.1 + colorDelta.1 * progrerss, b: kNormalColor.2 + colorDelta.2 * progrerss)
        
        //4.记录最新的index
        currentIndex = targetIndex
    }
}
