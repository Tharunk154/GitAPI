//
//  ViewController.swift
//  GitAPI
//
//  Created by  Tharun on 01/12/17.
//  Copyright © 2017 Tharun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userFieldCenterYC: NSLayoutConstraint!
    @IBOutlet weak var submitBottomC: NSLayoutConstraint!
    
    var respositoryList: [[String: AnyObject]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidAppear(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        userNameField.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1).cgColor
        userNameField.layer.borderWidth = 1
        userNameField.layer.masksToBounds = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        userNameField.resignFirstResponder()
        if userNameField.text?.count == 0 {
            self.showAlert(message: "Enter User Name")
        }else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            NetworkManager.shared.getPublicRepositories(forUser: userNameField.text!, { (response, json, error) -> (Void) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                }else {
                    print("Response \(String(describing: json))")
                    if json is [[String: AnyObject]] {
                        self.respositoryList = json as? [[String : AnyObject]]
                        self.performSegue(withIdentifier: "detailsVc", sender: self)
                    }else {
                        self.showAlert(message: (json!["message"] as? String)!)
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsVc" {
            let controller = segue.destination as! DetailsViewController
            controller.repositoriesList = self.respositoryList
        }
    }
    
    fileprivate func showAlert(message: String) {
        let controller = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController {
    @objc func keyboardDidAppear(notification: Notification) {
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            submitBottomC.constant = (frame?.size.height)!
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
            submitBottomC.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
