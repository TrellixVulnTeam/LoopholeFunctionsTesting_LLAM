//
//  LoginViewController.swift
//  FirebaseFunction
//
//  Created by Sami Ali on 11/6/17.
//  Copyright © 2017 Sami Ali. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    var firstRun = true
    @IBOutlet weak var userNameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstRun{
            if let userName = UserDefaults.standard.string(forKey: "kUSER_NAME"){
                initUser(userName)
                self.performSegue(withIdentifier: "toViewController", sender: nil)
            }
            firstRun = false
        }
    }

    @IBAction func logIn(_ sender: UIButton) {
        if (userNameTF.text?.isEmpty)!{
            return
        }
        guard let userName = userNameTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
            return
        }
        UserF.shared().checkIfUserAlreadyExists(currentUserName: userName) { (result) in
            self.initUser(userName)
            let token = Messaging.messaging().fcmToken ?? ""
            UserDefaults.standard.set(userName, forKey: "kUSER_NAME")
            UserDefaults.standard.set(token, forKey: "kUSER_TOKEN")
            UserDefaults.standard.synchronize()
            if result {
                UserF.shared().updateUserPushId(token)
            }else{
                UserF.shared().createUser(token)
            }
        }
        self.performSegue(withIdentifier: "toViewController", sender: sender)
    }
    
    func initUser(_ name: String){
        let token = Messaging.messaging().fcmToken ?? ""
        UserF.shared().userName = name
        UserF.shared().pushId = token
    }
    
    func checkIfUserAlreadyExists(){
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
