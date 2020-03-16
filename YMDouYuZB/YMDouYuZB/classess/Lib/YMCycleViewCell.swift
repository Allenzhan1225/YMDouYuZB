//
//  YMCycleViewCell.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/16.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit
import Kingfisher
class YMCycleViewCell: UICollectionViewCell {
    
    private lazy var imageView : UIImageView = {[weak self] in
        let imageView = UIImageView(frame: self?.bounds ?? CGRect.zero)
        imageView.image = UIImage(named: "Img_default")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    var imageUrl : String?{
        didSet{
            imageView.kf.setImage(with:URL(string: imageUrl ?? ""))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI
extension YMCycleViewCell{
    private func setupUI() {
        addSubview(imageView)
    }
}
