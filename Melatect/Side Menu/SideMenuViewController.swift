//
//  MenuViewController.swift
//  MoleScan
//
//  Created by Asritha Bodepudi on 11/30/20.
//

import UIKit
import StoreKit

class SideMenuViewController: UIViewController, UITableViewDataSource, loadWebView, UITableViewDelegate {
    let defaults = UserDefaults.standard

    func loadWebView(titleLabel: String) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuWebViewController") as UIViewController
        
        if titleLabel == "Help Center"{
            //need to record video
            defaults.set("https://tnlrtechnologies.com/openSourceInfo.html", forKey: "url")
            self.present(vc, animated: true, completion: nil)

        }
        else if titleLabel == "Feedback"{
            //redirects to app store 
            var components = URLComponents(url: URL(string: "https://apps.apple.com/us/app/melatect/id1544199337")!, resolvingAgainstBaseURL: false)
            components?.queryItems = [
              URLQueryItem(name: "action", value: "write-review")
            ]
            guard let writeReviewURL = components?.url else {
              return
            }
            UIApplication.shared.open(writeReviewURL)
            self.present(vc, animated: true, completion: nil)

        }
        else if titleLabel == "Coming Soon"{
            defaults.set("https://tnlrtechnologies.com/ComingSoon.html", forKey: "url")
            self.present(vc, animated: true, completion: nil)

        }
        else if titleLabel == "FAQ"{
            defaults.set("https://vidushimeel.github.io/tonnelier/openSourceInfo.html", forKey: "url")
            self.present(vc, animated: true, completion: nil)

        }
        else if titleLabel == "Legal"{
            defaults.set("https://tnlrtechnologies.com/legal.html", forKey: "url")
            self.present(vc, animated: true, completion: nil)

        }
        else if titleLabel == "Contact us"{
            //contact us
            defaults.set("https://www.linkedin.com/company/tonnelier-tech/", forKey: "url")
            self.present(vc, animated: true, completion: nil)

        }
        else {
            defaults.set(nil, forKey: "navigation")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "OpeningViewController")
            UIApplication.shared.keyWindow?.rootViewController = mainTabBarController
        }
    }
    
 
    @IBOutlet weak var sideMenuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "SideMenuTableViewCell", bundle: nil)
        self.sideMenuTableView.register(nib, forCellReuseIdentifier: "SideMenuTableViewCell")
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.delegate = self

        self.sideMenuTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.sideMenuTableView.backgroundColor = UIColor.clear
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.delegate = self
        if indexPath.row == 0{
            cell.cellTitleLabel.text = "Help Center"
        }
        else if indexPath.row == 1{
            cell.cellTitleLabel.text = "Feedback"
        }
        else if indexPath.row == 2{
            cell.cellTitleLabel.text = "Coming Soon"
        }
        else if indexPath.row == 3{
            cell.cellTitleLabel.text = "FAQ"
        }
        else if indexPath.row == 4{
            cell.cellTitleLabel.text = "Legal"
        }
        else if indexPath.row == 5{
            cell.cellTitleLabel.text = "Contact us"
        }
        else{
            cell.cellTitleLabel.text = "Back to Home Page"
            cell.cellTitleLabel.font = UIFont(name:"Avenir Light", size: 17.0)
        }
      
        return cell
    }
}
