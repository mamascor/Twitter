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
        
        let ref = REF_TWEETS.childByAutoId()
        
        //adding the tweet with an auto id so that they dont repeat
        ref.updateChildValues(values){ (error, ref) in
            guard let tweetID = ref.key else {return}
            
            REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock:completion)
                                                              
                                            
        }
                      
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
                tweets.sort(by: {$0.timestamp > $1.timestamp})
                completion(tweets)
            }
            
           
        }
        
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet])-> Void){
        
        var tweets = [Tweet]()
        
         let uid = user.uid 
        
        REF_USER_TWEETS.child(uid).observe(.childAdded){snapshot in
            
            let userTweetsID = snapshot.key
            
            
            REF_TWEETS.child(userTweetsID).observe(.value) { snapshot in
                
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                
                let tweet = Tweet(user: user, tweetId: userTweetsID, dictionary: dictionary)
                
                tweets.append(tweet)
                tweets.sort(by: {$0.timestamp > $1.timestamp})
                completion(tweets)
            }
            
        }

        
        
        
    }
    
    
    
}


