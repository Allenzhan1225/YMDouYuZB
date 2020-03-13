//
//  CollectionViewNormalCell.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/12.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

class CollectionViewNormalCell: UICollectionViewCell {

    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var playCountLb: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
    }
    
    var model : AnchorModel?{
        didSet{
            nameLb.text = model?.nickname
            titleLb.text = model?.room_name
            playCountLb.setTitle("\(model?.online ?? 1)", for: .normal)
            imageView.kf.setImage(with: URL(string: model?.vertical_src ?? ""))
            
        }
    }

}
