//
//  ViewController.swift
//  LSDPush-upsPlan
//
//  Created by LSD on 2017/1/10.
//  Copyright © 2017年 LSD. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var pushUpsLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var confirmView: UIView!
    
    var lastPoint: CGPoint?
    var pushUpCount: CGFloat = 0.0
    var originalWidth: CGFloat = 0.0
    
    let progressLayer = CAShapeLayer.init()
    
    let result = try! Realm().objects(PushUpModel.self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        customInit()
        addGesture()
        customDate()
    }
    
    func reloadData() {
        if result.count == 0 {
            return
        }
        daysLabel.text = String(result.count)
        let sum: Int = result.sum(ofProperty: "pushUpCount")
        pushUpsLabel.text = String(sum)
    }
    
    private func customInit() {
        originalWidth = confirmView.bounds.width
        
        confirmView.layer.cornerRadius = confirmView.frame.size.height/2.0
        confirmView.layer.borderColor = UIColor.white.cgColor
        confirmView.layer.borderWidth = 1.0
        confirmView.layer.masksToBounds = true
        
        
        progressLayer.frame = CGRect.init(x: 0, y: 0, width: 0, height: confirmView.bounds.size.height)
        progressLayer.anchorPoint = CGPoint.init(x: 0, y: 0.5)
        progressLayer.backgroundColor = self.view.backgroundColor?.cgColor
        confirmView.layer.addSublayer(progressLayer)
        
    }
    
    private func customDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    private func addGesture() {
        let horizontalGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleHorizontalPan(_:)))
        self.view.addGestureRecognizer(horizontalGesture)
        
        let verticalGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleVerticalPan(_:)))
        confirmView.addGestureRecognizer(verticalGesture)
    }
    
    @objc func handleHorizontalPan(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            lastPoint = gestureRecognizer.location(in: self.view)
        }
        
        if gestureRecognizer.state == .changed {
            let point = gestureRecognizer.location(in: self.view)
            let direction = lastPoint!.y - point.y
            
            if direction > 0 {
                pushUpCount += 0.2
            }
            
            if direction < 0 && pushUpCount >= 0 {
                pushUpCount -= 0.2
            }
            
            countLabel.text = String(describing: Int(pushUpCount))
            lastPoint = point
        }
    }
    
    @objc func handleVerticalPan(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .changed {
            let point = gestureRecognizer.location(in: self.view)
            
            if point.x > confirmView.frame.origin.x {
                let width = point.x - confirmView.frame.origin.x
                progressLayer.bounds = CGRect.init(x: 0, y: 0, width: width, height: progressLayer.bounds.size.height)
            }
            
        }
        
        if gestureRecognizer.state == .ended {
            if progressLayer.bounds.width < confirmView.bounds.width {
                progressLayer.bounds = CGRect.init(x: 0, y: 0, width: 0, height: progressLayer.bounds.size.height)
            } else {
                confirm()
            }
        }
    }
    
    func confirm() {
        saveData(Int(pushUpCount))
        confirmAnimation()
        reloadData()
    }
    
    func saveData(_ pushUps: Int) {
        if pushUps == 0 {
            return
        }
        
        let date = DateFormatter().string(format: nil, from: nil)
        let count = result.filter("date == %@", date).first?.pushUpCount
        
        let data = PushUpModel()
        data.date = date
        data.pushUpCount = count == nil ? pushUps : pushUps+count!
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(data, update: true)
        }
    }
    
    func confirmAnimation() {
        let animation = CABasicAnimation.init(keyPath: "bounds")
        animation.duration = 0.5
        animation.fromValue = NSValue.init(cgRect: self.confirmView.layer.bounds)
        animation.toValue = NSValue.init(cgRect: CGRect.init(origin: self.confirmView.bounds.origin, size: CGSize.init(width: self.confirmView.bounds.height, height: self.confirmView.bounds.height)))
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        let group = CAAnimationGroup.init()
        group.duration = 0.8
        group.autoreverses = true
        group.animations = [animation]
        group.delegate = self
        self.confirmView.layer.add(group, forKey: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        progressLayer.bounds = CGRect.init(x: 0, y: 0, width: 0, height: self.progressLayer.bounds.size.height)
        confirmView.layer.removeAllAnimations()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

