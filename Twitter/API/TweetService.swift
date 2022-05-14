//
//  TweetService.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/10/22.
//

import Firebase
import Foundation


struct TweetService {
    static let shared = TweetService()
    
    //function allows user to upload tweets
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference)-> Void){
        guard let uid = AUTH.currentUser?.uid else { return }
        
        //setting the main values for the tweet
        let values: [String: Any] = ["uid": uid,
                                     "timestamp": Int(NSDate().timeIntervalSince1970),
                                     "likes": 0,
                                     "retweets" : 0,
                                     "caption" : caption
                                     
                            
                                    ]
        //adding the tweet with an auto id so that they dont repeat
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
                      
    }
    
    func fetchTweets(completion: @escaping([Tweet])-> Void){
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            let tweetID = snapshot.key
            
            guard let uid = dictionary["uid"] as? String else {return}
            
            UserService.shared.fetchTweetUser(uid: uid) { user in
                let tweet = Tweet(user: user ,tweetId: tweetID, dictionary: dictionary)
                
                tweets.append(tweet)
                
                completion(tweets)
            }
            
           
        }
        
    }
    
    
    
}


