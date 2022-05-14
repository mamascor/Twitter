//
//  FeedController.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/5/22.
//

import UIKit
import SDWebImage

private let reuseIdetifier = "retweetCell"

class FeedController: UICollectionViewController {
    
    
    //MARK: - Properties
     
    private var tweets = [Tweet]() {
        didSet{collectionView.reloadData()}
    }
    
    var user: User? {
        didSet{
            configureUIBarButton()
        }
    }
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        configureUI()
        fetchTweets()
        
    }
    
    //MARK: - API
    
    
    func fetchTweets(){
        TweetService.shared.fetchTweets { tweets in
                self.tweets = tweets
        }
    }
    
    //MARK: - Selectors
   
    
    //MARK: - Helper
    func configureUI(){
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdetifier)
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        
    }
    func configureUIBarButton(){
        guard let user = user else { return }


        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.masksToBounds = true
        profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        profileImageView.sd_setImage(with: user.profileImageUrl)
       


        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
        
        
        
    }
    
}

//MARK: - UICollectionViewDelegate/Datasource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdetifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
        
    }
}
//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

//MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped(_ cell: TweetCell) {
        let controller = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
    }
}
