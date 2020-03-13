//
//  RecommendReusableHeaderView.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/12.
//  Copyright © 2020 占益民. All rights reserved.
//
 
import UIKit

class RecommendReusableHeaderView: UICollectionReusableView {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK:- 模型属性
    var group : AnchorGroupModel?{
        didSet{
            imageView.image = UIImage(named: group?.icon_name ?? "")
            titleLb.text = group?.tag_name
        }
    }
    
//    func bindModel(model:AnchorGroupModel) {
//        imgView.image = UIImage(named: model.icon_name)
//        titleLabel.text = model.tag_name
//    }
    
}
