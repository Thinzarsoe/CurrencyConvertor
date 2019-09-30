//
//  HomeViewController.swift
//  currencyConvertor
//
//  Created by Thinzar Soe on 9/10/19.
//  Copyright © 2019 Thinzar Soe. All rights reserved.
//

import UIKit
class currency {
    var countryflag : String
    var countryname : String
    var currencyname : String
    var currencysymbol : String
    var exchangerate : String
    
    init(countryflag : String, countryname : String, currencysymbol:String,currencyname : String, exchangerate: String) {
        self.countryflag = countryflag
        self.countryname = countryname
        self.currencyname = currencyname
        self.currencysymbol = currencysymbol
        self.exchangerate = exchangerate
    }
}


enum EndPoint{
    
    case getpostEndPoint
    
    func url(id:String = "") -> String {
        let baseURLString = "https://currencies.apps.grandtrunk.net/getlatest/"
        switch self{
        case .getpostEndPoint:
            return baseURLString
        }
    }
    var method:String {
        switch self {
        case .getpostEndPoint:
            return "GET"
        }
    }
}
class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var name:(String) = ""
    var selectdate:(String) = ""
     var currencies: [currency] = []

    
    @IBOutlet weak var dateLabel: UILabel!
   
    @IBAction func myBtn(sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            performSegue(withIdentifier: "menusegue", sender: nil)
        default:
            print("default")
        }
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
  
    
    @IBAction func datecontrol(_ sender: UISegmentedControl) {
       switch segmentControl.selectedSegmentIndex
            
            {
                
                case 0: print("first")
                
                case 1: performSegue(withIdentifier: "datesegeu", sender: name)
                
                default:
                
                break;
                
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! currencyTableViewCell //type casting
    let cur = currencies[indexPath.row]
        cell.flagLabel.text = cur.countryflag
        cell.countrynameLabel.text = cur.countryname
        cell.currencyLabel.text = cur.currencyname
        let code = getcountrycode()
        let sign = listCountriesAndCurrencies(code: code)
        cell.rateLabel.text = cur.exchangerate + sign
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 10
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         var cur: [currency] = []
        let c  = currencies[indexPath.row]
        let cc = getsearchdata()
        cur.append(c)
        cur.append(cc)
        performSegue(withIdentifier: "exchangeSegue", sender: cur )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exchangeSegue" {
            let detailVC =  segue.destination as? exchangeViewController
            detailVC?.cur = sender as! [currency]
        }
        
        else  if segue.identifier == "datesegeu" {
            let detailVC =  segue.destination as? dateViewController
            detailVC?.name = sender as! String
        }
        
        
        
    }
    let dbm:SQLiteDB = SQLiteDB.shared
    override func viewDidLoad() {

        super.viewDidLoad()
        print("selectdate is------")
        print(selectdate)
        if(name == "")
        {
            name = "Albania"
        }
        if(selectdate == "")
        {
           
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            let result = formatter.string(from: date)
            selectdate = result
        }
        
        dateLabel.text = selectdate
        tableView.delegate = self
        tableView.dataSource = self
        
        getdata()
        
    }
    
    func getdata(){
        
        dbm.open()
       
        let c = getcurrency()
        
        let cmd = "SELECT * from tblcountry"
        let rows =  self.dbm.query(sql: cmd)
        for row in rows {
            let na = row["countryname"] as! String
            let cur = row["codealpha"] as! String
            let sign = row["currency"] as! String
            let code = row["countrycode"] as! String
            let aa = cur.lowercased()
            let ff = String.emojiFlag(for: code)!
            let maria = currency(countryflag: ff, countryname: na, currencysymbol: cur, currencyname: sign, exchangerate: "")
            
            let endpoint = "https://currencies.apps.grandtrunk.net/getrate/"+selectdate+"/"+aa+"/"+c.lowercased()
           var request = URLRequest(url: URL(string: endpoint)!)
            request.httpMethod = EndPoint.getpostEndPoint.method
           let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: request) { (data, response, error) in

               if error == nil && data != nil {

                   do{
                       if let dictionary1 = try  NSString(data:data!, encoding:String.Encoding.utf8.rawValue) as? String

                       {
                        let ee = Double(dictionary1) ?? 0.0
                        let ff = String(ee.dollarString) ?? ""
                        maria.exchangerate = ff

                       }


                   }
                   catch let error {
                       print(error.localizedDescription)
                   }
               }

       }

         task.resume()
            
          self.currencies.append(maria)
            
        }
        tableView.reloadData()
        
      
    }
    
    func getsearchdata() -> currency{
        var c = currency(countryflag: "", countryname: "", currencysymbol: "", currencyname: "", exchangerate: "")
        let cmd1 = "SELECT * from tblcountry"
        let crows =  self.dbm.query(sql: cmd1)
        for row in crows {
            let na1 = row["countryname"] as! String
            if(name == na1)
            {
                let code = row["countrycode"] as! String
                let ff = String.emojiFlag(for: code)!
                c.countryname = row["countryname"] as! String
                c.countryflag = ff
                c.currencyname = row["currency"] as! String
            }
        }
        return c
    }
    func getcountrycode() -> String{
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
    
    func getcurrency() -> String{
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
extension Locale {
    static let currency: [String: (code: String?, symbol: String?)] = Locale.isoRegionCodes.reduce(into: [:]) {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $1]))
        $0[$1] = (locale.currencyCode, locale.currencySymbol)
    }
}

extension String {
    static func emojiFlag(for countryCode: String) -> String! {
        func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
            return scalar.value >= 0x61 && scalar.value <= 0x7A
        }
        
        func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
            precondition(isLowercaseASCIIScalar(scalar))
            
            // 0x1F1E6 marks the start of the Regional Indicator Symbol range and corresponds to 'A'
            // 0x61 marks the start of the lowercase ASCII alphabet: 'a'
            return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
        }
        
        let lowercasedCode = countryCode.lowercased()
        guard lowercasedCode.characters.count == 2 else { return nil }
        guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }
        
        let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
        return String(indicatorSymbols.map({ Character($0) }))
    }
}


extension Double {
    var dollarString:String {
        return String(format: "%.3f", self)
    }
}

