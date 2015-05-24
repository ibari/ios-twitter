//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Ian on 5/24/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweetTextView: UITextView!
  @IBOutlet weak var tweetButton: UIButton!
  
  var user: User! {
    didSet {
      profileImageView.setImageWithURL(User.currentUser!.profileImageURL!)
      nameLabel.text = User.currentUser!.name
      screenNameLabel.text = "@\(User.currentUser!.screenName!)"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tweetTextView.layer.cornerRadius = 3
    tweetTextView.clipsToBounds = true
    
    tweetButton.layer.cornerRadius = 3
    tweetButton.clipsToBounds = true
    
    tweetTextView.delegate = self
    
    let tapRecognizer = UITapGestureRecognizer()
    tapRecognizer.addTarget(self, action: "didTapView")
    self.view.addGestureRecognizer(tapRecognizer)
    
    tweetButton.addTarget(self, action: "onTweet", forControlEvents: UIControlEvents.TouchUpInside)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func onCancel(sender: AnyObject) {
    self.pushTweetsViewController()
  }
  
  func onTweet() {
    TwitterClient.sharedInstance.updateWithParams(["status" : tweetTextView.text], completion: { (status, error) -> () in
      self.tweetTextView.resignFirstResponder()
      self.pushTweetsViewController()
    })
  }
  
  func pushTweetsViewController() {
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    var tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as! TweetsViewController
    
    self.navigationController?.pushViewController(tweetsViewController, animated: true)
  }
  
  func didTapView(){
    self.view.endEditing(true)
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

extension ComposeViewController: UITextViewDelegate {
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      self.tweetTextView.resignFirstResponder()
      
      return false
    }
    
    return true
  }
}
