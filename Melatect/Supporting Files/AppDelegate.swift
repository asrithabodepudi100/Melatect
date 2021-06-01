//
//  AppDelegate.swift
//  MoleScan
//
//  Created by Asritha Bodepudi on 11/3/20.
//

import UIKit
import RealmSwift
import Amplify
import AmplifyPlugins

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let defaults = UserDefaults.standard
    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application( _ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAmplify()
     
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       
        return true
    }
  
    
    func configureAmplify(){
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())

            
            let models = AmplifyModels()
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            
            try Amplify.configure()
            print ("success")

        }
        catch{
            print("Could not configure - \(error)")
        }
    }

    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

