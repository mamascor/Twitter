//
//  AuthService.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/7/22.
//

import Firebase
import UIKit

/*
 
 NOTES TO SELF
 ***IMPORTANT***
 This AuthService uses constacts which can be found in the Utils folder under the Constants.swift file
 
 */



//This are the register credentials that are requires to create an account
struct RegisterAuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}


//this are the login credentials that are required when login in
struct LoginAuthCredentials {
    let email: String
    let password: String
}



struct AuthService {
    
    
    static let shared = AuthService()
    
    
    //MARK: - Register user function.
    func registerUser(credentials: RegisterAuthCredentials, completion: @escaping(Error?, DatabaseReference)-> Void){
        
        
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username

        //this allows me to convert data and compress it so that firebase can handle it
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        //creating a random id to make sure its not duplicate images
        let fileName = NSUUID().uuidString
        //this is the folder that firebase is gonna show
        let storageRef = STORAGE_PROFILE_IMAGES.child(fileName)
        
        
        //putting images to they firebase cloudbase storage
        storageRef.putData(imageData) { result, error in
            print("DEBUG: Data succesfully uploaded")
            
        //downloading images url so it can be access throughout the build
        storageRef.downloadURL { url, error in
        //making sure profileimageurl is not nil
        guard let profileimageurl = url?.absoluteString else {return}
                
                
                //creating a user to make user using firebase
            AUTH.createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        return
                    }
                    
                    print("Logged in succesfully")
                    
                    guard let uid = result?.user.uid else { return }
                    
                    
                    //setting the values for the database
                let values = ["email": email, "username": username, "fullname" : fullname, "profile_url" : profileimageurl]
                
                
                   //updating the value so it can be saved in the data base. finishing the completion block in the register controller
                   REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                    
                    
                }
            }
        }
    }
    
    //MARK: - Login user function
    
    func loginUser(credentials: LoginAuthCredentials, completion: @escaping(AuthDataResult?, Error?)-> Void){
        
        let email = credentials.email
        let password = credentials.password
        
        //signing users in using firebase, with a completion block that is usede in the login controller
        AUTH.signIn(withEmail: email, password: password, completion: completion)
    }
}

