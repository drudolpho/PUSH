//
//  AddCollectionViewCell.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
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
        nameTF.delegate = self
        codeTF.delegate = self
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            codeTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
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
        let codeLastFour = code.suffix(4)
        let codeName = name + codeLastFour.uppercased()
        let noSpacesCodeName = String(codeName.filter { !" \n\t\r".contains($0) })
        print(noSpacesCodeName)
        guard noSpacesCodeName.isAlphanumeric else {
            //alert
            return
        }
        userController?.findFriendData(codeName: noSpacesCodeName, completion: { (successful) in
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


