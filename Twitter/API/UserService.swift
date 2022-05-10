//
//  UserService.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/9/22.
//

import Foundation
import Firebase

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
    
    
    
}
