//
//  ViewController.swift
//  TableDemo
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var viewModeButton: NSButton?
    
    @IBOutlet weak var selectedAmountLabel: NSTextField?
    
    
    
    // MARK: - Properties
    
    var viewModel = ViewModel()
    
    var originalColumns = [NSTableColumn]()
    
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    
    // MARK: - IBAction Methods
    
    @IBAction func switchDisplayMode(_ sender: Any) {
        
    }
    
    
    
    // MARK: - Custom Methods
    
    func showAlert(forPurchase purchase: Purchases) {
        var user = "User"
        var displayAmount = "$0"
        if let username = purchase.userInfo?.username {
            user = username
        }
        if let amount = purchase.paymentInfo?.amount {
            displayAmount = amount
        }
        
        let alert = NSAlert()
        alert.messageText = "\(user) spent \(displayAmount) in purchases over the last 24 hours."
        alert.beginSheetModal(for: self.view.window!) { (response) in
            
        }
    }
    
}

