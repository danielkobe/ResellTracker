//
//  PortfolioViewController.swift
//  FinalProject
//
//  Created by Daniel Koberstein on 4/29/18.
//  Copyright © 2018 Daniel Koberstein. All rights reserved.
//

import UIKit
import CoreData


class PortfolioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var portfolioShoes: [Shoe] = []
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    @IBOutlet weak var portfolioTableView: UITableView!
    @IBOutlet weak var totalShoesLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var avgPriceLabel: UILabel!
    var totalShoes: Int = 0
    var totalValue: Float = 0.0
    var avgPrice: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.prompt = "Resell Tracker"
        navigationItem.title = "Portfolio"
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        getShoes()
        setStats()
        self.portfolioTableView.dataSource = self
        self.portfolioTableView.delegate = self
        portfolioTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func setStats(){
        totalShoes = 0
        totalValue = 0.0
        avgPrice = 0.0
        
        for shoe in portfolioShoes {
            totalShoes = totalShoes+1
            totalValue = totalValue + shoe.avgPrice
        }

        if(totalShoes != 0){
            avgPrice = totalValue/Float(totalShoes)
        }
        
        totalShoesLabel.text = String(totalShoes)
        totalValueLabel.text = String(format: "$%.02f", totalValue)
        avgPriceLabel.text = String(format: "$%.02f", avgPrice)

    }
    
    //retrieve shoes from core data
    func getShoes() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ShoeEntity")
        var _shoes: [NSManagedObject]!
        do {
            _shoes = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getShoes error: \(error)")
        }
        print("Found \(_shoes.count) shoes")
        
        for shoe in _shoes {
            let newShoe = Shoe()
            newShoe.imgURL = shoe.value(forKey: "imgURL") as! String
            newShoe.shoeName = (shoe.value(forKey: "name") as! String)
            newShoe.size = shoe.value(forKey: "size") as! Float
            newShoe.avgPrice = shoe.value(forKey: "avgPrice") as! Float
            newShoe.objectID = shoe.objectID
            portfolioShoes.append(newShoe)
        }
        
        
    }
    

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteShoe(id: portfolioShoes[indexPath.row].objectID!)
            portfolioShoes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            setStats()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portfolioShoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCell
        let shoe = portfolioShoes[indexPath.row]
        
        cell.shoeNameLabel.text=shoe.shoeName
        cell.sizeLabel.text=String(shoe.size)
        cell.priceLabel.text=String(format: "$%.02f", shoe.avgPrice)
        
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
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    
    //delete trip from core data
    func deleteShoe(id: NSManagedObjectID){
        let obj = self.managedObjectContext.object(with: id)
        self.managedObjectContext.delete(obj)
        self.appDelegate.saveContext() // In AppDelegate.swift
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
