//
//  DetailViewController.swift
//  Project4
//
//  Created by margaret on 2019-03-28.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit
// Importing WebKit framework in order to work with web views
import WebKit

// create a new subclass of UIViewController called DetailViewController, and tell the compiler that we promise we’re safe to use as a WKNavigationDelegate
class DetailViewController: UIViewController, WKNavigationDelegate {

    // Storing the web view as a property in order to reference to it later on
    var webView: WKWebView!
    
    var progressView: UIProgressView!
    // Store the name of the site that was selected on the previous screen
    var selectedWebsite: String?
    
    var blockedWebsites = ["google.com"]
    var websites = ["apple.com", "hackingwithswift.com", "brave.com"]

    
    override func loadView() {
        // creating an instance of web view property
        webView = WKWebView()
        // when any web page navigation happens, please tell that to the current view controller
        webView.navigationDelegate = self
        // make our view (the root view of the view controller) that web view
        view = webView
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        // creates a new UIProgressView instance, giving it the default style
        progressView = UIProgressView(progressViewStyle: .default)
        // tell the progress view to set its layout size so that it fits its contents fully
        progressView.sizeToFit()
        // creates a new UIBarButtonItem using the customView parameter, which is where we wrap up our UIProgressView in a UIBarButtonItem so that it can go into our toolbar
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // creates a new bar button item using the special system item type .flexibleSpace, which creates a flexible space. It doesn't need a target or action because it can't be tapped
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .done, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", style: .done, target: webView, action: #selector(webView.goForward))
        
        // creates an array containing the flexible space, refresh button, and the rest of the bar button items then sets it to be our view controller's toolbarItems array
        // UIToolbar holds and shows a collection of UIBarButtonItem objects that the user can tap on.
        toolbarItems = [progressButton, spacer, back, forward, spacer, refresh]
        // sets the navigation controller's isToolbarHidden property to be false, so the toolbar will be shown – and its items will be loaded from our current view.
        navigationController?.isToolbarHidden = false
        //  addObserver() method takes four parameters: who the observer is (we're the observer, so we use self), what property we want to observe (we want the estimatedProgress property of WKWebView), which value we want (we want the value that was just set, so we want the new one), and a context value
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        
        // URL is a swift's way of storing the location of files
        // PLEASE NOTE: Connection has to be SECURE
        let url = URL(string: "https://" + selectedWebsite!)!
        // create a new URLRequest object from the above url
        // assign it to our webView to load
        webView.load(URLRequest(url: url))
        // enable a property on the web view that allows users to swipe from the left or right edge to move backward or forward in their web browsing
        webView.allowsBackForwardNavigationGestures = true
        
        
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // setting the alert controller’s popoverPresentationController?.barButtonItem property is used only on iPad, and tells iOS where it should make the action sheet be anchored.
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    // This method takes one parameter, which is the UIAlertAction object that was selected by the user.
    func openPage(action: UIAlertAction) {
        // use the title property of the action (apple.com, hackingwithswift.com), put "https://" in front of it to satisfy App Transport Security, then construct a URL out of it.
        let url = URL(string: "https://" + action.title!)!
        // then wraps that inside an URLRequest, and gives it to the web view to load
        webView.load(URLRequest(url: url))
    }
    
    //All this method does is update our view controller's title property to be the title of the web view, which will automatically be set to the page title of the web page that was most recently loaded.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    @objc func goBack() {
        webView.goBack()
    }
    
    @objc func goForward() {
        webView.goForward()
    }
 
    //  this method tells us which key path was changed, and it also sends us back the context we registered earlier so you can check whether this callback is for you or not
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // set the constant url to be equal to the URL of the navigation. This is just to make the code clearer
        let url = navigationAction.request.url
        // evaluate the URL to see whether it's in our safe list, then call the decisionHandler with a negative or positive answer
        // use if let syntax to unwrap the value of the optional url.host
        if let host = url?.host {
            // loop through all sites in our safe list, placing the name of the site in the website variable
            for website in websites {
                // use the contains() String method to see whether each safe website exists somewhere in the host name
                if host.contains(website) {
                    // if the website was found then we call the decision handler with a positive response - we want to allow loading
                    decisionHandler(.allow)
                    return
                }
            }
            // if the URL is from the block websites lists, add an alert and don't
            // load the website
            for block in blockedWebsites {
                if host.contains(block) {
                    let ac = UIAlertController(title: "BLOCKED", message: "This website is blocked", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK, I am Leaving", style: .destructive , handler: nil))
                    present(ac, animated: true)
                    decisionHandler(.cancel)
                    return
                }
            }
        }
        // if there is no host set, or if we've gone through all the loop and found nothing, we call the decision handler with a negative response: cancel loading
        decisionHandler(.cancel)
    }
    
}

