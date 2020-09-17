//
//  StatViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class StatViewController: UIViewController {
    
    var userController: UserController?
    
    @IBOutlet weak var todaysCountLabel: UILabel!
    @IBOutlet weak var statsCollectionView: UICollectionView!

    @IBOutlet weak var yourPushLabel: UILabel!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userController = userController else { return }

        //for collection view
        statsCollectionView.delegate = self
        statsCollectionView.dataSource = self

        statsCollectionView.decelerationRate = .fast
        
        statsCollectionView.backgroundColor = UIColor.clear
        statsCollectionView.showsHorizontalScrollIndicator = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("UpdateCollectionView"), object: nil)
        
        greenView.layer.cornerRadius = 2
        self.view.bringSubviewToFront(pageControl)
        pageControl.numberOfPages = userController.friends.count + 2
        if userController.daysSinceLastDate() > 0 {
            UserDefaults.standard.set(0, forKey: "todaysPushups")
        }
        todaysCountLabel.text = "\(UserDefaults.standard.integer(forKey: "todaysPushups"))"
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if userController?.isFetching == false {
            userController?.updateFriendData()
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.statsCollectionView.reloadData()
        self.pageControl.numberOfPages = (self.userController?.friends.count ?? 0) + 2
        todaysCountLabel.text = "\(UserDefaults.standard.integer(forKey: "todaysPushups"))"
    }
}

// MARK: - Extensions

extension StatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.userController?.friends.count ?? 0) + 2 //friends plus 1 for add
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == (self.userController?.friends.count ?? 0) + 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as? AddCollectionViewCell else { return UICollectionViewCell()}
            cell.userController = self.userController
            cell.viewOne()

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatCell", for: indexPath) as? StatCollectionViewCell else { return UICollectionViewCell()}
            
            cell.userController = self.userController
            cell.cellIndex = indexPath.row
            cell.updateViews()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        return CGSize(width: width - 28, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let pageWidth = Float((statsCollectionView.frame.width - 28) + 10)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(statsCollectionView!.contentSize.width  )
        var newPage = Float(self.pageControl.currentPage)

        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }

        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}

extension StatViewController: PushViewControllerDelegate {
    func updateData() {
        statsCollectionView.reloadData()
        todaysCountLabel.text = "\(UserDefaults.standard.integer(forKey: "todaysPushups"))"
    }
}
