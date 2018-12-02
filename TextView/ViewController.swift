//
//  ViewController.swift
//  TextView
//
//  Created by Evgeniy Ryshkov on 02/12/2018.
//  Copyright © 2018 Evgeniy Ryshkov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    lazy var bottomDistance: CGFloat = {
        return bottomConstraint.constant
    }()
    
    let maxTextCount = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      1. Set delegate
        textView.delegate = self
        
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        textView.backgroundColor = self.view.backgroundColor
        
        textView.layer.cornerRadius = 10
        
//       Tracks appearing keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        
//        Tracks hiding keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIApplication.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func updateTextView(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject], let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIApplication.keyboardWillHideNotification  {
            bottomConstraint.constant = bottomDistance
        }else{
            bottomConstraint.constant = -keyboardFrame.height + bottomDistance
        }
    }

//    2. Set Hiding keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
//        Hides keyboard for any object
//        self.view.endEditing(true)
        
//        Hides keyboard for particular object
        textView.resignFirstResponder()
        
    }

}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.textColor = .gray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = self.view.backgroundColor
        textView.textColor = .black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
        
        //Controls that textView.text.count <= maxTextCount
        return textView.text.count + (text.count - range.length) <= maxTextCount
    }
}
