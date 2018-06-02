//
//  MenuViewController.swift
//  FinalProject
//
//  Created by Daniel Koberstein on 4/29/18.
//  Copyright © 2018 Daniel Koberstein. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var portfolioButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 0.8, green: 1.0, blue: 0.8, alpha: 0.0)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        searchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        portfolioButton.titleLabel?.adjustsFontSizeToFitWidth = true
        storeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
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

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
