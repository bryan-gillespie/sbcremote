//
//  LoginViewController.swift
//  PiRemote
//
//  Authors: Hunter Heard, Josh Binkley
//  Copyright (c) 2016 JLL Consulting. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController {

    // Link to views shown in storyboard
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var displayMessage: UILabel!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var usernameBox: UITextField!

    // Local variables
    var segueIdDeviceDetails = "SHOW DEVICE DETAILS"
    var segueIdDevicesTable = "SHOW DEVICES"
    var isLoginSuccess: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isLoginSuccess = false
        if (MainUser.sharedInstance.currentDevice != nil) {
            deviceName.text = MainUser.sharedInstance.currentDevice?.deviceAlias
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Login Button
    @IBAction func handleTapLogin() {
        let passw = passwordBox.text
        let usern = usernameBox.text

        if(passw == "") {
            self.displayMessage.text = "Please enter a password.";
            return
        }

        if (self.title == "Remote Login") {
            logIntoWeaved(username: usern!, password: passw!)
        } else {
            logIntoWebIOPi(username: usern!, password: passw!)
        }
    }

    func logIntoWeaved (username: String, password: String) {
        let weavedAPIManager = RemoteAPIManager();
        weavedAPIManager.logInUser(username: username, userpw: password, callback: {
            sucess, response, data in
            DispatchQueue.main.async {
                self.loginIndicator.stopAnimating();
                self.displayMessage.text = response
                guard data != nil else{
                    return
                }

                // Fills out the user information with the data returned from response
                MainUser.sharedInstance.getUserInformationFromResponse(dictionary: data!)

                self.isLoginSuccess = true

                // Supported by iOS <6.0
                self.performSegue(withIdentifier: self.segueIdDevicesTable, sender: self)
            }
        })
    }


    func logIntoWebIOPi(username: String, password: String) {
        // TODO: Implement. (We're using username as 'webiopi' and password as 'raspberry' for all pi's at the moment.
        // Supported by iOS <6.0
        self.performSegue(withIdentifier: self.segueIdDeviceDetails, sender: self)
    }

    //because persistant text is annoying
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
