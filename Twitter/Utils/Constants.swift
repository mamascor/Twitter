//
//  Constants.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/7/22.
//

import Firebase
import FirebaseStorage

//this is the constants file which can be used in the whole scope of the file

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")


let DB_REF = Database.database().reference()
let AUTH = Auth.auth()
let REF_USERS = DB_REF.child("users")
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")


