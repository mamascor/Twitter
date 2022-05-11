//
//  LoginController.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/5/22.
//

import UIKit


//this controller is embedded inside a navigation view in the scene delegate file.
class LoginController: UIViewController {
    
    
    //MARK: - Properties
    
    //Creating the twitter logo in the logingcontroller
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "TwitterLogo")
        
        return iv
    }()
    
    //Configuring the emailtextfield into its own container view so that i can customize it and make it look nice and pretty
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: "mail", textfield: emailTextField)
        return view
    }()
    
    //Configuring the passwordtextfield into its own container view so that i can customize it and make it look nice and pretty
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: "ic_lock_outline_white_2x", textfield: passwordTextField)
        return view
    }()
    
    //setting up the email textfield, it needs to be in CLASS scope so that it will be able have access from any file.
    private let emailTextField: UITextField = {
       let tf = Utilities().textField(withPlaceHolder: "Email")
        tf.keyboardType = .emailAddress
       return tf
    }()
    
    //setting up the password textfield, it needs to be in CLASS scope so that it will be able have access from any file.
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        tf.keyboardType = .default
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(loginDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Dont have an account?", " Sign up")
        button.addTarget(self, action: #selector(noAccountDidTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    //When the loggin button is tapped i want to sign then in
    @objc private func loginDidTapped(){
        //we are guarding this properties to make sure they are not nil
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        let credentials = LoginAuthCredentials(email: email,password: password)
        
        AuthService.shared.loginUser(credentials: credentials) { results, error in
            //if there was an error i want to return an print the error
            if let error = error {
                print("DEBUG: There has been an error: \(error.localizedDescription)")
                return
            }
            
            //setting up the maintabcontroller as the root view controller so that i can called the authenticate function so that information can be shown
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabController else {return}
            
            
            //calling the uthenticateUserAndConfigureUI function so that it verifies if the user is logged in or not.
            tab.authenticateUserAndConfigureUI()
            
            //Dismissed the controlles since the loggin controller is on top if the maintabcontroller
            self.dismiss(animated: true)
        }
        
    }
    
    @objc private func noAccountDidTapped(){
        //this funtion goes to the regitrations controller so user can sign in
        let registrationVC = RegistrationController()
        registrationVC.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    
    // MARK: - Helpers
    
    //Setting up the UI for the login screen.
    func configureUI(){
        //Setting up background color of the view.
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        
        //adding logoimageview to the view.
        view.addSubview(logoImageView)
        //centering logoimageview in the x-axis.
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        //adding height and width properties
        logoImageView.setDimensions(width: 100, height: 100)
        //adding noaccount button to the view
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 8, paddingRight: 40)
        //Configuring a stack view for emailcontainerview and password container view so that they can have the same dimensions.
            //Setting up my stackview, with the arranged subviews of email and password container view.
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        //this is making sure it is vertically align, so that they are on top of each other.
        stack.axis = .vertical
        //giving the stack some spacing
        stack.spacing = 20
        //adding the stack view to the view subview
        view.addSubview(stack)
        //anchoring the stack view to the botton of the twitter logo anchor
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        
    }
    

    

}
