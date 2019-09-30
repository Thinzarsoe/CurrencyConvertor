//
//  selectCountryViewController.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/10/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit

class country {
    var currency : String
    var name : String
    var emoji : String?
    
    init(currency : String, name : String, emoji : String) {
        self.currency = currency
        self.name = name
        self.emoji = emoji
    }
}

class selectCountryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
 
    var countries: [country] = []
   var flag = [String: String]()
    var selectedCountry = ""
    @IBOutlet weak var countryListPicker: UIPickerView!
    
    
    @IBAction func selectBtn(_ sender: UIButton) {
         let name = selectedCountry
        print(name)
       performSegue(withIdentifier: "afterselectsegue", sender: name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "afterselectsegue" {
            let name = sender as! String
            let detailVC = segue.destination as! HomeViewController
            detailVC.name = name
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return countries.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].emoji! + "    " + countries[row].name
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
        selectedCountry = countries[row].name
       // selectedCountry = "Japan"
        
    }
    let dbm:SQLiteDB = SQLiteDB.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryListPicker.delegate = self
        self.countryListPicker.dataSource = self
        print("jjjjj")
        
        OperationQueue.main.addOperation {
         
            
            self.fetchCountry()
        }
      
        // Do any additional setup after loading the view.
    }
    
    func fetchCountry(){
        dbm.open()
       // let URLString = "https://unpkg.com/country-flag-emoji-json@1.0.2/json/flag-emojis.pretty.json"
        
//        let URLString = "https://raw.githubusercontent.com/annexare/Countries/master/data/countries.json"
        
        
        
        let flagURL = "https://unpkg.com/country-flag-emoji-json@1.0.2/json/flag-emojis.pretty.json"
        
        
        guard let flaglatestURL = URL(string: flagURL) else{
            print("Invalid URl")
            return
        }
        
        let request1 = URLRequest(url: flaglatestURL)
        let session1 = URLSession(configuration: URLSessionConfiguration.default)
        let task1 = session1.dataTask(with: request1){ (data,response,error) in
            guard error == nil else{
                return
            }
            guard data != nil else{
                return
            }
            
            do{
                
                if let dictionary1 = try  JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String:Any]]
                {
                    
                    for w in dictionary1 {
                        let a = w["name"] as! String
                        let b = w["emoji"] as! String
                        self.flag[a] = b
                    }
                }
                print("pppppppp")
                print(self.flag)
                let cmd = "SELECT * from tblcountry"
                let rows =  self.dbm.query(sql: cmd)
                for row in rows {
                    let na = row["countryname"] as! String
                    let cur = row["codealpha"] as! String
                    var emo = ""
                    for (key2,value2) in self.flag {
                        if key2 == na{
                            emo = value2
                        }
                    }
                    
                    let maria = country(currency: cur, name: na, emoji: emo)
                    self.countries.append(maria)
                }
                self.countryListPicker.reloadAllComponents()
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        task1.resume()
        
        
        
        
        
        
        
        
        
        
        
//
//        guard let latestURL = URL(string: URLString) else{
//            print("Invalid URl")
//            return
//        }
//
//        let request2 = URLRequest(url: latestURL)
//        let session = URLSession(configuration: URLSessionConfiguration.default)
//        let task = session.dataTask(with: request2){ (data,response,error) in
//            guard error == nil else{
//                return
//            }
//            guard data != nil else{
//                return
//            }
//            print("Hey, I got data....")
//            do{
//                if let dictionary = try  JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
//                {
//                    print(dictionary.count)
//                    for (key1,value1) in dictionary {
//                        //print("My key is \(key) and it has a value of \(value)")
//                        let main = dictionary[key1] as? [String:Any]
//                        let na = main?["name"] as! String
//                        let cur = main?["currency"] as! String
//                        var emo = ""
//                        for (key2,value2) in self.flag {
//                            if key2 == na{
//                                emo = value2
//                            }
//
//                        }
//                        print(self.flag)
//
//                        let maria = country(currency: cur, name: na, emoji: emo)
//                        self.countries.append(maria)
//
//                    }
//
//                    self.countryListPicker.reloadAllComponents()
//                }
//
//            }
//            catch let error {
//                print(error.localizedDescription)
//            }
//        }
//        task.resume()
        
       // let URLString = apiURLString +  "Yangon" + "&units=metric&appid=" + apikey
        

        
    }
    func getData(){
  
        
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
