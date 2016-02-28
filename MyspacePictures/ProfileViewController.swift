//
//  ProfileViewController.swift
//  MyspacePictures
//
//  Created by MediaLab on 2/26/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = PFUser.currentUser()?.username
        
        Post.fetchProfilePictureWithCompletion ((PFUser.currentUser()?.username)!) { (query: [PFObject]?, error: NSError?) -> () in
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
                    print("No profile picture 1")
                }
            } else {
                print("No profile picture 2")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeProfilePictureAction(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let newSize = CGSize(width: 320, height: 320)
            profileImage.image = self.resize(editedImage, newSize: newSize)
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            Post.postUserProfileImage((PFUser.currentUser()?.username)!, image: profileImage.image) { (flag: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("Profile Image Change Successfully!")
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    
                    let alertController = UIAlertController(title: "Changed!", message: "Your profile image has been changed successfully", preferredStyle: UIAlertControllerStyle.Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else {
                    print("error occurred \(error?.localizedDescription)")
                }
            }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName("userDidLogoutNotification", object: nil)
            } else {
                
            }
        }
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
