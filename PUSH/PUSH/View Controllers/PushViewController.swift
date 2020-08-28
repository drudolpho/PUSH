//
//  PushViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/27/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {
    
    var userController: UserController?
    let cameraController = CameraController()
    var audioController = AudioController()
    
    var countDownTime = 3
    var timer = Timer()
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var instructionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TESTING for testing on simulator, comment this vvv out
        cameraController.setUpCamera()
        //TESTING
        
        cameraController.delegate = self
        cameraController.audioController = audioController
        
        view.backgroundColor = .black
        startButton.layer.cornerRadius = 25
        prepareLight()
        

    }
    
    func prepareDark() {
//        todaysCountLabel.isHidden = true
//        statsCollectionView.isHidden = true
//        yourPushLabel.isHidden = true
//        greenView.isHidden = true
//        pageControl.isHidden = true
//        countLabel.isHidden = false
//        soundButton.isHidden = false
//        countLabel.text = String(countDownTime)
//        setSpeakOn(bool: !defaults.bool(forKey: "sound"))
    }
    
    func prepareLight() {
//        todaysCountLabel.isHidden = false
//        statsCollectionView.isHidden = false
//        yourPushLabel.isHidden = false
//        greenView.isHidden = false
//        pageControl.isHidden = false
//        countLabel.isHidden = true
//        soundButton.isHidden = true
//        todaysCountLabel.text = "\(UserDefaults.standard.integer(forKey: "todaysPushups"))"
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
        if countDownTime == 1 {
//            countLabel.text = "Go!"
            stopTimer()
            cameraController.captureStartingBrightness()
        } else {
            countDownTime -= 1
//            countLabel.text = String(countDownTime)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        guard let userController = userController else { return }
        if cameraController.captureSession.isRunning {
            cameraController.captureSession.stopRunning()
            stopTimer()

            print("Done")
            userController.newSet(reps: cameraController.count) //updates local user
            userController.updateUserDatatoServer() { (error) in
                self.startButton.setTitle("Start", for: .normal)
                self.startButton.backgroundColor = UIColor(red: 58/255, green: 192/255, blue: 90/255, alpha: 1)
                self.prepareLight()
                self.reset()
//                self.statsCollectionView.reloadData()
            }
            
        } else {
            cameraController.captureSession.startRunning()
            startButton.setTitle("Stop", for: .normal)
            startButton.backgroundColor = UIColor(red: 176/255, green: 92/255, blue: 90/255, alpha: 1)
            startCountDown()
            prepareDark()
        }
    }
    
    private func setSpeakOn(bool: Bool) {
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
        setSpeakOn(bool: audioController.speakOn)
    }
}

extension PushViewController: PushupControllerDelegate {
    func updatePushupLabel(pushups: Int) {
        DispatchQueue.main.async {
            self.countLabel.text = String(pushups)
            UIView.animate(withDuration: 0.2) {
                self.countLabel.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            }
            UIView.animate(withDuration: 0.2) {
                self.countLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
}
