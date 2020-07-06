//
//  DetailsViewController.swift
//  Recipes
//
//  Created by Ibram on 7/6/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

class DetailsViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeSource: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    
    var recipeSelectObject: RecipesDataInto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        // Do any additional setup after loading the view.
    }
    

    // Edit view design
    override func viewWillAppear(_ animated: Bool) {
        // hide navigationBar when enter view
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    override func viewWillDisappear(_ animated: Bool) {
        // show navigationBar when exit view
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    @available(iOS 11.0, *)
    func registerTab(){
        let goToSafariTap = UITapGestureRecognizer(target: self, action: #selector(goToSafari))
        self.recipeSource.addGestureRecognizer(goToSafariTap)
    }
    
    func setData(){
        self.recipeImage.kf.setImage(with: URL(string: recipeSelectObject?.image ?? ""))
        self.recipeName.text = recipeSelectObject?.label
        self.recipeSource.text = recipeSelectObject?.url
        fillIngredients()
    }
    
    func fillIngredients(){
        var ingredientsShow = ""
        if recipeSelectObject?.ingredientLines?.count ?? 0 > 0{
            let loopCounter = (recipeSelectObject?.ingredientLines?.count ?? 0) - 1
            if loopCounter > 0 {
                for n in 0 ... loopCounter {
                    if ingredientsShow == "" {
                        ingredientsShow = " " + (recipeSelectObject?.ingredientLines?[n] ?? "")
                    }else{
                        ingredientsShow = ingredientsShow + " \n " + (recipeSelectObject?.ingredientLines?[n] ?? "")
                    }
                }// loop to fill all ingredients in on string
            }// if there no ingredients
        }
        recipeIngredients.text = ingredientsShow
    }
    
    @available(iOS 11.0, *)
    @IBAction func goToSafariActionBtn(_ sender: UIButton) {
        goToSafari()
    }
    @available(iOS 11.0, *)
    @objc func goToSafari(){
        if let url = URL(string:"\(recipeSelectObject?.url ?? "")") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }

}
