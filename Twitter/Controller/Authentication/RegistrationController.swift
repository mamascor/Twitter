//
//  RegistrationController.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/5/22.
//

import UIKit
import Firebase

class RegistrationController: UIViewController{
    
    
    //MARK: - Properties
    
    private var profileImage: UIImage?
    
    //Creating the add image view
    private let addImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "plus_photo")?.withTintColor(.white)
        return iv
    }()
    
    
    //Configuring the emailtextfield into its own container view so that i can customize it and make it look nice and pretty
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: "mail", textfield: emailTextField)
        return view
    }()
    
    //setting up the email textfield, it needs to be in CLASS scope so that it will be able have access from any file.
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    //Configuring the passwordtextfield into its own container view so that i can customize it and make it look nice and pretty
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: "ic_lock_outline_white_2x", textfield: passwordTextField)
        return view
    }()
    
    //setting up the password textfield, it needs to be in CLASS scope so that it will be able have access from any file.
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        tf.keyboardType = .default
        return tf
    }()
    
    //Configuring the emailtextfield into its own container view so that i can customize it and make it look nice and pretty
    private lazy var fullNameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: "ic_person_outline_white_2x", textfield: fullNameTextField)
        return view
    }()
    
    //setting up the email textfield, it needs to be in CLASS scope so that it will be able have access from any file.
    private let fullNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Full Name")
        tf.autocapitalizationType = .words
        return tf
    }()
    
    //Configuring the passwordtextfield into its own container view so that i can customize it and make it look nice and pretty
    private lazy var usernameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: "ic_person_outline_white_2x", textfield: usernameTextField)
        return view
    }()
    
    //setting up the password textfield, it needs to be in CLASS scope so that it will be able have access from any file.
    private let usernameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "UserName")
        tf.keyboardType = .default
        return tf
    }()
    
    private let signButton: UIButton = {
        let button = UIButton(type: .system)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(signUpDidTapped), for: .touchUpInside)
        return button
    }()
    
    
    private let haveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Sign in")
        button.addTarget(self, action: #selector(signInDidTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadHelpers()
        initializaHideKeyboard()
        configureUI()
    }
    
    //MARK: - Selectors
    @objc private func signUpDidTapped(){
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image.")
            return
        }
        
        //we are guarding this properties to make sure they are not nil
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullName = fullNameTextField.text else {return}
        guard let userName = usernameTextField.text else {return}
        
        //this are credentials made in the API folder in the AuthService.swift file. where the register function is called
        let credentials = RegisterAuthCredentials(email: email,
                                                  password: password,
                                                  fullname: fullName,
                                                  username: userName,
                                                  profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: credentials) { error, ref in
            
            //if there was an error, i want to return and print out the error
            if let error = error {
                print("DEBUG: There has been an error: \(error.localizedDescription)")
                return
            }
            
            
            //this ensure that the rootviewcontroller is the maintabcontroller
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabController else {return}
            
            
            //this ensures the authenticateUserAndConfigureUI funtion gets called so that all the user data can be passed and ensures user is logged in
            tab.authenticateUserAndConfigureUI()
            
            //dimissed the registration controller becuase its on top of the maintabcontroller.
            self.dismiss(animated: true)
            
        }
        
        
        
        
    }
    
    //Function that dimisses the keyboard when the tap gesture is activated
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @objc private func signInDidTapped(){
        //thiu takes registration controller to the previous controller which was the logincontroller
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addImageDidTapped(){
        //sets up the image picker controller which allows to pick an image from your camera roll
        let ipc = UIImagePickerController()
        
        print("Add Image tapped")
        
        //this animation makes it look like the image was tapped
        addImageView.alpha = 0.75
        //adds a .3 of a second delay that makes the opacity go from 75% to 100%
        UIView.animate(withDuration:0.3){
            self.addImageView.alpha = 1
        }
        
        //this makes sure you are sellecting from the devices phoro library
        ipc.sourceType = .photoLibrary
        //sets the UIImagePickerController delegate to self, meaning it sets it to the registration controller
        ipc.delegate = self
        //Allows you to style the zoom of your phoro selected
        ipc.allowsEditing = true
        //it presents you with the devices photo gallery
        present(ipc, animated: true)
        
        
    }
    
    
    // MARK: - Helpers
    
    //Setting up the UI for the login screen.
    func configureUI(){
        //Setting the controllers background color to the custom twitter blue
        view.backgroundColor = .twitterBlue
        //adds the haveAccountButton to the registration controller view
        view.addSubview(haveAccountButton)
        //adds the addImageView to the registration controller view
        view.addSubview(addImageView)
        
        
        //setting up the image
        addImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        //setting the dimensions
        addImageView.setDimensions(width: 100, height: 100)
        addImageView.layer.cornerRadius = 50
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullNameContainerView, usernameContainerView, signButton])
        //this is making sure it is vertically align, so that they are on top of each other.
        stack.axis = .vertical
        //giving the stack some spacing
        stack.spacing = 20
        //adding the stack view to the view subview
        view.addSubview(stack)
        //anchoring the stack view to the botton of the twitter logo anchor
        stack.anchor(top: addImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        haveAccountButton.anchor(left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 8, paddingRight: 40)
    }
    
    
    
    private func viewDidLoadHelpers(){
        // this function helps me adding the tap features to the image picker
        //configure the tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImageDidTapped))
        //adding the tapGestureRecognizer to the addimageView
        addImageView.addGestureRecognizer(tapGestureRecognizer)
        //making sure user interaction is enabled
        addImageView.isUserInteractionEnabled = true
        //this allows me to return and go to the next image field when user presses return
        //here we are setting the textfields delegates to the registration controller
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
    }
    
    
    
    
}

//MARK: - Hiding Keyboard

//This will allow me to hide the keyboard
extension RegistrationController: UITextFieldDelegate {
    //hiding the keyboard when i tap on the screen
    private func initializaHideKeyboard(){
       //setting up the tap gesture recognized with a selector of a function that dismisses the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //adding the tap gesture recognizer the the registration controller
        view.addGestureRecognizer(tap)
    }
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    //switching up between textfields when return, except the last one, the last one just hides the keyboard.
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
            case emailTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                fullNameTextField.becomeFirstResponder()
            case fullNameTextField:
                usernameTextField.becomeFirstResponder()
            default:
                usernameTextField.resignFirstResponder()
        }
    }
    
}

//MARK: - Image Picker
//picking my image when the add image is pressed
extension RegistrationController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            self.profileImage = image
            addImageView.image = image
        }
        //dismissing the image picker controller
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
