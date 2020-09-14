//
//  HelpViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 9/14/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
            ,.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(string: "Got it",
                                                        attributes: yourAttributes)
        dismissButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    @IBAction func dismissButtonTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
