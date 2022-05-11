//
//  MainTabController.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/5/22.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    
    //MARK: - Properties
    var user : User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            
            feed.user = user
        }
    }
    
    
    
    //Setting up my main action button, is the blue button on all the screens
//THE REASON IM DOING IT IN THE TAB BAR CONTROLLER, IS BECAUSE I WANT TO SHOW IT ACROSS ALL MY CONTROLLERS, SO THAT I WONT ME COPYING AND PASTING CODE
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        //Setting up the image color to white
        button.tintColor = .white
        //Setting up the background color to the custom color that is in the extensions file
        button.backgroundColor = .twitterBlue
        //Setting up the image of the button.
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        //Adding an action handler to the button with an objc function.
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    

    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//                logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
        
    }
    
    //MARK: - API
    
    func fetchUser(){
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    
    
    //Authenticate if user is logged in so we can display the main tab cotroller
    func authenticateUserAndConfigureUI(){
        //if user if not found then we go to the login controller
        if AUTH.currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
                
            }
        } else {
            
            //calling it so we can configure the ui interface
            configureUI()
            configureViewControllers()
            fetchUser()
        }
    }
    
    //loggin user out
    func logUserOut(){
        do{
            try AUTH.signOut()
        } catch let error{
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
    
    
    //MARK: - Selectors
    @objc func actionButtonTapped(){
       guard let user = user else { return }
       let vc = UINavigationController(rootViewController: UploadTweetController(user: user))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    //MARK: - Helper
    
    //Configuring my UI
    func configureUI(){
        view.addSubview(actionButton)
        
        //Make sure the safe area layout guide is set so that it can be shown in multiple devices. and that it doesnt show on top of the tabview.
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    
    //Configuring my tab bar controllers
    func configureViewControllers(){
        
        //setting up my controllers from the template nav controller function.
        let feed = templateNavController(image: "home_unselected", rootviewcontroller: FeedController())
        let explore = templateNavController(image: "search_unselected", rootviewcontroller: ExploreController())
        let notifications = templateNavController(image: "like_unselected", rootviewcontroller: NotificationsController())
        let conversations = templateNavController(image: "ic_mail_outline_white_2x-1", rootviewcontroller: ConversationsController())
        
        //Setting up my tabbar background color, i must do this or else the tabbar will be transparent
        UITabBar.appearance().backgroundColor = UIColor(white: 1, alpha: 0.8)
        //setting up the tint color of my tabbar items, must do this or else the default color will be blue
        UITabBar.appearance().tintColor = .black
        
        //setting up my view controllers in an array so that it can be showns in screen, must do this or else nothing will show up
        viewControllers = [feed, explore, notifications, conversations]
    }
    
    
    //Setting up my function so that i settup my tab view items
    func templateNavController(image: String, rootviewcontroller: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootviewcontroller)
        // this is my tab item image
        nav.tabBarItem.image =  UIImage(named: image)
        
        nav.navigationBar.barTintColor = .white
        
        
        //setting up my apperance to my navigation tab bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        //setting up my background color to my tab bar so text can be more visible
        appearance.backgroundColor = .white
        
        //Adding my appearance to my navigation controller so that everything can be visible
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        
        return nav
    }
}
