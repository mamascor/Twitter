//
//  FeedController.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/5/22.
//

import UIKit
import SDWebImage

class FeedController: UIViewController{
    
    
    //MARK: - Properties
     
    
    
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
        
    }
    
    //MARK: - Helper
    func configureUI(){
        view.backgroundColor = .white
        
        
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


extension FeedController {
    
}
