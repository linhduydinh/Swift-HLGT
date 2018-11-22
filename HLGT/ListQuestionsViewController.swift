//
//  ListQuestionsViewController.swift
//  HLGT
//
//  Created by MAC on 11/21/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import Foundation

class ListQuestionsViewController: UIViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController.
        
        view.addSubview(questionName)
        // Set its constraint to display it on screen
        questionName.text = "This is label view. This is label view. This is label view. This is label view. This is label view."
        questionName.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        questionName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        questionName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
  
    }
    
    lazy var questionName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
}
