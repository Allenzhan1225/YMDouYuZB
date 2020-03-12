//
//  RecommendController.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/11.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit


private let kNormalCellId = "kNormalCellId"
private let kSectionHaderCellId = "kNormalCellId"
private let kPrettyCellId = "kPrettyCellId"


private let margin:CGFloat = 10
private let itemW = (kScreenW - 3*margin)/2
private let itemH = itemW * 3 / 4
private let prettyItemH = itemW * 4/3
private let sectionHeaderH : CGFloat = 50

class RecommendController: UIViewController {
    
    // MARK:-懒加载
    private lazy var collectionView : UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 10)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = margin
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.headerReferenceSize = CGSize(width: kScreenW, height: sectionHeaderH)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellId)
        collectionView.register(UINib(nibName: "CollectionViewPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellId)
        collectionView.register(UINib(nibName: "RecommendReusableHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kSectionHaderCellId)
        
        collectionView.autoresizingMask = [.flexibleWidth ,.flexibleHeight]
        return collectionView
    }()
    
    
    // MARK:- 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

}

// MARK:- 设置UI
extension RecommendController {
    private func setupUI (){
        view.backgroundColor = UIColor.purple
        view.addSubview(collectionView)
    }
}


// MARK:- UICollectionViewDataSource
extension RecommendController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell!
        if indexPath.section != 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellId, for: indexPath)
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellId, for: indexPath)
        }
       

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kSectionHaderCellId, for: indexPath)
        return headerView
    }
}


// MARK:- layoutDelegate
extension RecommendController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section != 1 {
            return CGSize(width: itemW, height: itemH)
        }else{
            return CGSize(width: itemW, height: prettyItemH)
        }
    }
}
