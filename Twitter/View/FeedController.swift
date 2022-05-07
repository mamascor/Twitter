//
//  FeedController.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/5/22.
//

import UIKit

class FeedController: UIViewController{
    
    
    //MARK: - Properties
    
    
    
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
        navigationItem.titleView = imageView
    }
    
}
