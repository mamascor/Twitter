//
//  Utilities.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/5/22.
//

import UIKit


class Utilities {
    
    func inputContainerView(withImage image: String, textfield: UITextField)-> UIView {
        //Setting up the divider view under each text field
        let dividerView = UIView()
        //Setting up the view 
        let view = UIView()
        //setting up the mail image for the textfield
        let iv = UIImageView()
        //giving the emailcontainerview a constraint height
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //giving it an image
        iv.image = UIImage(named: image)
        iv.tintColor = .white
        //adding it to the subview.
        view.addSubview(iv)
        //anchoring it, giving it a padding
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,  paddingBottom: 8)
        //setting dimensions
        iv.setDimensions(width: 24, height: 24)
        view.addSubview(textfield)
        //configuring the textfield to the correct position.
        textfield.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 8)
        
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(top: textfield.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 8, height: 0.7)
        
        
        return view
    }
    
    //setting up the textfield, making it in a different function so that it can be reusable.
    func textField(withPlaceHolder placeholder: String)-> UITextField {
        let tf = UITextField()
        //custom placeholder color with custom opacity
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        //disabling auto capitalization
        tf.autocapitalizationType = .none
        //disabling auto correction
        tf.autocorrectionType = .no
        tf.textColor = .white
        
        return tf
    }
    
    func attributedButton(_  firstLabel: String,_ secondLabel: String)-> UIButton{
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstLabel, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
                                                                                  NSAttributedString.Key.foregroundColor : UIColor.white])
        attributedTitle.append(NSAttributedString(string: secondLabel, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                                                                                    NSAttributedString.Key.foregroundColor : UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button

    }
    
}
