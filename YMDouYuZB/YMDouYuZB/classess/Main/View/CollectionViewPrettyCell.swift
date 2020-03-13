//
//  CollectionViewPrettyCell.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/12.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionViewPrettyCell: UICollectionViewCell {

    @IBOutlet weak var cityLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playCountLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
    }
    
    var model : AnchorModel?{
        didSet{
            
            cityLb.text = model?.anchor_city
            playCountLb.text = "\(model?.online ?? 1)"
            titleLb.text = model?.room_name
            imageView.kf.setImage(with: URL(string: model?.vertical_src ?? ""))
        }
    }

}
