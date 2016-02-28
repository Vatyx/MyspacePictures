//
//  TempUserViewController.swift
//  MyspacePictures
//
//  Created by MediaLab on 2/27/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit

class TempUserViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    var username: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = username
        let tap = UITapGestureRecognizer(target: self, action: "dismiss:")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func dismiss(tap: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: {});
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
