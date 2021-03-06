//
//  Tweet.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/11/22.
//

import Firebase


struct Tweet {
    let caption: String
    let tweetId: String
    let uid: String
    let likes: Int
    var timestamp: Date!
    let retweetCount: Int
    let user: User
    
    
    init(user: User,tweetId: String, dictionary: [String: Any]) {
        self.tweetId = tweetId
        self.user = user
        self.caption =  dictionary["caption"] as? String ?? ""
        self.uid =  dictionary["uid"] as? String ?? ""
        self.likes =  dictionary["likes"] as? Int ?? 0
        self.retweetCount =  dictionary["retweets"] as? Int ?? 0
        
        if let timestamp =  dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        
        
    }
}
