//
//  EmbeddedWebViewController.swift
//  ZKFace
//
//  Created by Danna Lee on 2023/05/20.
//

import UIKit
import WebKit

class EmbeddedWebViewController: UIViewController {
    
    let isNavigationBarHidden: Bool
    let webUrl: String
    
    @IBOutlet weak var webView: WKWebView!
    
    init(webUrl: String, isNavigationBarHidden: Bool = false) {
        self.isNavigationBarHidden = isNavigationBarHidden
        self.webUrl = webUrl
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setWebView()
    }
    
    @IBAction func onClickCamera(_ sender: Any) {
        let vc = FaceCameraViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension EmbeddedWebViewController {
    private func setLayout() {
        navigationController?.isNavigationBarHidden = isNavigationBarHidden
        title = "wallet1 (0x1287...dfd)"
    }
    
    private func setWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "bridge")
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = contentController
        
        let components = URLComponents(string: webUrl)!
//        components.queryItems = [ URLQueryItem(name: "query", value: search) ]
        
        let request = URLRequest(url: components.url!)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(request)
    }
}

extension EmbeddedWebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("\(navigationAction.request.url?.absoluteString ?? "")" )
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            webView.isHidden = false
        }
    }
}

extension EmbeddedWebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
    
}

extension EmbeddedWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print(message.name)
    }
}
