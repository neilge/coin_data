//
//  ViewController.swift
//  Coin
//
//  Created by Xiangyu Ge on 11/18/17.
//  Copyright © 2017 Neilge. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift

class ViewController: UIViewController {
    
    //MARK: Properties
    let nonce: Int = Int(Date().timeIntervalSince1970)
    
    @IBOutlet weak var totalValueTextField: UILabel!
    
    //MARK: Actions
    @IBAction func refresh(_ sender: UIButton) {
        
        let geminiApiKey = "jX1fo588E90j9BeYAB2X"
        let secret = "2XS6Ybi38spKw1vriUzarTHW9k1u"
        let payload = """
{
            "request": "/v1/balances",
            "nonce": \(nonce)
}
"""
        print(geminiApiKey)
        let b64 = payload.data(using: .utf8)!.base64EncodedString()
        let signature = try! HMAC(key: secret, variant: .sha384).authenticate(Array(b64.utf8)).toHexString()
        let headers: HTTPHeaders = [
            "Content-Type" : "text/plain",
            "Content-Length": "0",
            "X-GEMINI-APIKEY": geminiApiKey,
            "X-GEMINI-PAYLOAD": b64,
            "X-GEMINI-SIGNATURE": signature,
            "Cache-Control": "no-cache"
        ]

        Alamofire.request("https://api.sandbox.gemini.com/v1/balances", method: .post, headers: headers).responseJSON{ response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result

            if let jsonArray = response.result.value as? [Any] {
                for json in jsonArray {
                    print(json)
                    let dic = json as! [String: Any]
                    let amount = Double(dic["amount"] as! String)!
                    let avaiable = Double(dic["available"] as! String)!
                    let avaiableForWithDrawal = Double(dic["availableForWithdrawal"] as! String)!
                    let currency = dic["currency"] as! String
                    let type = dic["type"] as! String
                    print(amount)
                    print(avaiable)
                    print(avaiableForWithDrawal)
                    print(currency)
                    print(type)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
