//
//  TweetCell.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/11/22.
//

import UIKit


class TweetCell: UICollectionViewCell {
    
    //MARK: - Properties
    //this the profileimageview thats gonna display when user writes a tweet
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        //setting hard coded dimensinos
        iv.setDimensions(width: 48, height: 48)
        //making sure the image takes the whole view
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 48 / 2
        iv.clipsToBounds = true
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
        button.setImage(UIImage(named: ""), for: .normal)
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
    
    
    
    //MARK: - Helpers
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
        
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.text = "Eddie Brock"
        captionLabel.text = "Hello there"
        
        let underlineview = UIView()
        underlineview.backgroundColor = .systemGroupedBackground
        
        addSubview(underlineview)
        
        underlineview.anchor(left: profileImageView.rightAnchor,bottom: bottomAnchor,right: rightAnchor, height: 1)
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: profileImageView.rightAnchor, paddingTop: 12, paddingLeft: 8)
        
        
    }
    
}
