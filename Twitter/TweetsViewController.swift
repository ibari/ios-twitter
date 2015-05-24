//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ian on 5/21/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var tweets: [Tweet]?
  var refreshControl: UIRefreshControl!
  let tweetSegueIdentifier = "ShowTweetSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
    
    TwitterClient.sharedInstance.homeTimelineWithParams(["count" : 20], completion: { (tweets, error) -> () in
      self.tweets = tweets
      self.tableView.reloadData()
      
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure
    )
  }
  
  func onRefresh() {
    delay(2, closure: {
      self.refreshControl.endRefreshing()
    })
  }

  @IBAction func onLogout(sender: AnyObject) {
    User.currentUser?.logout()
  }
  
  @IBAction func onCompose(sender: AnyObject) {
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    var composeViewController = storyboard.instantiateViewControllerWithIdentifier("ComposeViewController") as! ComposeViewController
    
    self.navigationController?.pushViewController(composeViewController, animated: true)
  }
  
  // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == tweetSegueIdentifier {
      if let navigation = segue.destinationViewController as? UINavigationController {
        if let destination = navigation.viewControllers.first as? TweetViewController {
          if let indexPath = tableView.indexPathForSelectedRow() {
            // didSelectRowAtIndexPath event
            destination.tweet = tweets![indexPath.row]
          } else if let indexPath = tableView.indexPathForCell((sender as? TweetCell)!) {
            // reply button event
            destination.isReply = true
            destination.tweet = tweets![indexPath.row]
          }
        }
      }
    }
  }
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
    
    cell.tweet = tweets![indexPath.row]
    cell.delegate = self

    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tweets != nil {
      return tweets!.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier(tweetSegueIdentifier, sender: nil)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

extension TweetsViewController: TweetCellDelegate {
  func tweetCell(tweetCell: TweetCell) {
    self.performSegueWithIdentifier(tweetSegueIdentifier, sender: tweetCell)
  }
  
  func tweetCell(tweetCell: TweetCell, buttonTouched button: UIButton, didRetweetStatus statusId: Int) {
    TwitterClient.sharedInstance.retweetWithParams(statusId, params: nil, completion: { (status, error) -> () in
      if error == nil {
        button.setImage(UIImage(named: "retweet_on"), forState: .Normal)
      }
    })
  }
  
  func tweetCell(tweetCell: TweetCell, buttonTouched button: UIButton, didFavoriteStatus statusId: Int) {
    TwitterClient.sharedInstance.favoritesWithParams(["id" : statusId], completion: { (status, error) -> () in
      if error == nil {
        button.setImage(UIImage(named: "favorite_on"), forState: .Normal)
      }
    })
  }
}
