//
//  UserProfileController.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/13/22.
//

import UIKit
import Firebase
import SwiftUI

private let reuseIdentifier = "TweetCell"
private let reuserHeaderIdentifier = "HeaderView"

class UserProfileController : UICollectionViewController, UIGestureRecognizerDelegate {
    
    //MARK: - Properties
    private var tweets = [Tweet]() {
        didSet{collectionView.reloadData()}
    }
    
    var user: User? {
        didSet{
            fetchUserTweets()
            configureNavBarUI()
            
        }
    }
    
    private let fullnameLabel: UILabel={
        let label = UILabel()
        label.font = UIFont.boldSystemFont (ofSize: 16)
        return label
    }()
    private let usernameLabel: UILabel={
        let label = UILabel()
        label.font = UIFont.systemFont (ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        navigationController?.navigationBar.barStyle = .default
        let customView =  UIImage(systemName: "chevron.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: customView, style: .done, target: self, action: #selector(handleDimissTabItem))
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    
    
    //MARK: - Helpers
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuserHeaderIdentifier)
        
        
        
    }
    
    
    private func configureNavBarUI(){
        
        guard let user = user else {return}
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@\(user.username)"
        let sv = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .center
        
        navigationItem.titleView = sv
        
    }
    
    private func fetchUserTweets(){
        guard let user = user else {return}
        
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
        
    }
    
    //MARK: - Selector
    
    
    @objc  func handleDimissTabItem(){
        navigationController?.popToRootViewController(animated: true)
    }
    
}



//MARK: - UICollectionViewDataSource

extension UserProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
}


//MARK: - UICollectionViewDelegate

extension UserProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuserHeaderIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}


extension UserProfileController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 325)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    
}
//MARK: - ProfileHeaderDelegate

extension UserProfileController: ProfileHeaderDelegate {
    func handleEditProfileFollow(_ header: ProfileHeader) {
        guard let userUid = header.user?.uid else {return}
        guard let isCurrentUser = header.user?.isCurrentUser else {return}
       
        if isCurrentUser {
            let controller = UINavigationController(rootViewController: UserEditController())
            present(controller, animated: true)
        }
        
        UserService.shared.checkIfUserIsFollowed(uid: userUid) { isFollowing in
            if isFollowing {
                UserService.shared.unfollowUser(uid: userUid) { error, ref in
                    header.checkUserFollow()
                }
            } else {
                UserService.shared.followUser(uid: userUid) { error, ref in
                    header.checkUserFollow()
                }
            }
        }
    }
    
    func handleDismissal() {
        navigationController?.popToRootViewController(animated: true)
    }
}


//MARK: - Unhide Navigation Bar

extension UserProfileController{
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y <= -50 {
            withAnimation {
                collectionView.contentInsetAdjustmentBehavior = .always
            }
            
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            withAnimation {
                collectionView.contentInsetAdjustmentBehavior = .never
                
            }
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}





