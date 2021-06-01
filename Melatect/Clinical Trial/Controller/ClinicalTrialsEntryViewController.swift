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
import AmplifyPlugins
import Amplify

class ClinicalTrialsEntryViewController: UIViewController {
    let defaults = UserDefaults.standard
    @IBOutlet weak var entryTableView: UITableView!
    @IBOutlet weak var entryLabel: UILabel!
    let realm = try! Realm()
    var clinicalTrialEntry = ClinicalTrialEntry()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTableView.delegate = self
        entryTableView.dataSource = self
        entryTableView.separatorStyle = .none
        
            defaults.set("default", forKey: "ClinicalTrialDoctorDiagnosis")
        entryLabel.text = "Entry #" + String       (realm.objects(ClinicalTrialEntry.self).count + 1)

    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIBarButtonItem) {
        entryTableView.reloadData()
        
        
        
        if defaults.string(forKey: "ClinicalTrialDoctorDiagnosis") == "default"{
            let alert = UIAlertController(title: "Please select a suggested diagnosis", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            alert.view.tintColor = UIColor.black

            self.present(alert, animated: true, completion: nil)
        }
        else{
            do {
                try realm.write{
                    realm.add(clinicalTrialEntry)
                }
            }
            catch {
                print (error)
            }
            
            
            let entryNumber = "Entry" + String(realm.objects(ClinicalTrialEntry.self).count - 1)
                
            upload(UIImage(data: clinicalTrialEntry.mainImage! as Data)!, isMainImage: true, doctorName: defaults.string(forKey: "ClinicalTrialDoctorLastName")!, melatectDiagnosis: clinicalTrialEntry.melatectDiagnosis, doctorDiagnosis: defaults.string(forKey: "ClinicalTrialDoctorDiagnosis")!, entryNumber: entryNumber, imageName: "MainImage")
            
            
            if clinicalTrialEntry.imagesList.count != 0{
                for (index,supplementaryImage) in clinicalTrialEntry.imagesList.enumerated(){
                    if let image = getSavedImage(named: supplementaryImage) {
                        upload(image, isMainImage: false, doctorName: defaults.string(forKey: "ClinicalTrialDoctorLastName")!, melatectDiagnosis: clinicalTrialEntry.melatectDiagnosis, doctorDiagnosis: defaults.string(forKey: "ClinicalTrialDoctorDiagnosis")!, entryNumber: entryNumber, imageName: "SupplementaryImage" + String(index))

                    }
                }
            }
            
            
            self.performSegue(withIdentifier: "goBackToClinicalTrialHomePageViewController", sender: self)
            
        }
        
        
        

       
    }
    
    
    func upload(_ image: UIImage, isMainImage: Bool, doctorName: String, melatectDiagnosis: String, doctorDiagnosis: String, entryNumber: String, imageName: String){
        guard let imageData = image.jpegData(compressionQuality: 0.5) else{
            return
        }
        var key = String()
        if isMainImage == true{
                key = doctorName + "_" + melatectDiagnosis + "_" + doctorDiagnosis + "_" + entryNumber + "_" + imageName

        }
        else{
            key = doctorName + "_" + entryNumber + "_" + imageName
        }
        
        
        _ = Amplify.Storage.uploadData(key: key, data: imageData){ result in
            switch result{
            case .success:
                
                Amplify.DataStore.save(Entry(imageKey: key)){ result in
                    switch result{
                    case .success:
                        print (" saved")
                        
                    case .failure(_):
                        print ("noppe")
                    }
                }
             case .failure(_):
            }
        }
    }
}



extension ClinicalTrialsEntryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
            
            if clinicalTrialEntry.melatectDiagnosis == "Malignant"{
                cell.melatectDiagnosis.text = "Abnormal"
            }
            else{
                cell.melatectDiagnosis.text = "Normal"
            }
            if cell.melatectDiagnosis.text == "Malignant" || cell.melatectDiagnosis.text == "Abnormal"{
                cell.melatectDiagnosis.textColor = #colorLiteral(red: 1, green: 0.4299195111, blue: 0.4152081609, alpha: 1)
            }
            else{
                cell.melatectDiagnosis.textColor = #colorLiteral(red: 0.4663519263, green: 0.7639035583, blue: 0.2652341723, alpha: 1)
            }
              return cell
          }
          
          else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorDiagnosisTableViewCell") as! DoctorDiagnosisTableViewCell
            cell.selectionStyle = .none
            if let doctorDiagnosis = cell.doctorDiagnosis{
                do {
                    try realm.write{
                            clinicalTrialEntry.doctorDiagnosis = doctorDiagnosis
                        print ("inside cell" + clinicalTrialEntry.doctorDiagnosis)
                    }
                }
                catch {
                    print (error)
                }
                
            }
            return cell
          }
          
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 200
        }
        else if indexPath.row == 1 || indexPath.row == 2{
            return 130
        }
        else{
            return 170
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
    @IBOutlet weak var grayBackgroundView: UIView!
    
    override func awakeFromNib() {
        grayBackgroundView.layer.cornerRadius = 22
        super.awakeFromNib()
    }
}


class DoctorDiagnosisTableViewCell: UITableViewCell{
    let defaults = UserDefaults.standard

    @IBOutlet weak var benignButton: UIButton!
    @IBOutlet weak var malignantButton: UIButton!
    @IBOutlet weak var grayBackgroundView: UIView!
    var doctorDiagnosis: String? = "No Diagnosis Provided"
    override func awakeFromNib() {
        super.awakeFromNib()
        benignButton.layer.cornerRadius = 10
        malignantButton.layer.cornerRadius = 10
        grayBackgroundView.layer.cornerRadius = 22
    }
    
    
    @IBAction func benignButtonPressed(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.7928650975, green: 0.9289059043, blue: 0.8150179386, alpha: 1)
        malignantButton.backgroundColor = #colorLiteral(red: 0.89797014, green: 0.8980780244, blue: 0.8979335427, alpha: 1)
        doctorDiagnosis = "Benign"
        defaults.set("Benign", forKey: "ClinicalTrialDoctorDiagnosis")
        print ("Benign" + doctorDiagnosis!)
    }
    
    
    @IBAction func malignantButtonPressed(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.9852592349, green: 0.6800398764, blue: 0.6463516308, alpha: 1)
        benignButton.backgroundColor = #colorLiteral(red: 0.89797014, green: 0.8980780244, blue: 0.8979335427, alpha: 1)
        doctorDiagnosis = "Malignant"
        print ("Malignant" + doctorDiagnosis!)
        defaults.set("Malignant", forKey: "ClinicalTrialDoctorDiagnosis")


    }
    
    
}
