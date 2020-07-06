//
//  ViewController.swift
//  Recipes
//
//  Created by Ibram on 7/6/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //outlets
    @IBOutlet weak var recipcesTableView: UITableView!
    @IBOutlet weak var recipcesSearchBar: UISearchBar!
    @IBOutlet weak var historyMainView: UIView!
    @IBOutlet weak var histroyCollectionView: UICollectionView!
    @IBOutlet weak var LogoMainView: UIView!
    @IBOutlet weak var logoMainLBL: UILabel!
    
    //variables
    var from : Int = 0
    var to : Int = 10
    var tableCounter : Int = 0
    var totalRecipeCounter : Int = 0
    var selectedCell: Int!
    let viewModelObject = TaskViewModel()
    var recipeModelObject : RecipeModel?
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchHistory:[SearchHistory] = []
    var searchHistory10:[SearchHistory] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyFetch()//get history from coredata
        registerNibs()//rigest nibs for table and collection
        setupDesign()
        
    }

    func setupDesign(){
        self.title = "Recipes"
        self.historyMainView.isHidden = true
        self.recipcesSearchBar.backgroundImage = UIImage()
        let verison = UIDevice.current.systemVersion
        if verison == "13.0" || verison == "13.1" || verison == "13.2"{
            recipcesSearchBar.searchTextField.backgroundColor = .white
        }
        self.historyMainView.layer.cornerRadius = 10
        self.historyMainView.clipsToBounds = true
        self.hideKeyboardWhenTappedAround()
    }
    
    func registerNibs(){
        self.recipcesTableView.register(UINib(nibName: "RecipcesTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipcesTableViewCell")
        self.histroyCollectionView.register(UINib(nibName: "HistoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HistoryCollectionViewCell")
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
                DispatchQueue.main.async {
                    self.LogoMainView.isHidden = true
                }
            }else{
                self.tableCounter = 0
                DispatchQueue.main.async {
                    self.LogoMainView.isHidden = false
                    self.logoMainLBL.text = " No recipe matches your search word ! Or try later"
                }
            }
            DispatchQueue.main.async {
                Loading.shared.hide()
                self.recipcesTableView.reloadData()
            }
        }
    }

    // for get search histroy
    func historyFetch() {
        searchHistory.removeAll()
        searchHistory10.removeAll()
        do {
            searchHistory = try context.fetch(SearchHistory.fetchRequest())
            searchHistory = searchHistory.reversed()
            print(searchHistory)
            if searchHistory.count < 10
            {
                for n in 0..<searchHistory.count{
                    searchHistory10.append(searchHistory[n])
                }
            }else{
                for n in 0..<10{
                    searchHistory10.append(searchHistory[n])
                }
            }
        }catch{
            print(error)
        }
    }
}


//MARK:- SearchBar

extension ViewController: UISearchBarDelegate, UITextFieldDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.historyMainView.isHidden = false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.historyMainView.isHidden = true
    }
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        self.tableCounter = 0
        self.historyMainView.isHidden = true
        let newHistory = NSEntityDescription.insertNewObject(forEntityName: "SearchHistory", into: context)
        newHistory.setValue("\(searchBar.text ?? "")", forKey: "history")
        do {
            try context.save()
        }catch{
            print(error)
        }
        DispatchQueue.main.async {
            self.historyFetch()
            self.histroyCollectionView.reloadData()
        }
        dismissKeyboard()
        self.featchData(RecipeSearchWord: "\(recipcesSearchBar.text ?? "")")
    }
}


//MARK:- Recipes TableView

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetails":
            if let viewController = segue.destination as? DetailsViewController{
                viewController.recipeSelectObject = recipeModelObject?.hits?[self.selectedCell].recipe
                }
        default:
            break
        }
    }
    
}

//MARK:-  History CollectionView

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchHistory10.count > 0{
            return searchHistory10.count
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        historyFetch()
        let cell = self.histroyCollectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as! HistoryCollectionViewCell
        if searchHistory10.count > 0{
            cell.cellLBL.text = searchHistory10[indexPath.row].history ?? ""
        }else{
            cell.cellLBL.text = "Search history"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.histroyCollectionView.frame.width / 2.1, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tableCounter = 0
        recipcesSearchBar.text = searchHistory[indexPath.row].history ?? ""
        self.featchData(RecipeSearchWord: searchHistory[indexPath.row].history ?? "")
    }
   
    
}



