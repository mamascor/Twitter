//
//  ProfileFilterCell.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/14/22.
//

import UIKit



class ProfileFilterCell: UICollectionViewCell {
    
    
    //MARK: - Properties
    
    //this options are from the headerviewmodel enum and it allows it to retun the title of the label
    var option: ProfileFilterOptions! {
        didSet{
            titlelabel.text = option.description
        }
    }
    
    //creating a symple label
    let titlelabel: UILabel={
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        //if nothing return back this will just appear
        label.text = "-"
        return label
    }()
    
    //applying proper ui in the cell is selected
    override var isSelected: Bool {
        didSet{
            titlelabel.font = isSelected ? UIFont.boldSystemFont (ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titlelabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        //adding the title label
        addSubview(titlelabel)
        //centering the label in the cell
        titlelabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    
    
    //MARK: - Helpers
    
    
}
