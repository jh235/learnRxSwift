//
//  WebViewController.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/23.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private(set) var webView: WKWebView!
    
    var urlStr: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        guard let url = URL(string: urlStr) else {
            fatalError("urlStr can't be nil")
        }
        let request = URLRequest(url: url)
        webView.load(request)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_: WKWebView, decidePolicyFor _: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        title = title ?? webView.title
    }
}

extension WebViewController: WKUIDelegate {
    
    func webView(_: WKWebView, runJavaScriptAlertPanelWithMessage _: String, initiatedByFrame _: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, createWebViewWith _: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures _: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }
}
