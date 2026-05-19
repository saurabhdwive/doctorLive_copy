//
//  ChatViewC+KeyBoard.swift
//  Dr.Live
//
//  Created by Kv on 02/01/25.
//

import Foundation
import IQKeyboardManagerSwift
import UIKit

extension ChatViewC: UITextFieldDelegate{
    
    func setUpKeyBoard(){
        IQKeyboardManager.shared.enable = false
        removeKeyboardNotifications()
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        self.messageTxt.iq.toolbar.doneBarButton.invocation = invocation
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.registerForKeyboardNotifications()
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func didPressOnDoneButton() {
        self.messageTxt.resignFirstResponder()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.view.endEditing(true)
            NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                print("Touhes end")
        }
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        print("KeyBoard Show")
        self.startTyping()
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        self.msgBoxBottomConstraint?.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
            if self.chatData.count > INTZERO {
                self.setscrollPosition()
            }
            self.endTyping()
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown(notification:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        print("Keyboard was dismissed");
    }
        
    @objc func keyboardWasShown(notification: NSNotification) {
        print("Keyboard was shown")
        
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        self.messageTxt.iq.toolbar.doneBarButton.invocation = invocation
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
//        self.IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration?.title = "Done"
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
          
            var frame = chatTblVw.frame
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.3)
            frame.size.height -= keyboardSize.height
            chatTblVw.frame = frame
            if self.messageTxt != nil {
                let rect = chatTblVw.convert(self.messageTxt!.bounds, from: self.messageTxt)
                chatTblVw.scrollRectToVisible(rect, animated: false)
            }
            UIView.commitAnimations()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            
            self.msgBoxBottomConstraint.constant = keyboardSize.height
            
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
                if self.chatData.count > INTZERO{
                    self.setscrollPosition()
                }}
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.messageTxt?.becomeFirstResponder()
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        self.messageTxt.iq.toolbar.doneBarButton.invocation = invocation
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
//        self.IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration?.title = "Done"
        
    }
}
