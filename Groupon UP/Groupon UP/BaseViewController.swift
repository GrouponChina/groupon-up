//
//  BaseViewController.swift
//  Groupon UP
//
//  Created by Robert Xue on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        addLayouts()
        initializeUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        refreshUI()
    }
    
    func addSubviews() {
        
    }
    
    func addLayouts() {
        
    }
    
    func initializeUI() {
        
    }
    
    func refreshUI() {
        
    }
    
}