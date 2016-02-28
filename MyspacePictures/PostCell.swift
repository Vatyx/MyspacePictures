//
//  PostCell.swift
//  MyspacePictures
//
//  Created by MediaLab on 2/27/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createAtLabel: UILabel!
    
    var post: Post! {
        didSet {
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
            
            Post.fetchProfilePictureWithCompletion ((post.author?.username)!) { (query: [PFObject]?, error: NSError?) -> () in
                if error == nil && query!.count != 0{
                    let picture = query?.first!
                    if let file = picture!["media"] {
                        file.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                self.profileImage.image = UIImage(data: data!)!
                            } else {
                                print(error?.localizedDescription)
                            }
                        })
                    } else {
                        self.profileImage.image = UIImage(named: "default")
                    }
                } else {
                    self.profileImage.image = UIImage(named: "default")
                }
            }
            
            caption.text = post.caption
            usernameLabel.text = post.author?.username

            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: post.createdAt!)
            
            createAtLabel.text = "\(components.month)/\(components.day)"
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
