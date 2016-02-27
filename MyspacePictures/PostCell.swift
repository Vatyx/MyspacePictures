//
//  PostCell.swift
//  MyspacePictures
//
//  Created by MediaLab on 2/27/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    
    var post: Post! {
        didSet {
            postImage.image = post.image
            caption.text = post.caption
            print("image has been set")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
