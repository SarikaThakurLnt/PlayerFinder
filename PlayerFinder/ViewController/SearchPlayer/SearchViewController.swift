//
//  ViewController.swift
//  PlayerFinder
//
//  Created by Sarika on 26/06/19.
//  Copyright © 2019 Airadmin. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate
{
    // Outlet variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var guidanceLabel: UILabel!

    // Private Variables
    fileprivate var searchViewModel = SearchViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI()
    {
        tableView.tableFooterView = UIView()
        self.title = "Search"
    }
    
    // MARK:- TableView Datasource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchViewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let searchPlayerCell = tableView.dequeueReusableCell(withIdentifier: "CID_SEARCH_PLAYER", for: indexPath)
        let curPlayer = searchViewModel.data[indexPath.row]
        searchPlayerCell.textLabel?.text = curPlayer.fullName
        return searchPlayerCell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let playerDetailVC = storyboard?.instantiateViewController(withIdentifier: "VID_PLAYER_DETAIL") as? PlayerDetailViewController
        playerDetailVC?.playerDetailViewModel.pidStr = "\(searchViewModel.data[indexPath.row].pid)"
        self.navigationController?.pushViewController(playerDetailVC!, animated: true)
    }

    //MARK: - UISearchBarDelegate delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.guidanceLabel.isHidden = true
        if AppUtility.sharedInstance.isNetworkConnected()
        {
            startActivityIndicator()
            searchViewModel.searchPlayer(searchText) { (success, error) in
                guard error == nil else {
                    return
                }
                self.stopActivityIndicator()
                self.setUI()
            }
        }
        else
        {
            self.showAlert("Error", msg: "No internet connection")
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }

    func setUI()
    {
        if self.searchViewModel.data.count == 0
        {
            self.guidanceLabel.isHidden = false
            self.guidanceLabel.text = "Oops, no player found with this name."
        }
        else
        {
            self.guidanceLabel.isHidden = true
        }
        self.tableView.reloadData()

    }
}

