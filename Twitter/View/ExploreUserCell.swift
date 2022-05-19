//
//  ExploreUserCell.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/14/22.
//

import UIKit
import SDWebImage


class ExploreUserCell: UITableViewCell {
    
    
    //MARK: - Properties
    
    var user: User?{
        didSet{
            configureProfileCell()
        }
    }
    
    
    
    //this the profileimageview thats gonna display when user writes a tweet
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        //setting hard coded dimensinos
        iv.setDimensions(width: 48, height: 48)
        //seeting up a background color
        iv.backgroundColor = .twitterBlue
        //making sure the image takes the whole view
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 48 / 2
        iv.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let fullnameLabel: UILabel={
        let label = UILabel()
        label.font = UIFont.boldSystemFont (ofSize: 14)
        return label
    }()
    private let usernameLabel: UILabel={
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    
    @objc private func handleProfileImageTapped(){
        print("cell tapped")
    }
    
    
    //MARK: - Helpers
    
    private func configureCellUI(){
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        let infoStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        
        addSubview(infoStack)
        infoStack.anchor(top: topAnchor, left: profileImageView.rightAnchor, paddingTop: 8, paddingLeft: 8)

        
        
        
    }
    
    private func configureProfileCell(){
        guard let user = user else {return}
        profileImageView.sd_setImage(with: user.profileImageUrl)
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@\(user.username)"
    }
   
    
    
}
