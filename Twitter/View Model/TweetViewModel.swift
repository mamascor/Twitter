//
//  TweetViewModel.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/13/22.
//

import Foundation
import UIKit

struct TweetViewModel {
    
    //MARK: -  Properties
    
    let tweet: Tweet
    let user: User
    
    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "0m"
    }
    
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
    
        
        title.append(NSAttributedString(string: " ∙ \(timeStamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
       
        return title
        
        
    }
    
    //MARK: - LifeCycle
    init(tweet: Tweet){
        self.tweet = tweet
        self.user = tweet.user
    }
    
    
    
}
