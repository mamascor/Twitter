//
//  UserService.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/9/22.
//

import Foundation
import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference)-> Void)


//Fetching data from firebase database
struct UserService {
    static let shared = UserService()
    
    
    
    func fetchUser(completion: @escaping(User) -> Void) {
        //Gtting the current user uid who logged in
        guard let uid = AUTH.currentUser?.uid else { return }
        
        //Getting the information from the database
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            //getting the data as the dictionary
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    func fetchTweetUser(uid: String, completion: @escaping(User)-> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
            
            
        }
    }
    
    func fetchUsers(completion: @escaping([User])-> Void){
        
        var users = [User]()
        
        REF_USERS.observe(.childAdded) { snapshot in
            
            let uid = snapshot.key
            
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            
            
            
            let user = User(uid: uid, dictionary: dictionary)
            
            users.append(user)
            completion(users)
            
        }
    }
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)){
        guard let currentUid = AUTH.currentUser?.uid else {return}
        
        if currentUid == uid {
            print("This is the same username")
            return
        }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
        
        
        
        
        
        
    }
    
    func unfollowUser(uid: String, completion: @escaping (DatabaseCompletion)){
        
        guard let currentUid = Auth.auth().currentUser?.uid else{return}
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue{(err, ref) in
            
            REF_USER_FOLLOWERS.child (uid).child(currentUid).removeValue(completionBlock: completion)
            
        }
        
    }
    
    func checkIfUserIsFollowed(uid:String,completion:@escaping(Bool)->Void){
        
        guard let currentUid=Auth.auth().currentUser?.uid else{return}
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of:.value){snapshot in
            completion(snapshot.exists())
        }
    }
    
    
    //completion: @escaping([Tweet])-> Void
    func currentFollowing(completion: @escaping([Tweet])-> Void){
        
        var tweets = [Tweet]()
        
        guard let uid = AUTH.currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(uid).observe(.childAdded) { snapshot in
            let userTweetsID = snapshot.key
            
            print("Debug id",userTweetsID)
            
            REF_USER_TWEETS.child(userTweetsID).observe(.childAdded) { snapshot in
                
                let tweetID = snapshot.key
                
                
                REF_TWEETS.child(tweetID).observe(.value) { snapshot in
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
            
        }
        
    }
    
    func userFollowingCount(user: User,completion: @escaping([User])-> Void){
        
        let uid = user.uid
        
        var users = [User]()
        
        REF_USER_FOLLOWING.child(uid).observe(.childAdded) { snapshot in
            
            REF_USERS.child(snapshot.key).observe(.value) { snapshot in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
                
                let user = User(uid: uid, dictionary: dictionary)
                
                users.append(user)
                
                completion(users)
            }
            
            
        }
    }
    
}
