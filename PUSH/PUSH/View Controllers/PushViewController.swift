//
//  PushViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/27/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

protocol PushViewControllerDelegate {
    func updateData()
}

class PushViewController: UIViewController {
    
    var userController: UserController?
    let cameraController = CameraController()
    var audioController = AudioController()
    
    var countDownTime = 3
    var timer = Timer()
    var delegate: PushViewControllerDelegate?
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var yourPushLabel: UILabel!
    @IBOutlet weak var todaysPushCount: UILabel!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var instructionLabel1: UILabel!
    @IBOutlet weak var instructionLabel2: UILabel!
    @IBOutlet weak var pushUpImageView: UIImageView!
    @IBOutlet weak var pushDownImageView: UIImageView!
    @IBOutlet weak var shadowUpImageView: UIImageView!
    @IBOutlet weak var shadowDownImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userController = userController else { return }
        
        //TESTING for testing on simulator, comment this vvv out
        cameraController.setUpCamera()
        //TESTING
        
        cameraController.delegate = self
        cameraController.audioController = audioController
        
        view.backgroundColor = .black
        greenView.layer.cornerRadius = 2
        startButton.layer.cornerRadius = 25
        prepareLight()
        
        if userController.daysSinceLastDate() > 0 {
            UserDefaults.standard.set(0, forKey: "todaysPushups")
        }
        
        todaysPushCount.text = "\(UserDefaults.standard.integer(forKey: "todaysPushups"))"
        
        let sound = UserDefaults.standard.bool(forKey: "Sound")
        if sound {
            audioController.speakOn = true
            soundButton.setImage(UIImage(named: "Voice"), for: .normal)
        } else {
            audioController.speakOn = false
            soundButton.setImage(UIImage(named: "Sound"), for: .normal)
        }
        
        detailLabel.text = "Quickly get into push-up position!"
        
//        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
//        view.addGestureRecognizer(backSwipe)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let _ = userController?.user else {

            performSegue(withIdentifier: "UserSegue", sender: nil)
            return
        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            self.tabBarController?.selectedIndex = 0
        } else if sender.direction == .left {
            self.tabBarController?.selectedIndex = 2
        }
    }
    
    func prepareDark() {
        soundButton.isHidden = false
        shadowUpImageView.isHidden = false
        shadowDownImageView.isHidden = true
        instructionLabel1.isHidden = true
        instructionLabel2.isHidden = true
        pushUpImageView.isHidden = true
        pushDownImageView.isHidden = true
        yourPushLabel.isHidden = true
        todaysPushCount.isHidden = true
        greenView.isHidden = true
        countLabel.isHidden = false
        detailLabel.isHidden = false
        countLabel.text = String(countDownTime)
    }
    
    func prepareLight() {
        soundButton.isHidden = true
        shadowUpImageView.isHidden = true
        shadowDownImageView.isHidden = false
        instructionLabel1.isHidden = false
        instructionLabel2.isHidden = false
        pushUpImageView.isHidden = false
        pushDownImageView.isHidden = false
        yourPushLabel.isHidden = false
        todaysPushCount.isHidden = false
        greenView.isHidden = false
        countLabel.isHidden = true
        detailLabel.isHidden = true
    }
    
    private func setSpeakOn(bool: Bool) {
        if bool == false {
            audioController.speakOn = true
            soundButton.setImage(UIImage(named: "Voice"), for: .normal)
            UserDefaults.standard.set(true, forKey: "Sound")
        } else if bool == true {
            audioController.speakOn = false
            soundButton.setImage(UIImage(named: "Sound"), for: .normal)
            UserDefaults.standard.set(false, forKey: "Sound")
        }
    }
    
    // MARK: - Timer
    
    private func startCountDown() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownAction), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer.invalidate()
    }
    
    private func reset() {
        cameraController.count = 0
        cameraController.reset()
        countDownTime = 3
    }
    
    @objc func countDownAction() {
        guard let userController = userController, let user = userController.user else { return }
        if countDownTime == 1 {
            countLabel.text = "Go!"
            self.detailLabel.fadeTransition(0.3)
            detailLabel.text = "Your average push-ups per set is \(user.avg)"
            shadowUpImageView.isHidden = true
            shadowDownImageView.isHidden = false
            stopTimer()
            cameraController.captureStartingBrightness()
        } else {
            countDownTime -= 1
            countLabel.text = String(countDownTime)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func soundTapped(sender: UIButton) {
        setSpeakOn(bool: audioController.speakOn)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        guard let userController = userController, let user = userController.user else { return }
        if cameraController.captureSession.isRunning {
            cameraController.captureSession.stopRunning()
            stopTimer()

            let doneAlert = UIAlertController(title: "Done!", message: "You did \(self.cameraController.count) pushups, would you like to save this set?", preferredStyle: .alert)
            doneAlert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (action) in
                self.startButton.setImage(UIImage(named: "Play"), for: .normal)
                self.prepareLight()
                self.reset()
            }))
            doneAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                let updatedUser = userController.newSet(user: user, reps: self.cameraController.count) //updates local user
                userController.updateUserDatatoServer(user: updatedUser)
                self.startButton.setImage(UIImage(named: "Play"), for: .normal)
                self.prepareLight()
                self.reset()
                self.delegate?.updateData()
                self.todaysPushCount.text = "\(UserDefaults.standard.integer(forKey: "todaysPushups"))"
            }))
            present(doneAlert, animated: true)
        } else {
            cameraController.captureSession.startRunning()
            self.startButton.setImage(UIImage(named: "Stop"), for: .normal)
            startCountDown()
            prepareDark()
        }
        self.detailLabel.fadeTransition(0.3)
        detailLabel.text = "Quickly get into push-up position!"
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserSegue" {
            if let viewController = segue.destination as? LoginViewController {
                viewController.userController = userController
            }
        }
    }
}

extension PushViewController: PushupControllerDelegate {
    func updatePushupLabel(pushups: Int) {
        guard let userController = userController, let user = userController.user else { return }
        DispatchQueue.main.async {
            self.countLabel.text = String(pushups)
            if pushups > user.max {
                self.detailLabel.fadeTransition(0.3)
                self.detailLabel.text = "Keep going, new record!"
            } else if pushups > user.avg {
                self.detailLabel.fadeTransition(0.3)
                self.detailLabel.text = "Your all time max is \(user.max)"
            }

            UIView.animate(withDuration: 0.2) {
                self.countLabel.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            }
            UIView.animate(withDuration: 0.2) {
                self.countLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
}
