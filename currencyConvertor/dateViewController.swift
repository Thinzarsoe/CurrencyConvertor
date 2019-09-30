//
//  dateViewController.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/19/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit

class dateViewController: UIViewController {
 var name:(String) = ""
  var selectdate = ""
    

    @IBAction func ValueChange(_ sender: UIDatePicker) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
       selectdate = formatter.string(from: sender.date)
        
    }
    
    
    @IBAction func selectDateBtn(_ sender: UIButton) {
       
        performSegue(withIdentifier: "afterselectdatesegue", sender: selectdate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "afterselectdatesegue" {
            let detailVC =  segue.destination as? HomeViewController
            detailVC?.selectdate = sender as! String
            
            _ = self.navigationController?.popViewController(animated: true)
            
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
