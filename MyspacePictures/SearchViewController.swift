//
//  SearchViewController.swift
//  MyspacePictures
//
//  Created by MediaLab on 2/28/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit
import Parse
import RandomColorSwift

class SearchViewController: UIViewController, UITableViewDataSource {

    var posts: [Post]!
    var colors: [UIColor]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        posts = nil
        searchTextField.text = nil
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! SearchCell
        
        cell.keyword = searchTextField.text!
        cell.post = posts[indexPath.row]
        
        cell.randomColorView.backgroundColor = colors[indexPath.row]
        
        return cell
    }
    
    @IBAction func searchAction(sender: AnyObject) {
        Post.fetchSearchWithCompletion(searchTextField.text!) { (posts: [PFObject]?, error: NSError?) -> () in
            if error == nil{
                self.posts = Post.createPostArray(posts!)
                self.colors = randomColorsCount(posts!.count, hue: .Blue, luminosity: .Light)
                self.tableView.reloadData()
            } else {
                print("No posts found")
            }
        }
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
