//
//  ViewController.swift
//  Twitter
//
//  Created by Ian on 5/20/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onLogin(sender: AnyObject) {
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterclient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
      println("Got the request token")
      var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
      
      UIApplication.sharedApplication().openURL(authURL!)
      }) { (error: NSError!) -> Void in
      println("Failed to get request token")
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
