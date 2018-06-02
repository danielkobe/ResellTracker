//
//  TableViewController.swift
//  FinalProject
//
//  Created by Daniel Koberstein on 4/13/18.
//  Copyright © 2018 Daniel Koberstein. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var shoes: [Shoe] = []
    var shoeIndex: Int!
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
        
        let jsonStr = "{\"params\":\"query=" + searchBar.text! + "&facets=*&page=0&hitsPerPage=50\"}";
        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //use later for active search
        
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
                // response okay, do something with data
                
                //let dataStr = String(data: data!, encoding: .utf8)
                
                // response okay, do something with data
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!) {
                    let jsonDict = jsonObj as! [String: AnyObject]
                    
                    if let hits = jsonDict["hits"] as? [AnyObject]
                    {
                        shoes.removeAll()
                        
                        for i in 0...20{
                            if i < hits.count && ((hits[i] as? Dictionary<String, AnyObject>) != nil) {
                                let shoeDict = hits[i] as! Dictionary<String, AnyObject>
                                if(shoeDict["product_category"] as! String == "sneakers"){
                                    let shoe = Shoe()
                                    if let shoeName = shoeDict["name"] as? String {
                                        shoe.shoeName = shoeName
                                    }
                                    //shoe.shoeName = shoeDict["name"] as! String
                                    if let colorway = shoeDict["colorway"] as? String {
                                        shoe.colorway = colorway
                                    }
                                    //shoe.colorway = shoeDict["colorway"] as! String
                                    if let brand = shoeDict["brand"] as? String {
                                        shoe.brand = brand
                                    }
                                    //shoe.brand = shoeDict["brand"] as! String
                                    if let imgURL = shoeDict["thumbnail_url"] as? String {
                                        shoe.imgURL = imgURL
                                    }
                                    //shoe.imgURL = shoeDict["thumbnail_url"] as! String
                                    if let releaseDate = shoeDict["release_date"] as? String {
                                        shoe.releaseDate = releaseDate
                                    }
                                    //shoe.releaseDate = shoeDict["release_date"] as! String
                                    
                                    if let tempDict = shoeDict["searchable_traits"] as? Dictionary<String, AnyObject>{
                                        if let retail = tempDict["Retail Price"] as? Int{
                                            shoe.retailPrice = String(retail)
                                        }
                                    }
                                    
                                    if (shoeDict["style_id"] as? String) != nil
                                    {
                                        shoe.styleCode = shoeDict["style_id"] as! String
                                    }
                                    else{
                                        shoe.styleCode = ""
                                    }
                                    
                                    shoes.append(shoe)
                                }
                                else{
                                    print("Couldn't parse hit")
                                }
                            }
                        }
                        
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoeCell", for: indexPath) as! ShoeCell
        let shoe = shoes[indexPath.row]
        
        cell.nameLabel.text=shoe.shoeName
        cell.brandLabel.text=shoe.brand
        cell.colorLabel.text=shoe.colorway
        
        let url = shoe.imgURL
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                cell.shoeImage.contentMode = .scaleAspectFit
                cell.shoeImage.image = UIImage(data: data as Data)
            }
                
            else{
                cell.shoeImage.image = UIImage(named: "default.png")
            }
        }
        else {
            print("default image")
            //default image
            cell.shoeImage.image = UIImage(named: "default.png")
        }
        
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "toDetail") {
            let detailVC = segue.destination as! DetailViewController
            detailVC.shoe = shoes[shoeIndex]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shoeIndex = indexPath.row
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
