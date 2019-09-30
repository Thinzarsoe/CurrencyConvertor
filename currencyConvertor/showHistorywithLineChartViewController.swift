//
//  showHistorywithLineChartViewController.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/21/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit
class showHistorywithLineChartViewController: UIViewController {

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
    @IBOutlet weak var LineChart: LineChart!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        countrycode1 = getcurrency(name: data[0])
        countrycode2 = getcurrency(name: data[1])
        d1 = data[2]
        d2 = data[3]
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0.3529411765, blue: 0.6156862745, alpha: 1)
       
        getdata { (finalresult) -> Void in
            let dataEntries = self.generateRandomEntries()
            self.LineChart.dataEntries = dataEntries
            self.LineChart.isCurved = false
            print(finalresult)
        }
        
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
    private func generateRandomEntries() -> [PointEntry] {
        var result: [PointEntry] = []
        for row in finalresult{
            if let myNumber = NumberFormatter().number(from: row.ratevalue) {
                var myInt = myNumber.intValue
                print(myInt)
                result.append(PointEntry(value: myInt, label: row.datevalue))
                // do what you need to do with myInt
            }
          
            
        }
//        for i in 0..<100 {
//            let value = Int(arc4random() % 500)
//
//            let formatter = DateFormatter()
//            formatter.dateFormat = "d MMM"
//            var date = Date()
//            date.addTimeInterval(TimeInterval(24*60*60*i))
//
//            result.append(PointEntry(value: value, label: formatter.string(from: date)))
//        }
        return result
    }
    
    }
