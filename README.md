

Melatect 

Melatect is an iOS application with an embedded machine learning model that can provide a benign or malignant skin cancer (melanoma) classification for a mole with a 95% accuracy rate. 
Melatect follows the MVC (model-view-controller) design pattern, and its files are organized as such within each interface. 

Table of Contents
Patient Interface
Clinical Trials Interface
Pods
Side Menu 
Supporting Files
AWS Architecture 

Patient Interface

Melatect’s first interface, the patient interface, has four main features: 
Diagnosis of Mole
Mole Evolution
Locate/Communicate with Doctors
Melanoma Risk Assessment Tool 

Model: 
File 
Summary 
Doctor.swift
Doctor class used to create Doctor objects that store information about doctors entered by user
MoleEntry.swift
MoleEntry class used to create MoleEntry objects that store information about moles (and their corresponding diagnoses) entered by user
MratConstants.swift
Stores weights for each variables used to calculate percent risk for developing melanoma
View: 
File 
Summary 
Storyboard + .xib files 
Visual representation of user interface 
.json files 
Animations within app 

Controller: 
File 
Summary 
ScanMoleViewController.swift
DisplayDiagnosisViewController.swift
MoleEntryViewController.swift
MoleEntryTableViewCell.swift
Allows user to select corresponding location of mole on 2D body, enter photo of mole, and receive diagnosis of malignant or benign
RiskAssessmentViewController.swift
Allows user to change values of various variables to determine a percent risk for developing melanoma within the next 5 years
FirstEntryViewController.swift
Tracks evolution of mole and encourages user to schedule notification reminders 
MyDoctorsViewController.swift
Users can search for doctors near them and email/phone them directly through the app 
PreviewToSignUpViewController.swift
HippaPrivacyViewController.swift
Logistical/opening files 


Clinical Trials Interface
Model: 
File 
Summary 
ClinicalTrialEntry.swift
ClinicalTrialEntry class used to create ClincialTrialEntry objects that store Melatect’s diagnosis and a dermatologists’ diagnosis for a mole

View: 
File 
Summary 
.xib files 
Visual representation of user interface 





Controller: 
File 
Summary 
ClincalTrialsHomePageViewController.swift 
ClincialNavigationViewController.swift         
Dermatologists are met with a screen that shows all past clinical trial entries in a list format 
ClinicalTrialsEnterPhotosofMoleViewController.swift
Dermatologists are provided with an interface where they can upload a photo of a mole and supplementary images
ClinicalTrialsEntryViewController.swift
Melatect outputs a diagnosis for mole image entered by dermatologist, which they can agree or disagree with
ClinicalTrialsSignUpViewController.swift
Dermatologists can create accounts to upload mole photos


Pods

AWS/Amplify (only used in Clinical Trials interface): used to create accounts, store photos and corresponding diagnoses of moles inputted by dermatologists, and retrain model 
FSCalendar: Used to create calendar to schedule mole evolution notification reminders
Friz: Used to augment images
Realm/SQLite: used for local storage of mole images and corresponding diagnoses objects, doctor objects, risk assessment parameters, etc. in Patient interface
SideMenu: used to create and animate side menu
Lottie: used to embed animations within app 

 Side Menu

The side menu was included in both interfaces  and allowed the user to switch between them while also learning logistical and legal information regarding Melatect. Our side menu included the following options: 
Help Center- provides video tutorials on how to use the app 
Feedback- takes user to the iOS app store to leave a review
Coming Soon- features we plan to implement in the coming future, along with an option for users to leave a suggestion on features they’d like to see on the app
FAQ- Frequently asked questions about HIPAA privacy, app privacy, data collection, structure of the app, and how to use the app
Legal- Legal documentation on HIPAA privacy and data collection
Contact Us- methods of contacting developers (phone number, email)
Exit Interface- ability to leave the app and come in through an alternate interface


File 
Summary 
SideMenuTableViewCell.swift
SideMenuTableViewCell.xib
Interface for each cell in side menu table view 
SideMenuViewController.swift
SideMenuViewController.xib
Interface for side menu

Supporting Files 
In addition to the files above, our project included .plist files that contained metadata regarding our app, podfiles, and .graphql files. 

