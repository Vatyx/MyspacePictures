//
//  PostsViewController.swift
//  MyspacePictures
//
//  Created by MediaLab on 2/26/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit
import Parse

class PostsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post]!
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 480
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Post.fetchPostsWithCompletion { (posts: [PFObject]?, error: NSError?) -> () in
            if error == nil{
                self.posts = Post.createPostArray(posts!)
                self.tableView.reloadData()
            } else {
                print("No posts found")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        
        cell.post = posts[indexPath.row]
        
        let tap1 = UITapGestureRecognizer(target: self, action: "viewProfile:")
        let tap2 = UITapGestureRecognizer(target: self, action: "viewProfile:")
        
        cell.profileImage.userInteractionEnabled = true
        cell.profileImage.tag = indexPath.row
        cell.profileImage.addGestureRecognizer(tap1)
        
        cell.usernameLabel.userInteractionEnabled = true
        cell.usernameLabel.tag = indexPath.row
        cell.usernameLabel.addGestureRecognizer(tap2)
        
        return cell
    }
    
    func viewProfile(tap: UITapGestureRecognizer) {
        if tap.state != .Ended{
            return
        }
        
        let index = tap.view?.tag
        if let index = index{
            let post = self.posts?[index]
            let user = post!.author
            self.performSegueWithIdentifier("tempSegue", sender: user)
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let user = sender as? PFUser{
            if let tempUserViewController = segue.destinationViewController as? TempUserViewController{
                print(user.username!)
                tempUserViewController.username = user.username!
                //userProfileViewController.usernameLabel.text = user.username
                
                Post.fetchProfilePictureWithCompletion ((PFUser.currentUser()?.username)!) { (query: [PFObject]?, error: NSError?) -> () in
                    if error == nil && query!.count != 0{
                        let picture = query?.first!
                        if let file = picture!["media"] {
                            file.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                                if error == nil {
                                    tempUserViewController.profilePictureImage.image = UIImage(data: data!)!
                                } else {
                                    print(error?.localizedDescription)
                                }
                            })
                        } else {
                            tempUserViewController.profilePictureImage.image = UIImage(named: "default")
                        }
                    } else {
                        tempUserViewController.profilePictureImage.image = UIImage(named: "default")
                    }
                }

            }
        }
    }
    

}
