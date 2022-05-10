//
//  User.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/9/22.
//

import Foundation


struct User{
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl : URL?
    let uid: String
    
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        if let profileImageUrlString = dictionary["profile_url"] as? String {
            guard let url =  URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
        
    }
    
}
