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
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshTweets), for: .valueChanged)
        
        return rc
    }()
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        configureUI()
        fetchTweets()
        configureUIBarButton()
        collectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    //MARK: - API
    
    
    func fetchTweets(){
        UserService.shared.currentFollowing { tweets in
            self.tweets = tweets
            print("Tweets: ", tweets)
        }
    }
    
    //MARK: - Selectors
    @objc private func refreshTweets(){
        fetchTweets()
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.refreshControl.endRefreshing()
            
        }
       

    }
    
    //MARK: - Helper
    func configureUI(){
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdetifier)
        
    }
    func configureUIBarButton(){
        guard let user = user else { return }
        


        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.masksToBounds = true
        profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        profileImageView.sd_setImage(with: user.profileImageUrl)
       
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        

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
        guard let user = cell.tweet?.user else {return}
        let controller = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.user = user
        controller.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
