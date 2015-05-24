//
//  LoginViewController.swift
//  Twitter
//
//  Created by Ian on 5/20/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onLogin(sender: AnyObject) {
    TwitterClient.sharedInstance.loginWithCompletion() {
      (user: User?, error: NSError?) in
      if user != nil {
        self.performSegueWithIdentifier("loginSegue", sender: self)
      } else {
        //handle error
        println("Login error: \(error)")
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
