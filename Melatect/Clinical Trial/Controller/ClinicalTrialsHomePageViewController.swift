//
//  ClinicalTrialsHomePageViewController.swift
//  Melatect
//
//  Created by Asritha Bodepudi  on 1/20/21.
//

import UIKit
import RealmSwift
import SideMenu

class ClinicalTrialsHomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let defaults = UserDefaults.standard

    @IBOutlet weak var helloDoctorLabel: UILabel!
    let realm = try! Realm()
    var clinicalTrialEntries: Results<ClinicalTrialEntry>?

    var menu = UISideMenuNavigationController(rootViewController: SideMenuViewController())


    @IBOutlet weak var clinicalTrialsTableView: UITableView!
    @IBOutlet weak var createEntryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helloDoctorLabel.text = "Hello, Dr." + defaults.string(forKey: "ClinicalTrialDoctorLastName")! + "!"
        defaults.set("ClinicalTrialsNavigationViewController", forKey: "navigation")

        clinicalTrialsTableView.dataSource = self
        clinicalTrialsTableView.delegate = self
        clinicalTrialEntries = realm.objects(ClinicalTrialEntry.self)
        
        let nib = UINib(nibName: "ClinicalTrialTableViewCell", bundle: nil)
        self.clinicalTrialsTableView.register(nib, forCellReuseIdentifier: "ClinicalTrialTableViewCell")
        

        createEntryButton.layer.cornerRadius = 15
        clinicalTrialsTableView.separatorStyle = .none
        clinicalTrialsTableView.allowsSelection = false
      
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        
        
        
        menu.leftSide = true
        SideMenuManager.default.menuLeftNavigationController = menu
        SideMenuManager.default.menuFadeStatusBar = false
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.9488552213, green: 0.9487094283, blue: 0.9693081975, alpha: 1)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
  
   
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.clinicalTrialsTableView.reloadData()
            }
        }
    }
    
    
    
    
    @IBAction func openMenuButtonPressed(_ sender: UIBarButtonItem) {
        present(menu, animated: true)
        navigationController?.navigationBar.barStyle = .default
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clinicalTrialEntries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicalTrialTableViewCell", for: indexPath) as! ClinicalTrialTableViewCell
    
        if let melatectDiagnosis = clinicalTrialEntries?[clinicalTrialEntries!.count - indexPath.row - 1].melatectDiagnosis{
            cell.melatectDiagnosis.text = melatectDiagnosis

        }
        if let doctorDiagnosis = clinicalTrialEntries?[clinicalTrialEntries!.count - indexPath.row - 1].doctorDiagnosis{
            cell.doctorDiagnosis.text = doctorDiagnosis

        }
        if let mainImage = clinicalTrialEntries?[clinicalTrialEntries!.count - indexPath.row - 1].mainImage{
            cell.mainImageView.image = UIImage(data: mainImage as Data)
        }
        
        
        
        if cell.melatectDiagnosis.text == "Malignant"{
            cell.melatectDiagnosis.textColor = #colorLiteral(red: 1, green: 0.4299195111, blue: 0.4152081609, alpha: 1)
            print("malignant")
        }
        else{
            cell.melatectDiagnosis.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        
        
        if cell.doctorDiagnosis.text == "Malignant"{
            cell.doctorDiagnosis.textColor = #colorLiteral(red: 1, green: 0.4299195111, blue: 0.4152081609, alpha: 1)
        }
        else{
            cell.doctorDiagnosis.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
        
    }
}
