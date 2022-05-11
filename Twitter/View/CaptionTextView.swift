//
//  CaptionTextView.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/10/22.
//

import UIKit



class CaptionTextView: UITextView {
    
    //MARK: - Properties
    //custom uitextview
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's Happening?"
        return label
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        //sets up to listen to change when user is typing
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    
    @objc func handleTextInputChange(){
        //when the textfield is not empty  then placeholder text is hidden
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
}

