//
//  MoleEntriesViewController.swift
//  Melatect
//
//  Created by 01100001 01110011 01110010 01101001 01110100 01101000 01100001 on 4/21/21.
//

import UIKit

class MoleEntriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let defaults = UserDefaults.standard
    var counter = 0
    @IBOutlet weak var moleEntriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        
        moleEntriesTableView.dataSource = self
        moleEntriesTableView.delegate = self
        moleEntriesTableView.separatorStyle = .none
        
        
        let nib = UINib(nibName: "MoleEntryTableViewCell", bundle: nil)
        self.moleEntriesTableView.register(nib, forCellReuseIdentifier: "MoleEntryTableViewCell")
    }
    @objc func loadList(notification: NSNotification){
        //load data here
        counter = 3
        self.moleEntriesTableView.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        print ("HI HIHIHDLAFJLD")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MoleEntryTableViewCell", for: indexPath) as! MoleEntryTableViewCell
        if indexPath.row == 0{
            cell.diagnosis.text = "Abnormal"

            cell.mainImageView.image = #imageLiteral(resourceName: "Image1")
            cell.location.text = "Right Hand"
            if counter != 3{
                cell.scheduled.text = "No Update Scheduled"

            }
            else{
                cell.scheduled.text = "Update Scheduled for 04/30/2021"
            }

        }
        else if indexPath.row == 1{
            cell.mainImageView.image = #imageLiteral(resourceName: "Image2")
            cell.diagnosis.text = "Normal"
            cell.diagnosis.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.location.text = "Upper Left Arm"
            cell.scheduled.text = "No Update Scheduled"
        }
        else{
            cell.mainImageView.image = #imageLiteral(resourceName: "Image3")
            cell.diagnosis.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.diagnosis.text = "Normal"
            cell.location.text = "Lower Torso"
            cell.scheduled.text = "Update Scheduled for 05/03/2021"
        }

        
        return cell

    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
        
    }
}
