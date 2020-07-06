//
//  ViewController.swift
//  Recipes
//
//  Created by Ibram on 7/6/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recipcesTableView: UITableView!
    @IBOutlet weak var recipcesSearchBar: UISearchBar!
    
    var from : Int = 0
    var to : Int = 10
    var tableCounter : Int = 0
    var totalRecipeCounter : Int = 0
    let viewModelObject = TaskViewModel()
    var recipeModelObject : RecipeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        setupDesign()
//        featchData(RecipeSearchWord: "rice")
        
    }

    func setupDesign(){
        self.recipcesSearchBar.backgroundImage = UIImage()
    }
    
    func registerNibs(){
        self.recipcesTableView.register(UINib(nibName: "RecipcesTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipcesTableViewCell")
    }
    
    func featchData(RecipeSearchWord: String){
        Loading.shared.show()
        viewModelObject.getData(RecipeSearchWord: RecipeSearchWord, from: from, to: to) { (result) in
            self.recipeModelObject = result
            if result.hits?.count ?? 0 > 0{
                self.from = result.from ?? 0
                self.to = result.to ?? 10
                self.totalRecipeCounter = result.count ?? 0
                self.tableCounter = result.hits?.count ?? 0
            }else{
                self.tableCounter = 0
            }
            DispatchQueue.main.async {
                Loading.shared.hide()
                self.recipcesTableView.reloadData()
            }
        }
    }

}


//MARK:- SearchBar

extension ViewController: UISearchBarDelegate, UITextFieldDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        tableCounter = 0
//        let newHistory = NSEntityDescription.insertNewObject(forEntityName: "SearchHistory", into: context)
//        newHistory.setValue("\(searchBar.text ?? "")", forKey: "history")
//        do {
//            try context.save()
//        }catch{
//            print(error)
//        }
//        DispatchQueue.main.async {
//            self.historyFetch()
//            self.CV.reloadData()
//        }
        dismissKeyboard()
        self.featchData(RecipeSearchWord: "\(recipcesSearchBar.text ?? "")")
    }
}


//MARK:- TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableCounter > 0 {
            return tableCounter
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.recipcesTableView.dequeueReusableCell(withIdentifier: "RecipcesTableViewCell", for: indexPath) as! RecipcesTableViewCell
        cell.dataObject = recipeModelObject?.hits?[indexPath.row].recipe
        cell.setupData()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // to know when reach the end of table to make Pagination
        if indexPath.row + 1 == tableCounter {
            if tableCounter < totalRecipeCounter{
                //call more items
                to += 30
                self.featchData(RecipeSearchWord: "\(recipcesSearchBar.text ?? "")")
            }
        }
    }
    
    
}



