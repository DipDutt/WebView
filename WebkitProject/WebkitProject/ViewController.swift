//
//  ViewController.swift
//  WebkitProject
//
//  Created by Dip on 17/6/25.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate{
    // MARK: - Properties
    @objc var webView: WKWebView!
    var showPrgressView: UIProgressView!
    
    // MARK: - Create loadView method.
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    //  MARK: - viewDidLoad method.
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        loadWebView()
    }
    
    // MARK: - Create loadUI Method.
    func loadUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target:webView, action: #selector(webView.reload))
        showPrgressView = UIProgressView(progressViewStyle: .default)
        showPrgressView.sizeToFit()
        let progressBarButtonItem = UIBarButtonItem(customView: showPrgressView)
        toolbarItems = [spacer,refresh,progressBarButtonItem]
        navigationController?.isToolbarHidden = false
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    // MARK: - create loadWebView method
    
    func loadWebView() {
        guard let url = URL(string: WebsiteEnum.x.rawValue) else {return}
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    
    // MARK: - Create openTapped method to show Aleart.
    @objc func openTapped() {
        let alertController = UIAlertController(title: "Webpages📄", message: "click 🫵🏼 on website pages to enter the specific webpage", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: WebsiteEnum.apple.rawValue , style:.default, handler: { alertaction in
            self.openPage(action: alertaction)
        }))
        alertController.addAction(UIAlertAction(title: WebsiteEnum.google.rawValue, style:.default, handler: { alertaction in
            self.openPage(action: alertaction)
        }))
        
        alertController.addAction(UIAlertAction(title: WebsiteEnum.invalid.rawValue, style:.default, handler: { alertaction in
            self.openPage(action: alertaction)
            let ac = UIAlertController(title: "It's blocked❌", message: " you can't access this website🚫", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(ac, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    // MARK: -  create openPage method to set webpage with action titile
    func openPage(action: UIAlertAction) {
        guard let url = URL(string: "https://" + (action.title ?? "no title")) else {return}
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - this method for show webpage title after scroll finish.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    // MARK: - Create observeValue method to set progress bar progress Value.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            showPrgressView.progress = 0.0
            showPrgressView.progress = Float(webView.estimatedProgress)
            
        }
    }
    
}

