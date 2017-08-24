//
//  ViewController.swift
//  WebViewDemo
//
//  Created by Chirayu-Flybits on 2017-08-17.
//  Copyright © 2017 Flybits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textField : UITextField!
    var url = "https://s3.amazonaws.com/tdgotransit.flybits.com/utils/message.html"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        self.navigationController?.isNavigationBarHidden = true
        self.textField.text = url
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func didSubmit(sender : Any?) {
        print("# Text Input URL - \(String(describing: textField.text))")
        if textField.text?.isEmpty == false, let url = textField.text {
            let st  = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebPage") as! WebViewController
            st.url = url
            self.present(st, animated: true, completion: nil)
        } else {
            let alert = UIAlertController.init(title: "Input valid url.", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

