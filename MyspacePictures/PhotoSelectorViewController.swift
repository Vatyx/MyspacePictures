//
//  PhotoSelectorViewController.swift
//  MyspacePictures
//
//  Created by MediaLab on 2/26/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit

class PhotoSelectorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var captionText: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            //let newSize = CGSize(width: 320, height: 320)
            //photoView.image = self.resize(editedImage, newSize: newSize)
            photoView.image = editedImage
    }
    
    
    
    @IBAction func selectImageAction(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func postImageAction(sender: AnyObject) {
        if photoView.image != nil {
            print("I'm posting")
            Post.postUserImage(photoView.image!, withCaption: captionText.text) { (flag: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("Image Posted Successfully!")
                    self.tabBarController?.selectedIndex = 0
                    
                    let alertController = UIAlertController(title: "Posted!", message: "Your image has been posted successfully", preferredStyle: UIAlertControllerStyle.Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else {
                    print("error occurred \(error?.localizedDescription)")
                }
            }
        }
        else {
            let alertController = UIAlertController(title: "Error", message: "Please choose an image first", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
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
