//
//  WelcomeViewController.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/10/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OperationQueue.main.addOperation {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.gotoHome), userInfo: nil, repeats: false)
            
        }
        
        
      
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func gotoHome(){
        performSegue(withIdentifier: "welcomesegue", sender: nil)
        
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
