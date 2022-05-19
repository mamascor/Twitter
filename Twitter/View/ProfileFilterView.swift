//
//  ProfileFilterView.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/14/22.
//

import UIKit

private let reusableFilterId = "ReusableFilterCell"


//adding protocols so that when user types in the explore controller it work
protocol ProfileFilterViewDelegate: AnyObject {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath)
}


class ProfileFilterView: UIView {
    
    //MARK: - Properties
    
    //making it a weak var so that there are no retatantion cycles
    weak var delegate: ProfileFilterViewDelegate?
    
    
    //making a collectionview so that each cell in the profile header can show up
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    
    
    
    //MARK: - LifeCycle
    
    
    //initing the lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //registering the cells for the filter view
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reusableFilterId)
        //making sure the the tweet cell is selected first
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        //selecting the first item in the collection view with anumation and scroll position to the left
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        //adding the collectino view to the cell
        addSubview(collectionView)
        //this is gping to fill the view in the profile header
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
        //**SELECTORS MIGHT BE NEEDED WHEN USER SELECTS AN OPTION FOR THE PROFILE FILTER CELL**//
    
    //MARK: - Helpers
        //**HELPERS MIGHT BE NEEDED WHEN USER SELECTS AN OPTION FOR THE PROFILE FILTER CELL**//
}



//MARK: - UICollectionViewDataSource
extension ProfileFilterView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //do not hardcode this incase changes need to be made, hardcore is bad
        return ProfileFilterOptions.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //getting the cell from the profilefiltercell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableFilterId, for: indexPath) as! ProfileFilterCell
        //this is the filter optins which will allow it to return something
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        //this will take in the options and the cell will get the description
        cell.option = option
        //just returning the cell
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        //returning the size of what each cell should be
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //this is incase we want spacing between the cells
        return 0
    }
}



//MARK: - UICollectionViewDelegate
extension ProfileFilterView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //this selects cell and does the proper animations for the cells
        delegate?.filterView(self, didSelect: indexPath)
    }
}
