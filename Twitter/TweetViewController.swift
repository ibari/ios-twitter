//
//  TweetViewController.swift
//  Twitter
//
//  Created by Ian on 5/22/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!

  var tweet: Tweet!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    profileImageView.setImageWithURL(tweet!.user!.profileImageURL)
    nameLabel.text = tweet!.user!.name
    screenNameLabel.text = "@\(tweet!.user!.screenName!)"
    tweetTextLabel.text = tweet.text
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "HH:mm a - dd MMM YYYY"
    createdAtLabel.text = formatter.stringFromDate(tweet.createdAt!)
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
    tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onHomeButton(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
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
