//
//  showHistoryTableViewController.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/20/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit
class result{
    var datevalue : String
    var ratevalue : String
    init(datevalue : String,ratevalue : String) {
        self.datevalue = datevalue
        self.ratevalue = ratevalue
    }
}
class showHistoryTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var finalresult: [result] = []
    var final: [String] = []
    var data: [String] = []
    var cur1 = ""
    var cur2 = ""
    var d1 = ""
    var d2 = ""
    var countrycode1 = ""
    var countrycode2 = ""
    let dbm:SQLiteDB = SQLiteDB.shared
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return finalresult.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "historycell") as! historyTableViewCell
       let re = finalresult[indexPath.row]
        cell.dateLabel.text = re.datevalue
        
       cell.fromLabel.text = "1\(cur1)"
        
        
       cell.toLabel.text = re.ratevalue + cur2
        
        return cell
        DispatchQueue.main.async {
            self.tableView.reloadData()
         
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 10
    }
    
    
    func getdata(completion: @escaping ([result]) -> Void) {
        
        dbm.open()
        let dataURL = "https://currencies.apps.grandtrunk.net/getrange/"+d1+"/"+d2+"/"+countrycode1.lowercased()+"/"+countrycode2.lowercased()
        print(dataURL)
        let datalatestURL = URL(string: dataURL)
        let request1 = URLRequest(url: datalatestURL!)
        let session1 = URLSession(configuration: URLSessionConfiguration.default)
        let task1 = session1.dataTask(with: request1){ (data,response,error) in
            guard error == nil else{
                return
            }
            guard data != nil else{
                return
            }
               let dictionary1 = NSString(data:data!, encoding:String.Encoding.utf8.rawValue) as? String
                    
            
            self.final = dictionary1!.components(separatedBy: "\n")
           // print(self.final)
            let cc = (self.final.count) - 2
            
            for index in 0...cc {
                let mm = result(datevalue: "", ratevalue: "")
                let bb = self.final[index].components(separatedBy: " ")
                mm.datevalue = bb[0]
                let ee = Double(bb[1]) ?? 0.0
                let roundedString = String(format: "%.3f", ee)
                let ff = String(roundedString) ?? ""
                mm.ratevalue = ff
                self.finalresult.append(mm)
                print(mm.datevalue )
            }
            completion(self.finalresult)
        }
        task1.resume()
       
        tableView.reloadData()
        
      
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateLabel.text = "\(data[2]) ----> \(data[3])"
        countryLabel.text = "\(data[0]) ----> \(data[1])"
       let code1 = getcountrycode(name: data[0])
       let code2 = getcountrycode(name: data[1])
        cur1 = listCountriesAndCurrencies(code: code1)
        cur2 = listCountriesAndCurrencies(code: code2)
        countrycode1 = getcurrency(name: data[0])
         countrycode2 = getcurrency(name: data[1])
        d1 = data[2]
        d2 = data[3]
        
        
        
        getdata { (finalresult) -> Void in
           
        }
       
    }
    
    func getcurrency(name:String) -> String{
        var c = ""
        let cmd1 = "SELECT * from tblcountry"
        let crows =  self.dbm.query(sql: cmd1)
        for row in crows {
            let na1 = row["countryname"] as! String
            if(name == na1)
            {
                c = row["codealpha"] as! String
            }
        }
        return c
    }
    func getcountrycode(name:String) -> String{
        var c = ""
        let cmd1 = "SELECT * from tblcountry"
        let crows =  self.dbm.query(sql: cmd1)
        for row in crows {
            let na1 = row["countryname"] as! String
            if(name == na1)
            {
                c = row["countrycode"] as! String
            }
        }
        return c
    }
 
    func listCountriesAndCurrencies(code:String) -> String{
        var currencysign = ""
        let localeIds = Locale.availableIdentifiers
        var countryCurrency = [String: String]()
        for localeId in localeIds {
            let locale = Locale(identifier: localeId)
            
            if let country = locale.regionCode, country.characters.count == 2 {
                if let currency = locale.currencySymbol {
                    countryCurrency[country] = currency
                }
            }
        }
        
        let sorted = countryCurrency.keys.sorted()
        for country in sorted {
            let currency = countryCurrency[country]!
            if(country == code)
            {
                currencysign = currency
            }
            //print("country: \(country), currency: \(currency)")
        }
        return currencysign
    }

}
