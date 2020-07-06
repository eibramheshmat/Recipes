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
    let viewModelObject = TaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        viewModelObject.getData(RecipeSearchWord: "rice", from: 0, to: 10)
        
    }

    func registerNibs(){
        self.recipcesTableView.register(UINib(nibName: "RecipcesTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipcesTableViewCell")
    }

}

