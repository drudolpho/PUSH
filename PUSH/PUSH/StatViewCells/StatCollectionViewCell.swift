//
//  StatCollectionViewCell.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class StatCollectionViewCell: UICollectionViewCell {
    
    var userController: UserController?
    var cellIndex = 0
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var cellImageViewButton: UIButton!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var statTableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: - Setup/Update Methods
    
    func setupViews() {
        statTableView.delegate = self
        statTableView.dataSource = self
        self.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        statTableView.backgroundColor = .clear
        statTableView.separatorColor = .clear
        nameTF.borderStyle = .none
        statTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        statTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: statTableView.frame.size.width, height: 1))
        self.layer.cornerRadius = 40
        topView.layer.cornerRadius = 35
        topView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 0.8).cgColor
        topView.layer.shadowOpacity = 1
        topView.layer.shadowOffset = CGSize.zero
        topView.layer.shadowRadius = 15
        cellImageViewButton.layer.cornerRadius = cellImageViewButton.frame.size.width/2
        cellImageViewButton.clipsToBounds = true
        
        shadowView.clipsToBounds = false
        shadowView.layer.cornerRadius = cellImageViewButton.frame.size.width/2
        shadowView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        shadowView.layer.shadowColor = UIColor(red: 15/255, green: 15/255, blue: 15/255, alpha: 1).cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 0
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: cellImageViewButton.frame.size.width/2).cgPath
    }
    
    func updateViews() {
        guard let userController = self.userController, let user = userController.user else { return }
        if cellIndex == 0 {
            nameTF.text = user.name
            cellImageViewButton.setImage(userController.images[user.imageID], for: .normal)
            codeLabel.text = "#\(user.codeName.suffix(4))"
        } else {
            let friend = userController.friends[cellIndex - 1]
            nameTF.text = friend.name
            cellImageViewButton.setImage(userController.images[friend.imageID], for: .normal)
            codeLabel.text = "#\(userController.friends[cellIndex - 1].codeName.suffix(4))"
        }
        statTableView.reloadData()
    }
}

// MARK: - Extensions

extension StatCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userController = self.userController, let user = userController.user else { return UITableViewCell() }
        
        var statee: User {
            if cellIndex == 0 {
                return user
            } else {
                return userController.friends[cellIndex - 1]
            }
        }
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath) as? GraphTableViewCell else { return UITableViewCell() }
            
            if let viewWithTag = cell.viewWithTag(100) { //Removes graph that has already been added if updating
                viewWithTag.removeFromSuperview()
            }
            
            cell.activityGraph = ActivityView(frame: CGRect(x: 30, y: 15, width: Double(cell.frame.width) - 60, height: constants.graphHeight))
            
            cell.addGraph(withData: statee.dayData, date: userController.date)
            cell.selectionStyle = .none
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as? StatTableViewCell else { return UITableViewCell() }

            if indexPath.row == 1 {
                cell.statOneNameLabel.text = "Total:"
                cell.statOneValueLabel.text = String(statee.total)
                cell.statTwoNameLabel.text = "Avg:"
                cell.statTwoValueLabel.text = String(statee.avg)
                cell.statThreeNameLabel.text = "Sets:"
                cell.statThreeValueLabel.text = String(statee.sets)
            } else if indexPath.row == 2 {
                cell.statOneNameLabel.text = "Max:"
                cell.statOneValueLabel.text = String(statee.max)
                cell.statTwoNameLabel.text = "Streak:"
                cell.statTwoValueLabel.text = String(statee.dayStreak)
                cell.statThreeNameLabel.text = "Days:"
                if let dayOne = userController.df.date(from: statee.startDate) {
                    cell.statThreeValueLabel.text = "\(userController.getDaysSince(day1: dayOne, day2: userController.date) + 1)"
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableView.frame.height / 1.65
        } else {
            return tableView.frame.height / 6.5
        }
    }
}
