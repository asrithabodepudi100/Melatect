//
//  ClinicalTrialsHomePageViewController.swift
//  Melatect
//
//  Created by Asritha Bodepudi  on 1/20/21.
//

import UIKit
import RealmSwift

class ClinicalTrialsHomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let realm = try! Realm()
    var clinicalTrialEntries: Results<ClinicalTrialEntry>?



    @IBOutlet weak var clinicalTrialsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clinicalTrialsTableView.dataSource = self
        clinicalTrialsTableView.delegate = self
        clinicalTrialEntries = realm.objects(ClinicalTrialEntry.self)
        
        let nib = UINib(nibName: "ClinicalTrialTableViewCell", bundle: nil)
        self.clinicalTrialsTableView.register(nib, forCellReuseIdentifier: "ClinicalTrialTableViewCell")


    }
  
   
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.clinicalTrialsTableView.reloadData()
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clinicalTrialEntries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicalTrialTableViewCell", for: indexPath) as! ClinicalTrialTableViewCell
    
        if let melatectDiagnosis = clinicalTrialEntries?[indexPath.row].melatectDiagnosis{
            cell.melatectDiagnosis.text = melatectDiagnosis

        }
        if let doctorDiagnosis = clinicalTrialEntries?[indexPath.row].doctorDiagnosis{
            cell.doctorDiagnosis.text = doctorDiagnosis

        }
        if let mainImage = clinicalTrialEntries?[indexPath.row].mainImage{
            cell.mainImageView.image = UIImage(data: mainImage as Data)
        }
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
