//
//  MainViewController.swift
//  PUSH
//
//  Created by Dennis Rudolph on 8/6/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let userController = UserController()
    let cameraController = CameraController()
    var audioController = AudioController()
    
    var countDownTime = 3
    var timer = Timer()
    
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var todaysCountLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var statsCollectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var yourPushLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var soundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraController.setUpCamera()
        cameraController.delegate = self
        countLabel.isHidden = true
        soundButton.isHidden = true
        cameraController.audioController = audioController
        
        startButton.layer.cornerRadius = 33
        //for collecti0n view
        statsCollectionView.delegate = self
        statsCollectionView.dataSource = self

        statsCollectionView.decelerationRate = .fast
        
        statsCollectionView.backgroundColor = UIColor.black
        statsCollectionView.showsHorizontalScrollIndicator = false
        self.view.bringSubviewToFront(pageControl)
        
//        self.pageControl.numberOfPages = friend count plus 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let _ = userController.user else {
            performSegue(withIdentifier: "UserSegue", sender: nil)
            return
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func myButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "UserSegue", sender: nil)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if cameraController.captureSession.isRunning {
            cameraController.captureSession.stopRunning()
            stopTimer()
            startButton.setTitle("Start", for: .normal)
            startButton.backgroundColor = UIColor(red: 58/255, green: 192/255, blue: 90/255, alpha: 1)
            prepareLight()
            print("Done")
            reset()
        } else {
            cameraController.captureSession.startRunning()
            startButton.setTitle("Stop", for: .normal)
            startButton.backgroundColor = UIColor(red: 176/255, green: 92/255, blue: 90/255, alpha: 1)
            startCountDown()
            prepareDark()
        }
    }
    
    @IBAction func soundTapped(sender: UIButton) {
        setSpeakOn(bool: audioController.speakOn)
    }
    
    //Timer Methods
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
    
    func prepareDark() {
        myButton.isHidden = true
        todaysCountLabel.isHidden = true
        statsCollectionView.isHidden = true
        yourPushLabel.isHidden = true
        titleLabel.isHidden = true
        greenView.isHidden = true
        pageControl.isHidden = true
        countLabel.isHidden = false
        soundButton.isHidden = false
        countLabel.text = String(countDownTime)
//        setSpeakOn(bool: !defaults.bool(forKey: "sound"))
    }
    
    func prepareLight() {
        myButton.isHidden = false
        todaysCountLabel.isHidden = false
        statsCollectionView.isHidden = false
        yourPushLabel.isHidden = false
        titleLabel.isHidden = false
        greenView.isHidden = false
        pageControl.isHidden = false
        countLabel.isHidden = true
        soundButton.isHidden = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserSegue" {
            if let viewController = segue.destination as? UserViewController {
                viewController.userController = userController
            }
        }
    }
}

extension MainViewController: PushupControllerDelegate {
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userController.friends.count + 2 //friends plus 1 for add
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == self.userController.friends.count + 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as? AddCollectionViewCell else { return UICollectionViewCell()}
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatCell", for: indexPath) as? StatCollectionViewCell else { return UICollectionViewCell()}
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        return CGSize(width: width - 60, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let pageWidth = Float((statsCollectionView.frame.width - 60) + 20)
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