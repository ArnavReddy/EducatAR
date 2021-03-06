//
//  ViewController.swift
//  LoginASL
//
//  Created by Arnav Reddy on 3/13/20.
//  Copyright © 2020 Arnav Reddy2. All rights reserved.
//

import UIKit

@IBDesignable
class SignUpController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var errMsgField: UILabel!
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var effectView: UIVisualEffectView!

    @IBOutlet weak var signupButton: UIButton!
    var user = ""
    var pass = ""
    var effect: UIVisualEffect!
    
    func animateIn(errMsg:String)
    {
        self.view.addSubview(errorView)
        errorView.center = self.view.center
        errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        errorView.alpha = 0
        UIView.animate(withDuration: 0.5)
        {
            self.errMsgField.text = errMsg
            self.view.bringSubviewToFront(self.errorView)
            self.effectView.effect = self.effect
            self.errorView.alpha = 1
            self.errorView.transform = CGAffineTransform.identity
        }
    }
    func animateOut()
    {
            UIView.animate(withDuration: 0.3, animations: {
                self.errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.errorView.alpha = 0
                self.effectView.effect = nil
            }){ ( success:Bool) in
                self.errorView.removeFromSuperview()
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = effectView.effect
        effectView.effect = nil
        errorView.layer.cornerRadius = 5
        self.modalTransitionStyle = .flipHorizontal
        self.modalPresentationStyle = .overFullScreen
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        }

        //Calls this function when the tap is recognized.
        @objc func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }


    
    @IBAction func signUpPressed(_ sender: Any) {
        let theButton = sender as! UIButton
        let bounds = theButton.bounds
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options:.curveEaseInOut, animations:
            {
                theButton.bounds = CGRect(x: bounds.origin.x-20, y: bounds.origin.y, width: bounds.size.width+60, height: bounds.size.height)
        }) { (success:Bool) in
            if success
            {
                theButton.bounds = bounds
            }
        }
        
    }

    @IBAction func donePressed(_ sender: Any) {
        animateOut()
    }
    
}

