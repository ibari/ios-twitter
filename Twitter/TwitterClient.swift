//
//  TwitterClient.swift
//  Twitter
//
//  Created by Ian on 5/20/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

let twitterConsumerKey = "tNkZM9C17HR59Fo2TS9lznsQU"
let twitterConsumerSecret = "euKZq8ENnl2qBK2J9rakf1RERJgcYX8oZIG7ihouHfBJ96IveO"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
  var loginCompletion: ((user: User?, error: NSError?) -> ())?
  
  class var sharedInstance: TwitterClient {
    struct Static {
      static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    }
    
    return Static.instance
  }
  
  func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
    GET("1.1/statuses/home_timeline.json", parameters: params
      , success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        var tweets = Tweet.tweetWithArray(response as! [NSDictionary])
        
        completion(tweets: tweets, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        println("Failed to get timeline")
        completion(tweets: nil, error: error)
    })
  }
  
  func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
    loginCompletion = completion
    
    // fetch request token and redirect to authorization view
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterclient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
      println("Got the request token")
      var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
      
      UIApplication.sharedApplication().openURL(authURL!)
      }) { (error: NSError!) -> Void in
        println("Failed to get request token")
        self.loginCompletion?(user: nil, error: error)
    }
  }
  
  func openURL(url: NSURL) {
    fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
        println("Got the access token")
        TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
      
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil
          , success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var user = User(dictionary: response as! NSDictionary)
            User.currentUser = user
            println("user: \(user.name)")
            self.loginCompletion?(user: user, error: nil)
          }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Failed to get current user")
            self.loginCompletion?(user: nil, error: error)
        })
      }) { (error: NSError!) -> Void in
        println("Failed to receive access token")
        self.loginCompletion?(user: nil, error: error)
    }
  }
}
