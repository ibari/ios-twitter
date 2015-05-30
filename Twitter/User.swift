//
//  User.swift
//  Twitter
//
//  Created by Ian on 5/20/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
  var id: Int?
  var name: String?
  var screenName: String?
  var profileImageURL: NSURL?
  var profileBackgroundImageURL: NSURL?
  var statusesCount: Int?
  var followersCount: Int?
  var friendsCount: Int?
  var dictionary: NSDictionary?
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    id = dictionary["id"] as? Int
    name = dictionary["name"] as? String
    screenName = dictionary["screen_name"] as? String
    
    let profileImageURLString = dictionary["profile_image_url"] as? String
    if profileImageURLString != nil {
      profileImageURL = NSURL(string: profileImageURLString!)!
    } else {
      profileImageURL = nil
    }
    
    let profileBackgroundImageURLString = dictionary["profile_background_image_url"] as? String
    if profileBackgroundImageURLString != nil {
      profileBackgroundImageURL = NSURL(string: profileBackgroundImageURLString!)!
    } else {
      profileBackgroundImageURL = nil
    }
    
    statusesCount = dictionary["statuses_count"] as? Int
    followersCount = dictionary["followers_count"] as? Int
    friendsCount = dictionary["friends_count"] as? Int
  }
  
  func logout() {
    User.currentUser = nil
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    
    NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
  }
  
  class var currentUser: User? {
    get {
      if _currentUser == nil {
        var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
    
        if data != nil {
          var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
          _currentUser = User(dictionary: dictionary)
        }
      }
    
      return _currentUser
    }
    
    set(user) {
      _currentUser = user
      
      if _currentUser != nil {
        var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: nil, error: nil)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
      } else {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
      }
      
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
}


