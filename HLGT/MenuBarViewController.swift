//
//  MenuBarViewController.swift
//  HLGT
//
//  Created by MAC on 7/24/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit

class MenuBarTableViewController: UITableViewController {
    
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        //menuBarButton.target = revealViewController()
        //menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
