//
//  ClinicalTrialsEntryViewController.swift
//  Melatect
//
//  Created by Asritha Bodepudi  on 1/20/21.
//

import UIKit
import RealmSwift
import CoreML
import Vision

class ClinicalTrialsEntryViewController: UIViewController {
    @IBOutlet weak var entryTableView: UITableView!
    let realm = try! Realm()
    var clinicalTrialEntry = ClinicalTrialEntry()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTableView.delegate = self
        entryTableView.dataSource = self
        entryTableView.separatorStyle = .none
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIBarButtonItem) {
        entryTableView.reloadData()
        do {
            try realm.write{
                realm.add(clinicalTrialEntry)
            }
        }
        catch {
            print (error)
        }
        
        self.performSegue(withIdentifier: "goBackToClinicalTrialHomePageViewController", sender: self)

    }
}



extension ClinicalTrialsEntryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          if indexPath.row == 0 {
              let cell = tableView.dequeueReusableCell(withIdentifier: "MainImageTableViewCell") as! MainImageTableViewCell
                
              cell.selectionStyle = .none
            
            if let image = clinicalTrialEntry.mainImage{
                cell.testerImageView.image = UIImage(data: image as Data)
            }
              return cell
            
           
          }
          else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MelatectDiagnosisTableViewCell") as! MelatectDiagnosisTableViewCell

            if let image = clinicalTrialEntry.mainImage{
                guard let model = try? VNCoreMLModel(for: moleScanDetectorModel1_copy().model) else {
                    fatalError("Loading CoreML Model Failed.")
                }
                let request = VNCoreMLRequest(model: model) { (request, error) in
                    guard let results = request.results as? [VNClassificationObservation] else {
                        fatalError("Model failed to process image.")
                    }
                    if let firstResult = results.first {
                        
                        
                        do {
                            try self.realm.write{
                                self.clinicalTrialEntry.melatectDiagnosis = firstResult.identifier.capitalized
                            }
                        }
                        catch {
                            print (error)
                        }
                    }
                }
                let handler = VNImageRequestHandler(ciImage: CIImage(image: UIImage(data: image as Data)!)!)
                do {
                    try handler.perform([request])
                }
                catch {
                    print(error)
                }
            }
            cell.selectionStyle = .none
            
            cell.melatectDiagnosis.text =  clinicalTrialEntry.melatectDiagnosis 

              return cell
          }
          
          else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorDiagnosisTableViewCell") as! DoctorDiagnosisTableViewCell
            cell.selectionStyle = .none
            if let doctorDiagnosis = cell.doctorDiagnosis{
                do {
                    try realm.write{
                            clinicalTrialEntry.doctorDiagnosis = doctorDiagnosis
                    }
                }
                catch {
                    print (error)
                }
                
            }
            return cell
          }
          
          else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell") as! NotesTableViewCell
            cell.selectionStyle = .none
            if let notes = cell.notesTextView.text{
                do {
                    try realm.write{
                            clinicalTrialEntry.notes = notes
                    }
                }
                catch {
                    print (error)
                }
                
            }
            return cell
          }
    }
    
}



// MARK: CLINICAL TRIALS ENTER PHOTO OF MOLE CLASS - SAVE + GET IMAGE METHODS
extension ClinicalTrialsEntryViewController{
   
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}




class MainImageTableViewCell: UITableViewCell{
    @IBOutlet weak var testerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class MelatectDiagnosisTableViewCell: UITableViewCell{
    @IBOutlet weak var melatectDiagnosis: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
}


class DoctorDiagnosisTableViewCell: UITableViewCell{
    @IBOutlet weak var benignButton: UIButton!
    @IBOutlet weak var malignantButton: UIButton!
    var doctorDiagnosis: String? = "default"
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func benignButtonPressed(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.7928650975, green: 0.9289059043, blue: 0.8150179386, alpha: 1)
        malignantButton.backgroundColor = #colorLiteral(red: 0.89797014, green: 0.8980780244, blue: 0.8979335427, alpha: 1)
        doctorDiagnosis = "Benign"
        
    }
    
    
    @IBAction func malignantButtonPressed(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.9852592349, green: 0.6800398764, blue: 0.6463516308, alpha: 1)
        benignButton.backgroundColor = #colorLiteral(red: 0.89797014, green: 0.8980780244, blue: 0.8979335427, alpha: 1)
        doctorDiagnosis = "Malignant"

    }
    
    
}

class NotesTableViewCell: UITableViewCell{
    @IBOutlet weak var notesTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


