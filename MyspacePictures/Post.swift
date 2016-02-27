//
//  Post.swift
//  MyspacePictures
//
//  Created by MediaLab on 2/27/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    var image: UIImage?
    var caption: String?
    var author: PFUser?
    var createAt: String?
    
    init(obj: PFObject) {
        super.init()
        
        if obj["media"] != nil {
//            let file = obj["media"] as! PFFile
//            file.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
//                if error == nil {
//                    self.image = UIImage(data: data!)!
//                    print("Set the image")
//                } else {
//                    print(error?.localizedDescription)
//                }
//            })
            let file = obj["media"] as! PFFile
            do {
                try self.image = UIImage(data: file.getData())
            } catch _ {
                self.image = nil
            }
        } else {
            print("I'm in here with no image")
            image = nil
        }
        
        caption = obj["caption"] as? String
        author = obj["author"] as? PFUser
    }
    
    class func fetchPostsWithCompletion(completion completion:([PFObject]?, NSError?) -> ()) {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        //query.includeKey("media")
        //query.includeKey("caption")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completion)
    }
    
    class func createPostArray(array: [PFObject]) -> [Post] {
        var posts = [Post]()
        for obj in array {
            posts.append(Post(obj: obj))
        }
        return posts
    }
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "Post")
        
        // Add relevant fields to the object
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                media["media"] = PFFile(name: "image.png", data: imageData)
            }
        } else {
            media["media"] = nil
        }
        
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        media["caption"] = caption
        
        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
}
