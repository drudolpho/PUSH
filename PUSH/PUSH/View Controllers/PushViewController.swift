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
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
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
        instructionView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        instructionView.layer.cornerRadius = 40
        prepareLight()
    }
    
    func prepareDark() {
        instructionView.isHidden = true
        countLabel.isHidden = false
        countLabel.text = String(countDownTime)
    }
    
    func prepareLight() {
        instructionView.isHidden = false
        countLabel.isHidden = true
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
            countLabel.text = "Go!"
            stopTimer()
            cameraController.captureStartingBrightness()
        } else {
            countDownTime -= 1
            countLabel.text = String(countDownTime)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        guard let userController = userController else { return }
        if cameraController.captureSession.isRunning {
            cameraController.captureSession.stopRunning()
            stopTimer()

            let doneAlert = UIAlertController(title: "Done!", message: "You did \(self.cameraController.count) pushups, would you like to save this set?", preferredStyle: .alert)
            doneAlert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (action) in
                self.startButton.setTitle("Start", for: .normal)
                self.startButton.backgroundColor = UIColor(red: 58/255, green: 192/255, blue: 90/255, alpha: 1)
                self.prepareLight()
                self.reset()
            }))
            doneAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                userController.newSet(reps: self.cameraController.count) //updates local user
                userController.updateUserDatatoServer() { (error) in
                    self.startButton.setTitle("Start", for: .normal)
                    self.startButton.backgroundColor = UIColor(red: 58/255, green: 192/255, blue: 90/255, alpha: 1)
                    self.prepareLight()
                    self.reset()
                    self.delegate?.updateData()
                }
            }))
            present(doneAlert, animated: true)
        } else {
            cameraController.captureSession.startRunning()
            startButton.setTitle("Stop", for: .normal)
            startButton.backgroundColor = UIColor(red: 226/255, green: 77/255, blue: 77/255, alpha: 1)
            startCountDown()
            prepareDark()
        }
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
