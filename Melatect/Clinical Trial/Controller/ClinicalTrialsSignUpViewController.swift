//
//  ClinicalTrialsSignUpViewController.swift
//  Melatect
//
//  Created by 01100001 01110011 01110010 01101001 01110100 01101000 01100001 on 2/4/21.
//

import UIKit

class ClinicalTrialsSignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var continueAndAcceptButton: UIButton!
    @IBOutlet weak var termsOfServiceButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var window: UIWindow?
    let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        view.addGestureRecognizer(tap)
        continueAndAcceptButton.layer.cornerRadius = 26
        let attributedString = NSMutableAttributedString.init(string: "Terms Of Service")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length));
        termsOfServiceButton.setAttributedTitle(attributedString, for: .normal)
        
        let attributedString2 = NSMutableAttributedString.init(string: "Privacy Policy")
        attributedString2.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString2.length));
        privacyPolicyButton.setAttributedTitle(attributedString2, for: .normal)
    }
    
    @IBAction func openTermsOfServiceButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HippaPrivacyViewController") as! HippaPrivacyViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func openPrivacyPolicyButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HippaPrivacyViewController") as! HippaPrivacyViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    @IBAction func continueAndAcceptButtonPressed(_ sender: UIButton) {
    
        if firstNameTextField.text == nil{
            let alert = UIAlertController(title: "Please enter a First Name", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if lastNameTextField.text == nil {
            let alert = UIAlertController(title: "Please enter a Last Name", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if emailTextField.text == nil{
            let alert = UIAlertController(title: "Please enter an email", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            

            defaults.set(firstNameTextField.text, forKey: "ClinicalTrialDoctorFirstName")
            defaults.set(lastNameTextField.text, forKey: "ClinicalTrialDoctorLastName")
            defaults.set(emailTextField.text, forKey: "ClinicalTrialDoctorEmail")


            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // if user is logged in before
        
                let mainTabBarController = storyboard.instantiateViewController(identifier: "ClinicalTrialsNavigationViewController")
                window?.rootViewController = mainTabBarController
            
          
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClinicalTrialsNavigationViewController") as! ClinicalTrialsNavigationViewController
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 40
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
