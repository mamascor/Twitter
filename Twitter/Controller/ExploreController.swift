//
//  ExploreController.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/5/22.
//

import UIKit

class ExploreController: UIViewController{
    
    
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
        navigationItem.title = "Explore"
        
        
    }
}
