//
//  ProfileViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/27/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var audioController: AudioController?
    var userController: UserController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
     }
    
    private func setSpeakOn(bool: Bool) {
        guard let audioController = audioController else { return }
        if bool == false {
            audioController.speakOn = true
//            soundButton.setImage(UIImage(named: "speak"), for: .normal)
//            defaults.set(true, forKey: "sound")
        } else if bool == true {
            audioController.speakOn = false
//            soundButton.setImage(UIImage(named: "sound"), for: .normal)
//            defaults.set(false, forKey: "sound")
        }
    }
    
    @IBAction func soundTapped(sender: UIButton) {
        guard let audioController = audioController else { return }
        setSpeakOn(bool: audioController.speakOn)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
