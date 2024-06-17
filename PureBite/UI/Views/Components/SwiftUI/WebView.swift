import SwiftUI
import WebKit
import Combine

public struct WebView: UIViewRepresentable {

    private let url: URL
    private let isFileUrl: Bool
    private var onPageOpened: ((URL?) -> Void)?
    private var onRedirect: ((URL?) -> Void)?

    private let shouldRefresh: CurrentValueSubject<Bool, Never>

    public init(
        url: URL,
        isFileUrl: Bool = false,
        onPageOpened: ((URL?) -> Void)? = nil,
        onRedirect: ((URL?) -> Void)? = nil,
        shouldRefresh: CurrentValueSubject<Bool, Never> = .init(false)
    ) {
        self.url = url
        self.isFileUrl = isFileUrl
        self.onPageOpened = onPageOpened
        self.onRedirect = onRedirect
        self.shouldRefresh = shouldRefresh
    }

    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        context.coordinator.webView = webView
        context.coordinator.observeChanges(for: shouldRefresh)

        if isFileUrl {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
            webView.load(request)
        }

        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(onPageOpened: onPageOpened, onRedirect: onRedirect)
    }

    public final class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {

        private var onPageOpened: ((URL?) -> Void)?
        private var onRedirect: ((URL?) -> Void)?

        weak var webView: WKWebView?
        private var cancellable: AnyCancellable?

        public init(
            onPageOpened: ((URL?) -> Void)?,
            onRedirect: ((URL?) -> Void)?
        ) {
            self.onPageOpened = onPageOpened
            self.onRedirect = onRedirect
        }

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { }

        public func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) { decisionHandler(.allow) }

        public func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationResponse: WKNavigationResponse,
            decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
        ) {
            onPageOpened?(navigationResponse.response.url)
            decisionHandler(.allow)
        }

        public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            if let url = webView.url {
                onRedirect?(url)
            }
        }

        @MainActor
        func observeChanges(for shouldRefresh: CurrentValueSubject<Bool, Never>) {
            cancellable = shouldRefresh
                .filter { $0 == true }
                .sink { [weak self] newValue in
                    self?.webView?.reload()
                }
        }
    }
}
