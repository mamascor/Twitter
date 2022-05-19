//
//  ExploreController.swift
//  Twitter
//
//  Created by Marco Mascorro on 5/5/22.
//

import UIKit

private let reuseID = "reuseId"

class ExploreController: UITableViewController{
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Properties
    private var users = [User]() {
        didSet{tableView.reloadData()}
    }
    
    private var filteredUsers = [User]() {
        didSet{tableView.reloadData()}
    }
    
    private var inSearchMode: Bool{
        return searchController.isActive
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.\
        tableView.separatorStyle = .none
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    
    //MARK: - Helper
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
        tableView.register(ExploreUserCell.self, forCellReuseIdentifier: reuseID)
        fetchUsers()
        configureSearchController()
    }
    
    
    private func fetchUsers(){
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search.."
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}


extension ExploreController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! ExploreUserCell
        cell.selectionStyle = .none
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        cell.isHidden = users[indexPath.row].isCurrentUser
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ExploreController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0.0
        if users[indexPath.row].isCurrentUser{
            rowHeight = 0.0
        } else {
            rowHeight = 70
        }
        return rowHeight
    }
}

extension ExploreController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchtext = searchController.searchBar.text?.lowercased() else {return}
        filteredUsers = users.filter({ $0.username.contains(searchtext) || $0.fullname.contains(searchtext)})
    }
}

