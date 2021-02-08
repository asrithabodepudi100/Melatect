//
//  OpeningViewController.swift
//  Melatect
//
//  Created by 01100001 01110011 01110010 01101001 01110100 01101000 01100001 on 2/4/21.
//

import UIKit

class OpeningViewController: UIViewController {
    @IBOutlet weak var dermatologistButton: UIButton!
    @IBOutlet weak var patientButton: UIButton!
    @IBOutlet weak var HIPPAPrivacyInformationButton: UIButton!
    let defaults = UserDefaults.standard
    var window: UIWindow?



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dermatologistButton.layer.cornerRadius = 26
        patientButton.layer.cornerRadius = 26
        let attributedString = NSMutableAttributedString.init(string: "HIPPA Privacy Information")
        // Add Underline Style Attribute.
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length));
        
        HIPPAPrivacyInformationButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    @IBAction func openDermatologistButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClinicalTrialsSignUpViewController") as! ClinicalTrialsSignUpViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func openPatientButtonPressed(_ sender: UIButton) {
        defaults.set("TabBar", forKey: "navigation")

       /* let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanMoleViewController") as! ScanMoleViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

         self.present(vc, animated: false, completion: nil)*/

        
      /*  self.window = UIWindow(frame: UIScreen.main.bounds)
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBar")
           self.window?.rootViewController = initialViewController
           self.window?.makeKeyAndVisible()*/
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // if user is logged in before
    
            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBar")
            window?.rootViewController = mainTabBarController
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! TabBar
         vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

          self.present(vc, animated: false, completion: nil)
    }
    @IBAction func HIPPAPrivacyInformationButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HippaPrivacyViewController") as! HippaPrivacyViewController
        self.present(vc, animated: false, completion: nil)
    }
    
   
}
