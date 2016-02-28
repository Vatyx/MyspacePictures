//
//  SearchCell.swift
//  MyspacePictures
//
//  Created by MediaLab on 2/28/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var randomColorView: UIView!
    
    var keyword: String!
    
    var post: Post! {
        didSet {
            let longestWordRange = (post.caption! as NSString).rangeOfString(keyword)
            let attributedString = NSMutableAttributedString(string: post.caption!, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)])
            
            attributedString.setAttributes([NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : UIColor.redColor()], range: longestWordRange)
            
            
            captionLabel.attributedText = attributedString
            
            //captionLabel.text = post.caption
            usernameLabel.text = post.author?.username
            
            if let file = post.imageFile {
                file.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        self.postImage.image = UIImage(data: data!)!
                        print("Set the image")
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            }
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
