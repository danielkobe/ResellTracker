//
//  DetailViewController.swift
//  FinalProject
//
//  Created by Daniel Koberstein on 4/17/18.
//  Copyright © 2018 Daniel Koberstein. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var styleCodeLabel: UILabel!
    @IBOutlet weak var colorwayLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var shoeImageView: UIImageView!
    @IBOutlet weak var resellModeSwitch: UISwitch!
    
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var shoe: Shoe = Shoe()
    var sizes:[Size] = []
    var doneScraping: Bool = false
    
    @IBOutlet weak var priceTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resellModeSwitch.isOn = false
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        
        navigationItem.prompt = "Resell Tracker"
        navigationItem.title = "Resell Prices For " + shoe.shoeName
        
        self.priceTable.dataSource = self
        self.priceTable.delegate = self
        scrapePrices()
        self.styleCodeLabel.text = shoe.styleCode
        self.colorwayLabel.text = shoe.colorway
        self.priceLabel.text = "$" + shoe.retailPrice + ".00"
        self.releaseDateLabel.text = shoe.releaseDate
        
        if let url = NSURL(string: shoe.imgURL) {
            if let data = NSData(contentsOf: url as URL) {
                shoeImageView.contentMode = .scaleAspectFit
                shoeImageView.image = UIImage(data: data as Data)
            }
                
            else{
                shoeImageView.image = UIImage(named: "default.png")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func scrapePrices(){
        
        let url = URL(string: "https://dtzwqfkqs0.execute-api.us-east-1.amazonaws.com/prod/scrapePrices?productId=" + shoe.styleCode)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request,
                                                  completionHandler: handleResponse)
        dataTask.resume()
    }
    
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
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!) {
                    let jsonDict = jsonObj as! [String: AnyObject]
                    
                    if let sizes = jsonDict["sizes"] as? [AnyObject]
                    {
                        self.sizes.removeAll()
                        for i in 0...sizes.count-1{
                            let s = Size()
                            
                            let size = sizes[i] as! Dictionary<String, AnyObject>
                            //get size
                            s.size = size["size"] as! Float
                            
                            //goat price
                            let goat = size["goat"] as! Dictionary<String, AnyObject>
                            if(goat.count>0){
                                DispatchQueue.main.async {
                                    if(self.resellModeSwitch.isOn){
                                        var Base = goat["lowestAsk"] as! Float
                                        Base = Base - (((0.095 * Base) as Float) + 5);
                                        let price = Double(0.971 * Base)
                                        s.goatPrice = String(format: "$%.02f", price)
                                    }
                                        
                                    else{
                                        let price = goat["lowestAsk"] as! Float
                                        s.goatPrice = String(format: "$%.02f", price)
                                    }
                                }
                            }
                            
                            
                            //stockX price
                            let stockX = size["stockX"] as! Dictionary<String, AnyObject>
                            if(stockX.count>0){
                                DispatchQueue.main.async {
                                    if(self.resellModeSwitch.isOn){
                                        var Base = stockX["lowestAsk"] as! Float
                                        Base = Base * 0.88
                                        s.stockXPrice = String(format: "$%.02f", Base)
                                        
                                    }
                                    else{
                                        let price = stockX["lowestAsk"] as! Float
                                        s.stockXPrice = String(format: "$%.02f", price)
                                    }
                                    
                                }
                                
                            }
                            
                            //stadium goods price
                            let stadiumGoods = size["stadiumGoods"] as! Dictionary<String, AnyObject>
                            if(stadiumGoods.count>0){
                                DispatchQueue.main.async {
                                    if(self.resellModeSwitch.isOn){
                                        var price = stadiumGoods["lowestAsk"] as! Float
                                        price = price * 0.8
                                        s.stadiumGoodsPrice = String(format: "$%.02f", price)
                                    }
                                    else{
                                        let price = stadiumGoods["lowestAsk"] as! Float
                                        s.stadiumGoodsPrice = String(format: "$%.02f", price)
                                    }
                                    
                                }
                                
                            }
                            
                            
                            //flight club price
                            let flightClub = size["flightClub"] as! Dictionary<String, AnyObject>
                            let flightClubSelling = flightClub["selling"] as! Dictionary<String, AnyObject>
                            
                            if(flightClubSelling.count>0){
                                DispatchQueue.main.async {
                                    if(self.resellModeSwitch.isOn){
                                        var price = flightClubSelling["lowestAsk"] as! Float
                                        price = price * 0.8
                                        s.flightClubPrice = String(format: "$%.02f", price)
                                    }
                                    else{
                                        let price = flightClubSelling["lowestAsk"] as! Float
                                        s.flightClubPrice = String(format: "$%.02f", price)
                                    }
                                }
                            }
                            
                            self.sizes.append(s)
                            
                        }
                        doneScraping = true
                        DispatchQueue.main.async {
                            self.priceTable.reloadData()
                        }
                    }
                    else{
                        print("error parsing sizes")
                    }
                    
                }
                else{
                    print("error parsing json")
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return sizes.count // your number of cell here
        return sizes.count+1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        if(doneScraping){
            if(indexPath.row==0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! HeaderCell
                return cell
            }
                
            else{
                print(indexPath.row)
                let size = self.sizes[indexPath.row-1]
                let cell = tableView.dequeueReusableCell(withIdentifier: "sizeCell", for: indexPath) as! SizeCell
                cell.sizeLabel.text = String(size.size)
                cell.goatPriceLabel.text = String(size.goatPrice)
                cell.stockXPriceLabel.text = String(size.stockXPrice)
                cell.flightClubPriceLabel.text = String(size.flightClubPrice)
                cell.stadiumGoodsPriceLabel.text = String(size.stadiumGoodsPrice)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row==0){
            return 65
        }
        else{
            return 42
        }
    }
    
    @IBAction func resellModeChanged(_ sender: Any) {
        scrapePrices()
    }
    
    //add trip to core data
    func addShoe(imgURL: String, shoeName: String, size: Float, avgPrice: Float ) -> Void {
        //add trip to core data
        let shoe = NSEntityDescription.insertNewObject(forEntityName:
            "ShoeEntity", into: self.managedObjectContext)
        shoe.setValue(shoeName, forKey: "name")
        shoe.setValue(imgURL, forKey: "imgURL")
        shoe.setValue(size, forKey: "size")
        shoe.setValue(avgPrice, forKey: "avgPrice")
        
        self.appDelegate.saveContext()
        
        //return shoe.objectID
    }
    
    
    @IBAction func addToPortfolioTapped(_ sender: Any) {
        if((priceTable.indexPathForSelectedRow) != nil){
            let shoe = sizes[(priceTable.indexPathForSelectedRow?.row)! - 1]
            var count: Float = 0.0
            var sum: Float = 0.0
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            
            if(shoe.goatPrice != "$0.00"){
                if let number = formatter.number(from: shoe.goatPrice) {
                    let amount = number.floatValue
                    sum = sum + amount
                    count = count + 1
                    print(amount)
                }
            }
            if(shoe.stockXPrice != "$0.00"){
                if let number = formatter.number(from: shoe.stockXPrice) {
                    let amount = number.floatValue
                    sum = sum + amount
                    count = count + 1
                    print(amount)
                }            }
            if(shoe.stadiumGoodsPrice != "$0.00"){
                if let number = formatter.number(from: shoe.stadiumGoodsPrice) {
                    let amount = number.floatValue
                    sum = sum + amount
                    count = count + 1
                    print(amount)
                }
            }
            if(shoe.flightClubPrice != "$0.00"){
                if let number = formatter.number(from: shoe.flightClubPrice) {
                    let amount = number.floatValue
                    sum = sum + amount
                    count = count + 1
                    print(amount)
                }
            }
            var avgPrice: Float = 0.0
            if(count == 0.0){
                avgPrice = 0.0
            }
            else{
                avgPrice = sum/count
            }
            addShoe(imgURL: self.shoe.imgURL, shoeName: self.shoe.shoeName, size: shoe.size, avgPrice: avgPrice)
            
            let alert = UIAlertController(title: self.shoe.shoeName + " Size \(shoe.size)" + "\n" + "sucessfully added to portfolio!" ,
                                          message: "Congrats!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default,
                                         handler: { (action) in
                                            print("Ok pressed")
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }
        
        else{
            let alert = UIAlertController(title: "Error in adding to portfolio",
                                          message: "Choose size before adding.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default,
                                         handler: { (action) in
                                            print("Ok pressed")
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }
    }
}
