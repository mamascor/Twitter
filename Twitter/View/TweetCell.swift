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
    var tweet: Tweet? {
        didSet{configure()}
    }
    
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
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let infoLabel = UILabel()
    
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
    private func configure(){
        guard let tweet = tweet else {return}
        let vm = TweetViewModel(tweet: tweet)
        infoLabel.attributedText = vm.userInfoText
        captionLabel.text = tweet.caption
        profileImageView.sd_setImage(with: vm.profileImageUrl )

    }
    
    
    private func configureUI(){
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 12, paddingLeft: 8)
        profileImageView.backgroundColor = .twitterBlue
        let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        let underlineview = UIView()
        underlineview.backgroundColor = .systemGroupedBackground
        
        addSubview(underlineview)
        
        underlineview.anchor(left: profileImageView.rightAnchor,bottom: bottomAnchor,right: rightAnchor, height: 1)
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: profileImageView.rightAnchor, paddingTop: 12, paddingLeft: 8)
        
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        
        addSubview(buttonStack)
        
        buttonStack.anchor(left: profileImageView.rightAnchor, bottom: underlineview.topAnchor,right: rightAnchor, paddingBottom: 10, paddingRight: 15)
        
    }
    
}
