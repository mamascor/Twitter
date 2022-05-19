//
//  HeaderViewModel.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/14/22.
//

import UIKit

//opening an enum yo see check my header cells
enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
                //returns the title base on the case
            case .tweets: return "Tweets"
            case .replies: return "Tweets & Replies"
            case .likes: return "Likes"
        }
    }
    
    
}


struct ProfileHeaderViewModel{
    
    
    //this is the model that my usersprofile follows
    
   // starting with the user
    private let user: User
    
    
    //creating strings base on the following count
    var followersString: NSAttributedString?{
        return attributedText(withValue: user.followers, text: "Followers")
    }
    var followingString: NSAttributedString?{
        return attributedText(withValue: user.following, text: "Following")
    }
    
    //on my profile header depending if the user is current user will return one of the following strings

    
    
    //initializing a user
    init(user: User){
        self.user = user
    }
    
    
    //custom follwing text
    
   fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString{
        let attributedTitle=NSMutableAttributedString(string: "\(value)",
                                                      attributes: [NSAttributedString.Key.font:
                                                                    UIFont.boldSystemFont (ofSize: 14)])
        attributedTitle.append (NSAttributedString(string:" \(text)",
                                                   attributes: [NSAttributedString.Key.font:
                                                                    UIFont.systemFont (ofSize: 14),
                                                                NSAttributedString.Key.foregroundColor:
                                                                    UIColor.lightGray]))
        return attributedTitle
        
    }
}
