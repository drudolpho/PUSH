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
        nameTF.borderStyle = .none
        codeTF.borderStyle = .none
        nameTF.setLeftPaddingPoints(5)
        codeTF.setLeftPaddingPoints(5)
        self.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        self.layer.cornerRadius = 40
        addButton.layer.cornerRadius = 13
        cancelButton.layer.cornerRadius = 13
        nameTF.layer.cornerRadius = 10
        nameTF.clipsToBounds = true
        codeTF.layer.cornerRadius = 10
        codeTF.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    // MARK: - Methods
    
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
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let name = nameTF.text, !name.isEmpty, let code = codeTF.text, !code.isEmpty else { return }
        sender.isUserInteractionEnabled = false
        let codeLastFour = code.suffix(4)
        let codeName = name + codeLastFour.uppercased()
        let noSpacesCodeName = String(codeName.filter { !" \n\t\r".contains($0) })
        print(noSpacesCodeName)
        guard noSpacesCodeName.isAlphanumeric else {
            
            let alert = UIAlertController(title: "Incorrect info", message: "Please use an alphanumeric name and 4 character code", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.parentViewController?.present(alert, animated: true, completion: nil)
            sender.isUserInteractionEnabled = true
            return
        }
        
        let friends: [String] = UserDefaults.standard.stringArray(forKey: "friends") ?? []
        for friendCode in friends {
            if friendCode == noSpacesCodeName {
                let alert = UIAlertController(title: "You already follow this person!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.parentViewController?.present(alert, animated: true, completion: nil)
                sender.isUserInteractionEnabled = true
                return
            }
        }
        
        userController?.findFriendData(codeName: noSpacesCodeName, completion: { (successful) in
            if successful {
                sender.isUserInteractionEnabled = true
                NotificationCenter.default.post(name: Notification.Name("UpdateCollectionView"), object: nil)
                self.nameTF.text = ""
                self.codeTF.text = "#"
                self.viewOne()
            } else {
                let alert = UIAlertController(title: "Could not retrieve data", message: "There was an error finding your friend", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.parentViewController?.present(alert, animated: true, completion: nil)
                sender.isUserInteractionEnabled = true
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.nameTF.text = ""
        self.codeTF.text = "#"
        viewOne()
    }
    
    @IBAction func addAFriendTapped(_ sender: UIButton) {
        viewTwo()
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        viewTwo()
    }
}


