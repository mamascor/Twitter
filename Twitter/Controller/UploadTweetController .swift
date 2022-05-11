//
//  UploadTweetController .swift
//  Twitter
//
//  Created by Marco Mascorro on 5/10/22.
//

import UIKit
import SDWebImage


class UploadTweetController: UIViewController {
    
    //MARK: - Properties
    
    
    //this user is being initialized in the init(user: User) line in the lifecycle mark
    private let user: User
    
    
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
    
    //custom text view thats in the view foider
    //its made so that code can be neater and ut can be used
    
    private let captionTextView = CaptionTextView()
    
    
    
    //this tweet button allows user to send the tweet
    private lazy var tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(sendTweetTapped), for: .touchUpInside)
        
     
        return button
    }()
    
    
    //MARK: - Lifecycle
    //this is initializing my user, this user is comming from the maintabcontroller func actionButtonTapped()
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    //this is requred when you use your own custom initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
       
    }
    
    //MARK: - Selectors
    //function dimisses view when users taps it
    @objc func cancelTapped(){
       dismiss(animated: true)
    }
    
    //function sends tweets to the firebase database
    @objc func sendTweetTapped(){
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption) { error, ref in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
            }
            print("DEBUG: Tweet was  successfully uploaded")
            self.dismiss(animated: true)
        }
    }
    
    
    //MARK: - API
    
    
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        configureUIBar()
        
        //was in an arrange view, stack view
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        view.addSubview(stack)
    
        
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor ,paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
      
        
        
        
        
        
    }
    
    func configureUIBar(){
        //custom uibutton
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
    }
}



