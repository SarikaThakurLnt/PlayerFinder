//
//  PlayerDetailViewController.swift
//  PlayerFinder
//
//  Created by Sarika on 26/06/19.
//  Copyright © 2019 Airadmin. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate
{
    // Outlet Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfile: UIImageView!
    
    var playerDetailViewModel = PlayerDetailViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI()
    {
        tableView.tableFooterView = UIView()
        self.title = "Player Detail"
        startActivityIndicator()
        if AppUtility.sharedInstance.isNetworkConnected()
        {
            playerDetailViewModel.getData { (success, error) in
                if success
                {
                    self.stopActivityIndicator()
                    self.setUI()
                }
            }
        }
        else
        {
            self.showAlert("Error", msg: "No internet connection")
        }
    }

    // MARK: - TableView Datasource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return playerDetailViewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionData = playerDetailViewModel.data[section]
        let rowCount = sectionData.isOpen == true ? sectionData.skillDetail.count : 0
        return rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let playerDetailCell = tableView.dequeueReusableCell(withIdentifier: "CID_SEARCH_PLAYER", for: indexPath)
        let curSkill = playerDetailViewModel.data[indexPath.section].skillDetail[indexPath.row]
        playerDetailCell.textLabel?.numberOfLines = indexPath.section == TableSection.Bio.rawValue ? 0 : 1
        playerDetailCell.textLabel?.text = ("\(curSkill.skillKey) : \(curSkill.skillValue)").firstUppercased
        return playerDetailCell
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let curSection = playerDetailViewModel.data[section]
        let headerHeight = curSection.highlight ? 50 : 40

        var headerView : UIView?
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.frame.size.width), height: headerHeight))
        headerView?.backgroundColor = curSection.highlight ? UIColor.black : UIColor.lightGray
        headerView?.tag = section
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.delegate = self
        tapRecognizer.numberOfTapsRequired = 1
        headerView?.addGestureRecognizer(tapRecognizer)
        
        let expandImage = UIImageView(frame: CGRect(x: Int(tableView.frame.size.width - 40), y: Int(headerView!.frame.size.height/2 - 10), width: 20, height: 20))
        expandImage.tag = 101
        expandImage.image =  UIImage(named: curSection.isOpen ? "minus" : "plus")
        expandImage.isHidden =  curSection.highlight ? true : false
        headerView?.addSubview(expandImage)

        let headerLabel = UILabel(frame: CGRect(x: 20, y: 0, width: Int(tableView.frame.size.width - 40), height: headerHeight))
        headerLabel.text = curSection.title.firstUppercased
        headerLabel.textColor = curSection.highlight ? UIColor.white : UIColor.black
        headerView?.addSubview(headerLabel)
        
        return headerView!
    }

    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        if let index = gestureRecognizer.view?.tag, index != TableSection.Bio.rawValue
        {
            if playerDetailViewModel.data[index].isOpen == true
            {
                playerDetailViewModel.data[index].isOpen = false
            }
            else
            {
                playerDetailViewModel.data[index].isOpen = true
            }
            tableView.reloadData()
        }
       
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return playerDetailViewModel.data[section].highlight == true ? 50.0 : 40.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let curSkill = playerDetailViewModel.data[indexPath.section].skillDetail[indexPath.row]
        var rowHeight = 40.0
        if indexPath.section == TableSection.Bio.rawValue
        {
            if AppUtility.isValid(curSkill.skillValue)
            {
                let str = "\(curSkill.skillKey) : \(curSkill.skillValue)"
                rowHeight = Double(str.height(withConstrainedWidth: self.view.frame.width/2, font: UIFont.systemFont(ofSize: 12.5))) + 20
                rowHeight = rowHeight < 40 ? 40 : rowHeight
            }
        }
        return CGFloat(rowHeight)
        
    }
    
    // MARK: - Other Function
    func setUI()
    {
        tableView.reloadData()
        if AppUtility.isValid(playerDetailViewModel.profileImageUrlStr)
        {
            playerDetailViewModel.downloadImage { (data, error) in
                guard error == nil, let data = data else {
                    return
                }
                self.userProfile.image = UIImage(data: data)
            }
        }
        
    }
}



