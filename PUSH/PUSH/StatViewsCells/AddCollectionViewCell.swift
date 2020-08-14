//
//  AddCollectionViewCell.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell {
    
    var userController: UserController?
    var updateCollectionView: (() -> Void)?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var addAFriendButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        self.layer.cornerRadius = 40
        addButton.layer.cornerRadius = 20
        cancelButton.layer.cornerRadius = 20
        nameTF.layer.cornerRadius = 10
        nameTF.clipsToBounds = true
        codeTF.layer.cornerRadius = 10
        codeTF.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    func viewOne() {
        nameLabel.isHidden = true
        nameTF.isHidden = true
        codeLabel.isHidden = true
        codeTF.isHidden = true
        addButton.isHidden = true
        cancelButton.isHidden = true
        
        addAFriendButton.isHidden = false
        plusButton.isHidden = false
    }
    
    func viewTwo() {
        nameLabel.isHidden = false
        nameTF.isHidden = false
        codeLabel.isHidden = false
        codeTF.isHidden = false
        addButton.isHidden = false
        cancelButton.isHidden = false
        
        addAFriendButton.isHidden = true
        plusButton.isHidden = true
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let name = nameTF.text, !name.isEmpty, let code = codeTF.text, !code.isEmpty, let updateCollectionView = updateCollectionView else { return }
        let codeName = name + code.suffix(4)
        let noSpacesCodeName = String(codeName.filter { !" \n\t\r".contains($0) })
        let capsCode = noSpacesCodeName.uppercased()
        print(capsCode)
        guard capsCode.isAlphanumeric else {
            //alert
            return
        }
        userController?.findFriendData(codeName: capsCode, completion: { (successful) in
            if successful {
                updateCollectionView()
                self.viewOne()
            } else {
//                ALERT
            }
        })
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        viewOne()
    }
    
    @IBAction func addAFriendTapped(_ sender: UIButton) {
        viewTwo()
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        viewTwo()
    }
}

extension UIView {
    var isHiddenInStackView: Bool {
        get {
            return isHidden
        }
        set {
            if isHidden != newValue {
                isHidden = newValue
            }
        }
    }
}
