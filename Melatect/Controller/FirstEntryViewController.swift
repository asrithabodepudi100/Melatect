//
//  FirstEntryViewController.swift
//  Melatect
//
//  Created by 01100001 01110011 01110010 01101001 01110100 01101000 01100001 on 4/21/21.
//

import UIKit
import FSCalendar

class FirstEntryViewController: UIViewController, FSCalendarDelegate{

    @IBOutlet weak var moleImageView: UIImageView!
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var diagnosisBackground: UIView!
    @IBOutlet weak var calenderBackgroundView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureView.layer.cornerRadius = 15
        moleImageView.layer.cornerRadius = 15
        diagnosisBackground.layer.cornerRadius = 15
        calenderBackgroundView.layer.cornerRadius = 15
        
        calendar.delegate = self
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MM-dd-YYYY"
        let string = formatter.string(from: date)
        let alert = UIAlertController(title: "Would you liked to schedule a remainder for 04-30-2021? ", message: "" , preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))


        self.present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

        }
    }
}
