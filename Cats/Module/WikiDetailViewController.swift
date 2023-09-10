//
//  WikiDetailViewController.swift
//  Cats
//
//  Created by Artem Sulzhenko on 10.09.2023.
//

import UIKit
import WebKit

class WikiDetailViewController: UIViewController {

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        return webView
    }()
    
    private var viewModel: WikiDetailViewControllerViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.isOpaque = false

        addSubview()
        configureLayout()
        configureNavigationBar()
        loadWebSite(url: viewModel?.url ?? "")
    }

    init(viewModel: WikiDetailViewControllerViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubview() {
        [webView].forEach(view.addSubview)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        navigationController?.navigationBar.tintColor = .brown
        navigationItem.title = "Wiki Cat"
        navigationItem.largeTitleDisplayMode = .never
    }

    private func loadWebSite(url: String) {
        guard let wikiUrl = URL(string: url) else { return }
        webView.load(URLRequest(url: wikiUrl))
    }
}

extension WikiDetailViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
