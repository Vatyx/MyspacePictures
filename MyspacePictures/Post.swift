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
    
    var imageFile: PFFile?
    var caption: String?
    var author: PFUser?
    var createdAt: NSDate?
    
    init(obj: PFObject) {
        super.init()
        
        imageFile = obj["media"] as? PFFile
        caption = obj["caption"] as? String
        author = obj["author"] as? PFUser
        createdAt = obj.createdAt
        print(createdAt)
    }
    
    class func fetchPostsWithCompletion(completion completion:([PFObject]?, NSError?) -> ()) {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completion)
    }
    
    class func fetchProfilePictureWithCompletion(username: String, withCompletion completion:([PFObject]?, NSError?) -> ()) {
        let query = PFQuery(className: "ProfilePicture")
        query.whereKey("username", equalTo: username)
        query.orderByDescending("createdAt")
        query.limit = 1
        query.findObjectsInBackgroundWithBlock(completion)

    }
    
    class func fetchSearchWithCompletion(search: String, completion:([PFObject]?, NSError?) -> ()){
        let query = PFQuery(className: "Post")
        query.whereKey("caption", containsString: search)
        query.orderByDescending("createdAt")
        query.includeKey("author")
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
    
    class func postUserProfileImage(username: String, image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        let query = PFQuery(className: "ProfilePicture")
        query.whereKey("username", equalTo: username)
        query.orderByDescending("createdAt")
        query.limit = 1
        
        query.findObjectsInBackgroundWithBlock { (query: [PFObject]?, error: NSError?) -> Void in
            if error == nil && query!.count == 0 {
                let media = PFObject(className: "ProfilePicture")
                
                if let image = image {
                    if let imageData = UIImagePNGRepresentation(image) {
                        media["media"] = PFFile(name: "image.png", data: imageData)
                    }
                } else {
                    media["media"] = nil
                }
                media["username"] = PFUser.currentUser()!.username
            
                media.saveInBackgroundWithBlock(completion)
            } else if error != nil {
                print(error?.localizedDescription)
            } else {
                if let profilePicture = query?.first! {
                    if let image = image {
                        // get image data and check if that is not nil
                        if let imageData = UIImagePNGRepresentation(image) {
                            profilePicture["media"] = PFFile(name: "image.png", data: imageData)
                            profilePicture.saveInBackgroundWithBlock(completion)
                        }
                    }
                }
            }
        }
    }
}
