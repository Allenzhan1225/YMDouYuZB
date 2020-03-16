//
//  YMCycleView.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/16.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

let kCycleViewW = UIScreen.main.bounds.width
let kCycleCellReuseId = "kCycleCellReuseId"

class YMCycleView: UIView {

    var cycleTimer : Timer?
    
    private lazy var collectionView : UICollectionView = { [weak self] in
//        guard let self = self else {return UICollectionView()}
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self?.bounds.width ?? kCycleViewW, height: self?.bounds.height ?? 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self?.bounds ?? CGRect.zero, collectionViewLayout: layout);
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(YMCycleViewCell.self, forCellWithReuseIdentifier:kCycleCellReuseId)
        return collectionView
    }()
    
    private lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: self.bounds.width - 120, y: self.bounds.height - 30, width: 120, height: 30))
        pageControl.pageIndicatorTintColor = .red
        pageControl.numberOfPages = 6
        pageControl.currentPageIndicatorTintColor = .yellow
        return pageControl
    }()

    // MARK:- 设置数据源
    var cycleSources : [String]? {
        didSet{
            pageControl.numberOfPages = cycleSources?.count ?? 0
            
            let indexPath = IndexPath(item: (cycleSources?.count ?? 0) * 10, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            collectionView.reloadData()
            // 4.添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK:- 设置UI
extension YMCycleView {
    private func setupUI(){
        addSubview(collectionView)
        addSubview(pageControl)
    }
}


// MARK:-UICollectionView  代理
extension YMCycleView : UICollectionViewDataSource , UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleSources?.count ?? 0) * 10000
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellReuseId, for: indexPath) as! YMCycleViewCell
        cell.imageUrl = cycleSources?[indexPath.row % (cycleSources?.count ?? 1)]
        cell.backgroundColor = .purple
        return cell
    }
    
}


// MARK:- UIScrollViewDelegate
extension YMCycleView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleSources?.count ?? 1)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}

// MARK:- 定时器
extension YMCycleView {
    func addCycleTimer()  {
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollNext), userInfo: nil, repeats: true)
        RunLoop.current.add(cycleTimer!, forMode: .common)
    }
    
    func removeCycleTimer(){
        cycleTimer?.invalidate() // 从运行循环中移除
        cycleTimer = nil
    }
    
    @objc func scrollNext(){
        // 1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        // 2.滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
