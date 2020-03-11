//
//  PageContentView.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/10.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

protocol  PageContentViewDelegate : class {
    func pageContentView(contentView:PageContentView, progress:CGFloat ,sourceIndex:Int, targetIndex: Int)
}




private let contentCellID = "contentCellID"

class PageContentView: UIView {
    
    // MARK:-自定义属性
    private var childVcs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var currentContentOffsetX : CGFloat = 0
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    
    weak var delegate : PageContentViewDelegate?
    // MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = {[weak self] in
        //1.创建layerout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = (self?.bounds.size)!
        
        //2.创建collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)
        return collectionView
        }()
    
    // MARK:-自定义构造函数
    init(frame: CGRect,childVcs : [UIViewController], parentViewController : UIViewController?){
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        //设置UI
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI 页面
extension PageContentView {
    //设置UI页面
    private func setupUI(){
        //1.将所有子控制器添加到父控制器中
        for childVc  in childVcs {
            parentViewController?.addChild(childVc)
        }
        
        //2.添加UIColloectionView 用于在Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}


// MARK:- UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        //2.给cell设置内容
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.row]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

// MARK:- 遵守UIScrollViewDelegate
extension PageContentView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //点击切换的话，就禁止滚动
        if isForbidScrollDelegate { return }
        print("startOffsetX = \(startOffsetX)  currentOffsetX-----\(scrollView.contentOffset.x)")
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        //通知代理
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        //保存当前偏移量
        startOffsetX = scrollView.contentOffset.x
    }
}



// MARK:- 对外暴露的方法
extension PageContentView{
    //点击labels
    func  setCurrentIndex(currentIndex : Int){
        isForbidScrollDelegate = true
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
