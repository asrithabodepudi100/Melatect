//
//  ClinicalTrialEntry.swift
//  Melatect
//
//  Created by Asritha Bodepudi  on 1/20/21.
//

import Foundation
import RealmSwift

class ClinicalTrialEntry: Object{
    @objc dynamic var mainImage: NSData?
    @objc dynamic var melatectDiagnosis: String = ""
    @objc dynamic var doctorDiagnosis: String = ""
    @objc dynamic var notes: String = ""
    @objc dynamic var dateCreated: Date?
    var imagesList = List<String>()
}
