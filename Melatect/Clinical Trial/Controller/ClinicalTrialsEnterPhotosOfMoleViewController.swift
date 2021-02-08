//
//  ClinicalTrialsEnterPhotosOfMoleViewController.swift
//  Melatect
//
//  Created by Asritha Bodepudi  on 1/20/21.
//

import UIKit
import RealmSwift


// MARK: TABLE VIEW CELL CLASS
class ClinicalTrialsPhotoOfMoleTableViewCell: UITableViewCell{
    
    @IBOutlet weak var moleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


// MARK: CLINICAL TRIALS ENTER PHOTO OF MOLE CLASS
class ClinicalTrialsEnterPhotosOfMoleViewController: UIViewController {
    
    //VARIABLES
    var image: UIImage?
    var counter: Int = 0
    let realm = try! Realm()
    var newClinicalTrialEntry = ClinicalTrialEntry()
    var isMainImage: Bool?
    
    
    //IBOUTLETS
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imagesTableView: UITableView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var addSupplementaryImage: UIButton!
    @IBOutlet weak var mainImageLabel: UILabel!
    @IBOutlet weak var plusCircleImagView: UIImageView!
    
    
    //VIEW HEIRACHY METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesTableView.dataSource = self
        imagesTableView.delegate = self
        
        let folderPath = realm.configuration.fileURL!.deletingLastPathComponent().path
        print (folderPath)
        
        addSupplementaryImage.layer.cornerRadius = 15
        backgroundView.layer.cornerRadius = 17
        imagesTableView.allowsSelection = false
        imagesTableView.separatorStyle = .none
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToClinicalTrialsEntryViewController"){
            let destinationVC = segue.destination as! ClinicalTrialsEntryViewController
            destinationVC.clinicalTrialEntry = newClinicalTrialEntry
        }
    }
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        if newClinicalTrialEntry.mainImage == nil {
            let alert = UIAlertController(title: "Please enter a main image", message: "Our machine learning model needs a main image to make a diagnosis", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            alert.view.tintColor = UIColor.black

            self.present(alert, animated: true, completion: nil)
        }
        else if newClinicalTrialEntry.imagesList.count == 0{
            let alert = UIAlertController(title: "Please upload at least 1 supplementary image of the skin lesion.", message: "We recommend uploading 5-10 supplementary images of the same skin lesion in different angles, rotations, or lighting.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            alert.view.tintColor = UIColor.black

            self.present(alert, animated: true, completion: nil)
        }
        else{
            performSegue(withIdentifier: "goToClinicalTrialsEntryViewController", sender: nil)
        }
    }
    

    @IBAction func enterMainImageButtonPressed(_ sender: UIButton){
        isMainImage = true
        presentCameraOrPhotoLibraryOptionAlert()
    }
    
    
    @IBAction func addSupplementaryImageButtonPressed(_ sender: UIButton) {
        isMainImage = false
        presentCameraOrPhotoLibraryOptionAlert()
    }
    
}

// MARK: CLINICAL TRIALS ENTER PHOTO OF MOLE CLASS - SAVE + GET IMAGE METHODS
extension ClinicalTrialsEnterPhotosOfMoleViewController{
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        
        do {
            let name = "Entry" + String(realm.objects(ClinicalTrialEntry.self).count - 1) + "_image" + String(counter) + ".png"

            try data.write(to: directory.appendingPathComponent(name)!)
            do {
                try realm.write{
                    newClinicalTrialEntry.imagesList.append((name))
                }
            }
            catch {
                print (error)
            }
            counter += 1
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}

// MARK: CLINICAL TRIALS ENTER PHOTO OF MOLE CLASS - TABLE VIEW METHODS
extension ClinicalTrialsEnterPhotosOfMoleViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newClinicalTrialEntry.imagesList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicalTrialsPhotoOfMoleTableViewCell") as! ClinicalTrialsPhotoOfMoleTableViewCell
        
      
        let checkName = "Entry" + String(realm.objects(ClinicalTrialEntry.self).count - 1) + "_image" + String(indexPath.row) + ".png"
        for entry in  newClinicalTrialEntry.imagesList {
            if entry == checkName{
                cell.moleImageView.isHidden = false
                cell.moleImageView.image = getSavedImage(named: entry)
                
                break
            }
            else{
                cell.moleImageView.isHidden = true
            }
        }
        
        return cell
    }
 
}


// MARK: CLINICAL TRIALS ENTER PHOTO OF MOLE CLASS - IMAGE PICKER METHODS
extension ClinicalTrialsEnterPhotosOfMoleViewController:
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    func presentCameraOrPhotoLibraryOptionAlert() {
        let alert = UIAlertController(title: "Take Photo of Mole", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Use Camera", style: .default, handler: { [self] action in
          takePhotoWithCamera()
        }))
        alert.addAction(UIAlertAction(title: "Upload from Photos", style: .default, handler: { action in
            self.choosePhotoFromLibrary()
        }))
        alert.view.tintColor = UIColor.black

        self.present(alert, animated: true)
    }
    
    func takePhotoWithCamera() {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = .camera
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      present(imagePicker, animated: true, completion: nil)
    }
      
      func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
      }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
      
        
        
        if isMainImage == true{
          
            mainImageLabel.isHidden = true
            plusCircleImagView.isHidden = true
            do {
                try realm.write{
                    let data = NSData(data: (image?.pngData()!)!)
                    newClinicalTrialEntry.mainImage = data
                    mainImageView.image = UIImage(data: newClinicalTrialEntry.mainImage! as Data)

                }
            }
            catch {
                print (error)
            }
        }
        else{
            if saveImage(image: image!) == true {
                imagesTableView.reloadData()
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
    }
}
