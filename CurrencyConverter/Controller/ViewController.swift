//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Berkay on 4.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // 1) Request & Session
    // 2) Response & Data
    // 3) Parsing & JSON Serialization

    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currency()
    }

    @IBAction func btnRefresh(_ sender: Any) {
        currency()
    }
    
    func currency(){
        // 1.
        let url = URL(string: "https://api.apilayer.com/fixer/latest?base=USD&apikey=WfR2Xev5pQuPg91JTwI8O9wrVPUcxbSs")
        let session = URLSession.shared
        
        // Closure
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }else{
                // 2.
                if data != nil{
                    do{
                        let jsonResonse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        // ASYNC
                        DispatchQueue.main.async {
                            if let rates = jsonResonse["rates"] as? [String: Any]{
                                
                                if let tr = rates["TRY"] as? Double{
                                    self.tryLabel.text = "TRY: \(tr)"
                                }
                                
                                if let usd = rates["USD"] as? Double{
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                
                                if let cad = rates["CAD"] as? Double{
                                    self.cadLabel.text = "CAD: \(cad)"
                                }
                                
                                if let jp = rates["JPY"] as? Double{
                                    self.jpyLabel.text = "JPY: \(jp)"
                                }
                                
                            }
                        }
                        
                    }catch{
                        let alert = UIAlertController(title: "HATA", message: "Beklenmedik bir hata oluştu", preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default)
                        alert.addAction(okButton)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        task.resume()
        
    }
    
}

