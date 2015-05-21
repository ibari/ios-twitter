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
  class var sharedInstance: TwitterClient {
    struct Static {
      static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    }
    
    return Static.instance
  }
}
