//
//  DetailViewController.swift
//  Project7
//
//  Created by margaret on 2019-04-23.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // unwrapp the detailItem if it has a value
        guard let detailItem = detailItem else { return }
        
        let html = """
            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style> body { font-size: 150%; }
                            h4 { text-align:center; }
                    </style>
                </head>
                <body>
                    <h4>\(detailItem.title)</h4>
                    <hr>
                    <p><blockquote>
                    \(detailItem.body)
                    </blockquote></p>
                </body>
            </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
        
    }
}
