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
    private lazy var viewModel : RecommedViewModel = RecommedViewModel()
    
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
        //设置UI
        setupUI()
        //发送网络请求
        loadData()
//        NetworkTools.requestData(type: MethodType.get, URLString: "http://httpbin.org/get") { (responseObj) in
//             print(responseObj)
//        }
//
//        NetworkTools.requestData(type: MethodType.post, URLString: "http://httpbin.org/post") { (responseObj) in
//             print(responseObj)
//        }
        
    }

}

// MARK:- 设置UI
extension RecommendController {
    private func setupUI (){
        view.backgroundColor = UIColor.purple
        view.addSubview(collectionView)
    }
}


// MARK:- 网络请求
extension  RecommendController {
    private func loadData(){
        viewModel.requestData {[weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK:- UICollectionViewDataSource
extension RecommendController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = viewModel.anchorGroups[section]
        return group.anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell = UICollectionViewCell()
        let group = viewModel.anchorGroups[indexPath.section]
        let anchorModel = group.anchors[indexPath.row]
        if indexPath.section == 1 {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellId, for: indexPath) as! CollectionViewPrettyCell
            cell.model = anchorModel
            return cell
        }else{
           let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellId, for: indexPath) as! CollectionViewNormalCell
             cell.model = anchorModel
            return cell
        }
       

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kSectionHaderCellId, for: indexPath) as! RecommendReusableHeaderView
                headerView.group =   viewModel.anchorGroups[indexPath.section]
                return headerView
        }
        return UICollectionReusableView()
    }
}


// MARK:- layoutDelegate
extension RecommendController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: itemW, height: prettyItemH)
        }else{
            return CGSize(width: itemW, height: itemH)
        }
    }
}
