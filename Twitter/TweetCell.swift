//
//  TweetCell.swift
//  Twitter
//
//  Created by Ian on 5/21/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  
  var tweet: Tweet! {
    didSet {
      profileImageView.setImageWithURL(tweet.user!.profileImageURL)
      nameLabel.text = tweet.user!.name
      screenNameLabel.text = tweet.user?.screenName
      createdAtLabel.text = tweet.createdAtString
      tweetTextLabel.text = tweet.text
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    profileImageView.layer.cornerRadius = 5
    profileImageView.clipsToBounds = true
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
