//
//  TweetCell.swift
//  Twitter
//
//  Created by Ian on 5/21/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  @IBOutlet weak var retweetImageView: UIImageView!
  @IBOutlet weak var retweetLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  
  var tweet: Tweet! {
    didSet {
      profileImageView.setImageWithURL(tweet.user!.profileImageURL)
      nameLabel.text = tweet.user!.name
      screenNameLabel.text = "@\(tweet.user!.screenName!)"
      tweetTextLabel.text = tweet.text
      
      let formatter = NSDateFormatter()
      formatter.dateFormat = "MMM d"
      createdAtLabel.text = formatter.stringFromDate(tweet.createdAt!)
      
      if tweet.retweeted == true {
        retweetImageView.image = UIImage(named: "retweet_on")
        retweetLabel.text = tweet.user!.name
      } else {
        retweetLabel.text = ""
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()

    profileImageView.layer.cornerRadius = 3
    profileImageView.clipsToBounds = true
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
