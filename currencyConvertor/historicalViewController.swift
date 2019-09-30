//
//  historicalViewController.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/20/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit

class historicalViewController: UIViewController {
 //var name:(String) = ""
   var cur: [currency] = []
   private var data :[String] = []

    let dbm:SQLiteDB = SQLiteDB.shared
    @IBOutlet weak var startDateLabel: UITextField!
    @IBOutlet weak var endDateLabel: UITextField!
    private var startdatePicker:UIDatePicker?
    private var enddatePicker:UIDatePicker?
    
    override func viewDidLoad() {
        data.append(cur[0].countryname)
        data.append(cur[1].countryname)
        
        
            startdatePicker = UIDatePicker()
            startdatePicker?.datePickerMode = .date
            startdatePicker?.addTarget(self, action: #selector(dateChanged(startdatePicker:)), for: .valueChanged)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
            view.addGestureRecognizer(tapGesture)
            startDateLabel.inputView = startdatePicker
        
        

            enddatePicker = UIDatePicker()
            enddatePicker?.datePickerMode = .date
            enddatePicker?.addTarget(self, action: #selector(dateChanged1(enddatePicker:)), for: .valueChanged)
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
            view.addGestureRecognizer(tapGesture1)
            endDateLabel.inputView = enddatePicker
        print("Hello")
      
    }
    
    

    
    
    @IBAction func showBtn(_ sender: UIButton) {
        
        startDateLabel.text = ""
        endDateLabel.text = ""
        
        performSegue(withIdentifier: "showtablesegue", sender: data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showtablesegue" {
            let detailVC =  segue.destination as? showHistoryTableViewController
            
            detailVC?.data = sender as! [String]
            
        }
        
        else if segue.identifier == "chartsegue" {
            let detailVC =  segue.destination as? showHistorywithLineChartViewController
            
            detailVC?.data = sender as! [String]
            
        }
    }
    
    
    @IBAction func showChartBtn(_ sender: UIButton) {
        startDateLabel.text = ""
        endDateLabel.text = ""
         performSegue(withIdentifier: "chartsegue", sender: data)
    }
    
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    @objc func dateChanged(startdatePicker:UIDatePicker)
    {
        startDateLabel.text = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let aa = formatter.string(from: startdatePicker.date)
        startDateLabel.text = aa
        data.append(aa)
        view.endEditing(true)
    }
    @objc func dateChanged1(enddatePicker:UIDatePicker)
    {
        endDateLabel.text = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let aa = formatter.string(from: enddatePicker.date)
        endDateLabel.text = aa
        data.append(aa)
        view.endEditing(true)
    }

}