File 
Summary 
AppDelegate.swift
Responsible for Melatect’s lifecycle and setup
LaunchScreen.storyboard
Placeholder file while app initially loads
moleScanDetectorModel1.mlmodel
Machine learning model implementation using create ML 
Assets.xcassets
Folder containing all images used in the app in an iOS compatible format (0.5x, 1x, 2x)

Accuracy Data
Trial Number vs. Classification Accuracy: Benign Images, First Prototype

Fig. A. 1st Prototype Accuracy Results Benign
Figure A shows a graph representing 100 trials. Each dot represents one trial with a benign image where the program was run using a benign image and the accuracy rate was recorded. Accuracy for 100 trials was 95.9%.

Trial Number vs. Classification Accuracy: Malignant Images, First Prototype

Fig. B. 1st Prototype Accuracy Results Malignant
Figure B represents 100 trials, as seen in the data table directly under the scatter plot. The testing was done using the first prototype of our machine learning model. Accuracy for 100 trials was 95.7%. 

Trial Number vs. Classification Accuracy: Benign Images, Second Prototype

Fig. C. 2nd Prototype Accuracy Results Benign
In Figure D, each dot represents one trial with a benign image. The testing was done using the most recent prototype of our machine learning model. A total of 500 trials were conducted. The average classification accuracy for benign moles is 98.8%. There is no linear correlation in this scatter plot. 
Trial Number vs. Classification Accuracy: Malignant Images, Second Prototype

Fig. D. 2nd Prototype Accuracy Results Malignant
Figure D shows that the average classification accuracy for malignant moles is 98.8%, so the equation for the line of best fit is y = 98.8. There is also no linear correlation in this graph. 

Sex vs. Classification Accuracy


Fig. E. Analyzing bias based on sex: both malignant and benign
 
The bars in Figure E show the mean classification rate for male and female images, regardless of the mole’s diagnosis. The graph was made using the male and female labels given to each image on ISIC metadata.  The average classification accuracy for moles on females is 98.7%, and the average classification accuracy for moles on males is 98.4%. The difference is 0.26%, less than 2%.

Classification Accuracy vs. Age: Malignant Images
Men are more likely to develop basal and squamous cell carcinoma, generally after the age 50. Skin cancer in people above age 65 has increased dramatically [2], which is why it is important for us to analyze the bias Melatect may have based on age.


Fig. F. Analyzing bias based on age: malignant
In Figure F, each dot represents a trial with a malignant image, with the x coordinate as the age and the y coordinate as the classification accuracy. There seems to be no linear correlation in this scatter plot. The highest classification accuracy for benign images when comparing different ages is 99.9%. 99.9% was the classification accuracy for 24 images with ages between 35-80. The lowest classification accuracy for malignant images when comparing different ages is 97.8%, for an image with age of  49. Although the difference is 2.1%, we concluded that there is no bias against images with an age of 50 because there was another image with age 50 with a classification accuracy of 99.2%. The image with the lowest classification accuracy must have been an outlier. 

Classification Accuracy vs. Age: Malignant Images

Fig. G. Analyzing bias based on age: benign
There seems to be no linear correlation in Figure G. The highest classification accuracy for malignant images when comparing different ages is 99.9%. 99.9% was the classification accuracy for 21 images with ages between 35-80. The lowest classification accuracy for malignant images when comparing different ages is 97.6%, for an image with age of  50. Although the difference is 2.3%, we concluded that there is no bias against images with an age of 50 because there was another image with age 50 with a classification accuracy of 99.8%. 

Classification Accuracy vs. Anatomical Site

Fig. H. Analyzing bias based on anatomical site (provided by metadata)
The bars in Figure H show the mean classification rate for moles on various anatomical sites, regardless of the mole’s diagnosis.  The highest average classification accuracy out of various anatomical sites was the posterior torso (98.9%). The lowest was head/neck (98.5%). The range is 0.4%, implying no bias according to anatomical site. 
Acknowledgements
We would first like to thank our advisor, Dr. Glenn Allen for providing his utmost support and advice throughout the length of this project, as well as access to computers from the MIT Kavli Institute with which we were able to run our models on, and helping us connect with dermatologists. Dr. Allen’s expertise was invaluable in formulating our research paper and methodology. We are grateful to dermatologists Dr. Jessica Howie, Dr. Neal Kumar, and Dr. John Kirwood for their input during this project. We also thank the Massachusetts General Hospital Cancer Center for its assistance in providing us with clinical photos and advice on features that would benefit patients using Melatect.

AWS Architecture




