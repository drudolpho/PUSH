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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var statTableView: UITableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statTableView.delegate = self
        statTableView.dataSource = self
        self.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        statTableView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        statTableView.separatorColor = UIColor(red: 82/255, green: 82/255, blue: 82/255, alpha: 1)
        statTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        statTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: statTableView.frame.size.width, height: 1))
        self.layer.cornerRadius = 40
        topView.layer.cornerRadius = 40
        topView.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        cellImageView.layer.cornerRadius = cellImageView.frame.size.width/2
        cellImageView.clipsToBounds = true
    }
    
    func updateViews() {
        guard let userController = self.userController, let user = userController.user else { return }
        if cellIndex == 0 {
            nameLabel.text = user.name
            cellImageView.image = userController.images[user.imageID]
            codeLabel.text = "#\(user.codeName.suffix(4))"
        } else {
            let friend = userController.friends[cellIndex - 1]
            nameLabel.text = friend.name
            cellImageView.image = userController.images[friend.imageID]
            codeLabel.text = "#\(userController.friends[cellIndex - 1].codeName.suffix(4))"
        }
        statTableView.reloadData()
    }
}


extension StatCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userController = self.userController, let user = userController.user else { return UITableViewCell() }
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as? TopTableViewCell {
                if self.cellIndex == 0 {
                    cell.totalLabel.text = String(user.total)
                    cell.avgLabel.text = String(user.avg)
                } else {
                    let friend = userController.friends[cellIndex - 1]
                    cell.totalLabel.text = String(friend.total)
                    cell.avgLabel.text = String(friend.avg)
                }
                cell.selectionStyle = .none
                return cell
            }  else {
                return UITableViewCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as? StatTableViewCell {
                
                var statee: User {
                    if cellIndex == 0 {
                        return user
                    } else {
                        return userController.friends[cellIndex - 1]
                    }
                }

                if indexPath.row == 1 {
                    cell.statNameLabel.text = "Sets:"
                    cell.statValueLabel.text = String(statee.sets)
                } else if indexPath.row == 2 {
                    cell.statNameLabel.text = "Max:"
                    cell.statValueLabel.text = String(statee.max)
                } else if indexPath.row == 3 {
                    cell.statNameLabel.text = "Streak:"
                    if let recentDate = userController.df.date(from: statee.lastDate) {
                        if userController.getDaysSince(day1: recentDate, day2: userController.date) > 1 {
                            cell.statValueLabel.text = "0"
                        } else {
                            cell.statValueLabel.text = "\(statee.dayStreak)"
                        }
                    }
                } else if indexPath.row == 4 {
                    cell.statNameLabel.text = "Days:"
                    if let dayOne = userController.df.date(from: statee.startDate) {
                        cell.statValueLabel.text = "\(userController.getDaysSince(day1: dayOne, day2: userController.date) + 1)"
                    }
                }
                cell.selectionStyle = .none
                return cell
            }  else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableView.frame.height / 3
        } else {
            return tableView.frame.height / 6
        }
    }
}
