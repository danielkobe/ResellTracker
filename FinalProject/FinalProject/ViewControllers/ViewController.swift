//
//  ViewController.swift
//  FinalProject
//
//  Created by Daniel Koberstein on 4/12/18.
//  Copyright © 2018 Daniel Koberstein. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textField: UITextField!
    var responseString:String?
    
    func handleResponse (data: Data?, response: URLResponse?, error: Error?) {
        if let err = error {
            print("error: \(err.localizedDescription)")
        } else {
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode != 200 {
                let msg = HTTPURLResponse.localizedString(forStatusCode:
                    statusCode)
                print("HTTP \(statusCode) error: \(msg)")
            } else {
                // response okay, do something with data
                
                //let dataStr = String(data: data!, encoding: .utf8)
                
                // response okay, do something with data
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!) {
                    let jsonDict = jsonObj as! [String: AnyObject]
                    //let first = jsonDict["hits"] as! String!
                    if let hits = jsonDict["hits"] as? [AnyObject]
                    {
                        for hit in hits{
                            let shoe = hit as! Dictionary<String, AnyObject>
                            print(shoe["name"]!)
                        }
                        //print(first["thumbnail_url"])
                        
                    }
                    else{
                        print("error in hits")
                    }

                }
                else {
                    print("error: invalid JSON data")
                }
                
            }
        }
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        let jsonStr = "{\"params\":\"query=" + textField.text! + "&facets=*&page=0&hitsPerPage=50\"}";
        
        let jsonData = jsonStr.data(using: .utf8)
        let url = URL(string: "https://xw7sbct9v6-dsn.algolia.net/1/indexes/products/query")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = jsonData!
 
        request.setValue("Algolia for vanilla JavaScript 3.22.1", forHTTPHeaderField: "x-algolia-agent")
        request.setValue("XW7SBCT9V6", forHTTPHeaderField: "x-algolia-application-id")
        request.setValue("6bfb5abee4dcd8cea8f0ca1ca085c2b3", forHTTPHeaderField: "x-algolia-api-key")

        let dataTask = URLSession.shared.dataTask(with: request,
                                                  completionHandler: handleResponse)
        dataTask.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.green


        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

