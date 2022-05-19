//
//  userEditController.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/15/22.
//

import UIKit



class UserEditController: UIViewController {
    
    
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUIBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Edit Profile"
    }
    
    
    //MARK: - Selectors
    @objc private func cancelTapped(){
        dismiss(animated: true)
    }
    
    //MARK: - Helpers
    func configureUIBar(){
        //custom uibutton
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
}
