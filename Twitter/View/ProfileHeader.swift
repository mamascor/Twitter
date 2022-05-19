//
//  ProfileHeader.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/13/22.
//

import UIKit
import SDWebImage


protocol ProfileHeaderDelegate: AnyObject {
    
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    //MARK: - Properties
    //when user taps on the cell it should bring user over
    var user: User? {
        didSet{
            configureProfileUI()
            checkUserFollow()
            
           
        }
    }
    
  //making this a weak delegate to avoid reatain cycles
    weak var delegate: ProfileHeaderDelegate?
    
    
    //this is the filter bar in that allows selection
    private let filterBar = ProfileFilterView()
    
    //this is the twitter banner
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor,
                          paddingTop: 42, paddingLeft: 8)
        backButton.setDimensions (width: 30, height: 30)
        return view
    }()
    private lazy var backButton: UIButton = {
        //this is the backbutton of the headerview
        let button = UIButton(type: .system)
        button.setImage (UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        
        button.addTarget (self, action: #selector (handleDismissal), for: .touchUpInside)
        return button
    }()
    
    //this is the users profile imageview
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        //making it so that it fills the entire circle
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        //if there is not picture than it will show a gray color
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    
    //this is what the user will see when the follow button is showing
    
    lazy var editProfileFollowButton: UIButton={
        let button=UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor (UIColor.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont (ofSize: 14)
        button.addTarget(self ,action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel={
        let label = UILabel()
        label.font = UIFont.boldSystemFont (ofSize: 20)
        return label
    }()
    private let usernameLabel: UILabel={
        let label = UILabel()
        label.font = UIFont.systemFont (ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        return label
    }()
    
    private let underlineView : UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        filterBar.delegate = self
        
        
        addSubview(containerView)
        containerView.anchor (top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24 , paddingLeft: 8)
        profileImageView.setDimensions (width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        
        addSubview(userDetailStack)
        userDetailStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor,
                                right: rightAnchor, paddingTop: 8, paddingLeft: 12,
                                paddingRight: 12)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(top: userDetailStack.bottomAnchor, left: leftAnchor,
                           paddingTop: 8, paddingLeft: 12)
        
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Selectors
    
    @objc private func handleDismissal(){
        delegate?.handleDismissal()
     
    }
    
    @objc private func handleEditProfileFollow(){
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc private func handleFollowersTapped(){
        print("handle Followers Tapped")
    }
    
    @objc private func handleFollowingTapped(){
        print("handle Following Tapped")
    }
    
    
    
    
    
    //MARK: - Helpers
    
    
    private func configureProfileUI(){
        guard let user = user else {return}
        guard let url = user.profileImageUrl else {return}
        
        let viewModel = ProfileHeaderViewModel(user: user)
        
        profileImageView.sd_setImage(with:url)
        
        fullnameLabel.text = user.fullname
        
        usernameLabel.text = "@\(user.username)"
        
        bioLabel.text = user.bio
        
        followersLabel.attributedText = viewModel.followersString
        followingLabel.attributedText = viewModel.followingString
    }
    
     func checkUserFollow() {
         guard let user = user else {return}
         
         if user.isCurrentUser{
             editProfileFollowButton.setTitle("Edit Profile", for: .normal)
             return
         }

         UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowing in
             if isFollowing {
                 self.editProfileFollowButton.setTitle("Following", for: .normal)
             } else {
                 self.editProfileFollowButton.setTitle("Follow", for: .normal)
           
             }
         }
        
        
    }
    
    
}

//MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate{
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else {return}
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
            
    }
}
