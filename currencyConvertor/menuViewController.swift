//
//  menuViewController.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/10/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit

class menuViewController: UIViewController {

    @IBAction func selectLabel(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            performSegue(withIdentifier: "selectcountrysegue", sender: nil)
        
        case 1:
            performSegue(withIdentifier: "contactsegue", sender: nil)
            
            
            
        default:
            print("default")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
