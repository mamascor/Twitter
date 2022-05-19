//
//  User.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/9/22.
//

import Foundation
import Firebase

//this is my user model, weill help me if i need to update user information
struct User{
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl : URL?
    let uid: String
    var bio: String?
    var following: Int
    var followers: Int
    
    //checking if its the same user as the user logged in
    var isCurrentUser: Bool {return Auth.auth().currentUser?.uid == uid}
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.followers = dictionary["followers"] as? Int ?? 0
        self.following = dictionary["following"] as? Int ?? 0
        if let profileImageUrlString = dictionary["profile_url"] as? String {
            guard let url =  URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
        self.bio = dictionary["bio"] as? String
        
        
        
    }
    
}
