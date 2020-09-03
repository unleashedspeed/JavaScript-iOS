//
//  VaccineTrialViewController.swift
//  JavaScript
//
//  Created by Saurabh Gupta on 03/09/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import UIKit
import WebKit

class VaccineTrialViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    enum Operation: String {
        case vaccineTypeAHumanTrial
        case vaccineTypeAAnimalTrial
        case vaccineTypeBHumanTrial
        case vaccineTypeBAnimalTrial
    }
    
    @IBOutlet weak var vaccineTypeAHumanTrialProgressBar: HorizontalProgressBar!
    @IBOutlet weak var vaccineTypeAAnimalTrialProgressBar: HorizontalProgressBar!
    @IBOutlet weak var vaccineTypeBHumanTrialProgressBar: CircularProgressBar!
    @IBOutlet weak var vaccineTypeBAnimalTrialProgressBar: CircularProgressBar!
    
    @IBOutlet weak var vaccineTypeAHumanTrialLabel: UILabel!
    @IBOutlet weak var vaccineTypeAAnimalTrialLabel: UILabel!
    @IBOutlet weak var vaccineTypeBHumanTrialLabel: UILabel!
    @IBOutlet weak var vaccineTypeBAnimalTrialLabel: UILabel!
    
    var webView: WKWebView!
    let messageHandler: MessageHandler = .jumbo
    let operations: [Operation] = [.vaccineTypeAHumanTrial, .vaccineTypeAAnimalTrial, .vaccineTypeBHumanTrial, .vaccineTypeBAnimalTrial]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "COVID-19 Vaccine Trials"
        
        setupWebView()
        setupProgressBars()
        setupLabels()
        addOperations()
    }
    
    private func setupWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true

        let configuration = WKWebViewConfiguration()
        let javaScript = getJavaScript()
        let script = WKUserScript(source: javaScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)

        configuration.preferences = preferences
        configuration.userContentController.addUserScript(script)
        configuration.userContentController.add(self, name: messageHandler.rawValue)
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // Not sure if this is required at all, but if I don't evaluate whole javascript then It never invokes 'startOperation'
        webView.evaluateJavaScript(javaScript) { result, error in
            if error != nil {
                self.showErrorToast(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    private func setupProgressBars() {
        view.bringSubviewToFront(vaccineTypeAHumanTrialProgressBar)
        view.bringSubviewToFront(vaccineTypeAAnimalTrialProgressBar)
        view.bringSubviewToFront(vaccineTypeBHumanTrialProgressBar)
        view.bringSubviewToFront(vaccineTypeBAnimalTrialProgressBar)
    }
    
    private func setupLabels() {
        view.bringSubviewToFront(vaccineTypeAHumanTrialLabel)
        view.bringSubviewToFront(vaccineTypeAAnimalTrialLabel)
        view.bringSubviewToFront(vaccineTypeBHumanTrialLabel)
        view.bringSubviewToFront(vaccineTypeBAnimalTrialLabel)
    }
    
    private func getJavaScript() -> String {
        if let url = URL(string: "https://nistruct.com/test/interview_bundle.js") {
            do {
                return try String(contentsOf: url)
            } catch {
                return ""
            }
        }
        
        return ""
    }
    
    private func addOperations() {
        for operation in operations {
            webView.evaluateJavaScript("startOperation('\(operation.rawValue)')") { result, error in
                if error != nil, let errorMessage = (error! as NSError).userInfo["WKJavaScriptExceptionMessage"] as? String {
                    self.showErrorToast(message: errorMessage)
                }
            }
        }
    }
    
    private func handleMessage(_ messageBody: String?) {
        if let data = messageBody?.data(using: String.Encoding.utf8) {
            do {
                let decoder = JSONDecoder()
                let message = try decoder.decode(Message.self, from: data)
                
                switch message.type {
                case .progress:
                    updateProgressBarWith(progressPercent: message.progress ?? 0, for: message.id ?? "")
                case .completed:
                    switch message.state {
                    case .error:
                        updateLabelForError(id: message.id ?? "")
                    case .success:
                        updateProgressBarWith(progressPercent: 100, for: message.id ?? "")
                        updateLabelForSuccess(id: message.id ?? "")
                    case .started:
                        updateProgressBarWith(progressPercent: 1, for: message.id ?? "")
                    case .none:
                        break
                    }
                case .none:
                    break
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateProgressBarWith(progressPercent: Int, for id: String) {
        let operation = Operation(rawValue: id)
        switch operation {
        case .vaccineTypeAHumanTrial:
            vaccineTypeAHumanTrialProgressBar.progress = CGFloat(progressPercent)/100.0
        case .vaccineTypeAAnimalTrial:
            vaccineTypeAAnimalTrialProgressBar.progress = CGFloat(progressPercent)/100.0
        case .vaccineTypeBHumanTrial:
            vaccineTypeBHumanTrialProgressBar.progress = CGFloat(progressPercent)/100.0
        case .vaccineTypeBAnimalTrial:
            vaccineTypeBAnimalTrialProgressBar.progress = CGFloat(progressPercent)/100.0
        case .none:
            break
        }
    }
    
    private func updateLabelForSuccess(id: String) {
        let operation = Operation(rawValue: id)
        switch operation {
        case .vaccineTypeAHumanTrial:
            vaccineTypeAHumanTrialLabel.text = "COVID Vaccine TypeA Human Trial Success"
            vaccineTypeAHumanTrialLabel.textColor = UIColor.darkGreen()
        case .vaccineTypeAAnimalTrial:
            vaccineTypeAAnimalTrialLabel.text = "COVID Vaccine TypeA Animal Trial Success"
            vaccineTypeAAnimalTrialLabel.textColor = UIColor.darkGreen()
        case .vaccineTypeBHumanTrial:
            vaccineTypeBHumanTrialLabel.text = "COVID Vaccine TypeB Human Trial Success"
            vaccineTypeBHumanTrialLabel.textColor = UIColor.darkGreen()
        case .vaccineTypeBAnimalTrial:
            vaccineTypeBAnimalTrialLabel.text = "COVID Vaccine TypeB Animal Trial Success"
            vaccineTypeBAnimalTrialLabel.textColor = UIColor.darkGreen()
        case .none:
            break
        }
    }
    
    private func updateLabelForError(id: String) {
        let operation = Operation(rawValue: id)
        switch operation {
        case .vaccineTypeAHumanTrial:
            vaccineTypeAHumanTrialLabel.text = "COVID Vaccine TypeA Human Trial Failed"
            vaccineTypeAHumanTrialLabel.textColor = .red
        case .vaccineTypeAAnimalTrial:
            vaccineTypeAAnimalTrialLabel.text = "COVID Vaccine TypeA Animal Trial Failed"
            vaccineTypeAAnimalTrialLabel.textColor = .red
        case .vaccineTypeBHumanTrial:
            vaccineTypeBHumanTrialLabel.text = "COVID Vaccine TypeB Human Trial Failed"
            vaccineTypeBHumanTrialLabel.textColor = .red
        case .vaccineTypeBAnimalTrial:
            vaccineTypeBAnimalTrialLabel.text = "COVID Vaccine TypeB Animal Trial Failed"
            vaccineTypeBAnimalTrialLabel.textColor = .red
        case .none:
            break
        }
    }
}

extension VaccineTrialViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let messageHandler = MessageHandler(rawValue: message.name)
        // We can use switch here when we will have multiple different message handlers.
        if messageHandler == .jumbo {
            handleMessage(message.body as? String)
        }
    }
    
}

