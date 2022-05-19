//
//  TweetCell.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/11/22.
//

import UIKit
import SDWebImage


protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    //we will receive a tweet model with all the information and we will work from there
    var tweet: Tweet? {
        didSet{configure()}
    }
    
    
    //setting up a weak delegate so that we dont get any memory leaks
    weak var delegate: TweetCellDelegate?
    
    
    //this the profileimageview thats gonna display when user writes a tweet
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        //setting hard coded dimensinos
        iv.setDimensions(width: 48, height: 48)
        //making sure the image takes the whole view
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 48 / 2
        iv.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    //custom caption label
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    
    //info label that will show that user fullname and username
    private let infoLabel = UILabel()
    
    
    //this are custom buttons that shows user options so that they can retweet like share comment
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "twitter_comment"), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "twitter_retweet"), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "twitter_like"), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikedTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "twitter_share"), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleSharedTapped), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - LifeCycle
    
    //initing for when cell shows up
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Selectors
    
    @objc func handleCommentTapped(){
        print("comment tapped")
    }
    
    @objc func handleRetweetTapped(){
        print("retweet tapped")
    }
    
    @objc func handleLikedTapped(){
        print("like tapped")
    }
    
    @objc func handleSharedTapped(){
        print("shared tapped")
    }
    
    @objc func handleProfileImageTapped(){
        delegate?.handleProfileImageTapped(self)
        
    
    }
    
    
    //MARK: - Helpers
    
    //this will configure the cell so that all info comes up correctly
    private func configure(){
        guard let tweet = tweet else {return}
        let vm = TweetViewModel(tweet: tweet)
        infoLabel.attributedText = vm.userInfoText
        captionLabel.text = tweet.caption
        profileImageView.sd_setImage(with: vm.profileImageUrl )

    }
    
    
    //this just configures that cell, configures autolayout
    
    private func configureUI(){
        backgroundColor = .white
        
        //adding the profuleimageview fist so that it can be anchored to the left and top of the cell
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 12, paddingLeft: 8)
        //default background color will be of blue just incase photo doesnt show up
        profileImageView.backgroundColor = .twitterBlue
        //putting tha caption label and infolabel in a vertical stackview
        let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stack.axis = .vertical
        //its gonna fill poportiaonally so that it takes good amount of space
        stack.distribution = .fillProportionally
        //default spacing of 4
        stack.spacing = 4
        
        
        //adding the underline to each tweet cell
        let underlineview = UIView()
        //making the background apples system background
        underlineview.backgroundColor = .systemGroupedBackground
        //adding the backgroung to the view
        addSubview(underlineview)
        //anchoring the underline to the cell
        underlineview.anchor(left: rightAnchor,bottom: bottomAnchor,right: rightAnchor, height: 1)
        //just adding the stackview to the right of the profileimageview with some spacing
        addSubview(stack)
        
        //anchoring stackview to the right of the profileimageview with some spacing
        stack.anchor(top: topAnchor, left: profileImageView.rightAnchor, paddingTop: 12, paddingLeft: 8)
        
        
        //adding the buttons in  stackview becuase they are next to each other
        let buttonStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        //positioning the horizontal
        buttonStack.axis = .horizontal
        //distributing equally so that each take the same amount fo space
        buttonStack.distribution = .fillEqually
        //default spacing of 10
        buttonStack.spacing = 10
        
        addSubview(buttonStack)
        //just anchoring the to the borron the stack view 
        
        buttonStack.anchor(left: profileImageView.rightAnchor, bottom: underlineview.topAnchor,right: rightAnchor, paddingBottom: 10, paddingRight: 15)
        
    }
    
}
