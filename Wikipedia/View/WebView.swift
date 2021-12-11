//
//  WebView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 07/12/21.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let navigationHelper = WebViewHelper()

    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webview = WKWebView()
        webview.navigationDelegate = navigationHelper

        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)

        return webview
    }

    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<WebView>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.navigationDelegate = navigationHelper

        webview.load(request)
    }
}

        

class WebViewHelper: NSObject, WKNavigationDelegate {
    
    let script: String
    
    override init() {
        if let filepath = Bundle.main.path(forResource: "script", ofType: "js") {
            do {
                script = try String(contentsOfFile: filepath)
            } catch {
                script = ""
            }
        } else {
           script = ""
        }
        super.init()
    }
    
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // Inject Javascript on page
        webView.evaluateJavaScript(script, completionHandler: nil)
    }

}

#if DEBUG
struct WebView_Previews : PreviewProvider {
    static var previews: some View {
        WebView(url: URL(string: "https://www.apple.com")!)
    }
}
#endif
