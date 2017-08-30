//
//  WebViewController.swift
//  WebViewDemo
//
//  Created by Chirayu-Flybits on 2017-08-17.
//  Copyright © 2017 Flybits. All rights reserved.
//

import UIKit
import WebKit

//let nativeToJS = "App.parseMessageFromNativeApp('{\"message\":\"Hello from iOS!\"}')"
let nativeToJS = "App.parseMessageFromNativeApp('{\"type\":\"data\",\"subtype\":\"message\",\"body\":{\"message\":{\"en\":\"Hello from Native App!\",\"fr\":\"Bonjour from Native App!\"}}}')"
let jsToNative = "parseWebAppMessage"

class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {
    
    var webView: WKWebView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!

    @IBOutlet weak var messages: UIBarButtonItem!
    
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    // Javascript callback messages
    var callbacksList : [String] = ["-------- * --------"]

    var url: String? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        
        // Create web view configuration
        let webCfg = WKWebViewConfiguration()
        // Create web view content controller
        let userController = WKUserContentController()

        // Add a script message handler for handling javascript callback message for native app
        userController.add(self, name: jsToNative)
        // Provide content controller to the configuration
        webCfg.userContentController = userController
        
        let frame = CGRect(x: 0, y: self.navBar.frame.height, width: self.view.frame.width, height: self.view.frame.height-self.navBar.frame.height-self.toolbar.frame.height)

        // Create a web view
        let webView = WKWebView(frame: frame, configuration: webCfg)
        
        // Provide user interface delegate to handle javascript callbacks e.g. alerts
        webView.uiDelegate = self

        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(webView)
        self.webView = webView
        updateView()

        // Disables bounces past edge of content and back again
        self.webView.scrollView.bounces = false
        
        self.view.bringSubview(toFront: activityView)
    }
    
    // Hides status bar for this view controller
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func doneClicked(sender: Any?) {
        print("doneClicked")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callbacksClicked(sender: Any?) {
        print("callbacksClicked")
        let st  = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CallbacksPage") as! CallbacksViewController
        st.items = callbacksList
        self.present(st, animated: true, completion: nil)
    }
    
    // Handle iOS Callback i.e. ios to javascript message
    @IBAction func jsClicked(sender: Any?) {
        print("jsClicked - \(nativeToJS)")
        // Call Javascript Function
        webView.evaluateJavaScript(nativeToJS) { (message, error) in
            print("# JS return response = \(String(describing: message)) || error - \(String(describing: error))")
        }
    }
    
    // Handle Javascript Callback i.e. javascript to native message
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == jsToNative) {
            print("JavaScript is sending a message \(message.body)")
            callbacksList.append("\(message.body)")
            messages.title = "Messages: \(callbacksList.count - 1)"
        }
    }

    @IBAction func refreshClicked() {
        webView.reload()
    }
    @IBAction func goBackClicked() {
        webView.goBack()
    }
    @IBAction func goForwardClicked() {
        webView.goForward()
    }

    func updateView() {
        if let webView = webView {
            if let url = url {
                loadVideo(url, webView: webView)
            } else {
                displayEmptyView(webView)
            }
        }
    }
    
    func loadVideo(_ url:String, webView:WKWebView) {
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    func displayEmptyView(_ webView:WKWebView) {
        let str = "<p>Not a valid url.<p>"
        webView.loadHTMLString(str, baseURL: nil)
    }
    
    // Handle Javascript Alert messages
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityView.stopAnimating()
    }
}
