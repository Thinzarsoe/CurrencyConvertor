//
//  exchangeViewController.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/10/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit

class exchangeViewController: UIViewController,UITextFieldDelegate {
    
    var cur: [currency] = []
    @IBOutlet weak var fromflag: UILabel!
    
     @IBOutlet weak var fromcurrency: UILabel!
    
     @IBOutlet weak var toflag: UILabel!
    
     @IBOutlet weak var tocurrency: UILabel!

    @IBOutlet weak var fromrateTextField: UITextField!
    
    @IBOutlet weak var torateTextField: UITextField!
    
    
    
    @IBAction func textFieldEditingChange(_ sender: Any) {
        let rate1 = fromrateTextField.text!
        let ee = Double(rate1) ?? 0.0
        let aa = Double(cur[0].exchangerate) ?? 0.0
        let result = aa*ee
        torateTextField.text = String(result) ?? ""
    }

    
    @IBAction func textFieldEditingChange1(_ sender: UITextField) {
        let rate1 = torateTextField.text!
        let ee = Double(rate1) ?? 0.0
        let aa = Double(cur[0].exchangerate) ?? 0.0
        let result = ee/aa
        fromrateTextField.text = String(result) ?? ""
        
    }
    

    
    @IBAction func clearBtn(_ sender: UIButton) {
        fromrateTextField.text = ""
        torateTextField.text = ""
    }
    
    
    @IBAction func historicalBtn(_ sender: UIButton) {
        //historicaldatasegue
        
        performSegue(withIdentifier: "historicaldatasegue", sender: cur)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historicaldatasegue" {
            let detailVC =  segue.destination as? historicalViewController
            
            detailVC?.cur = sender as! [currency]
            
        }
    }
            

    override func viewDidLoad() {
        super.viewDidLoad()
        fromrateTextField.delegate = self
        torateTextField.delegate = self
        fromflag.text = cur[0].countryflag
        fromcurrency.text = cur[0].currencyname
        toflag.text = cur[1].countryflag
        tocurrency.text = cur[1].currencyname
        
        }

    
    }
   


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



