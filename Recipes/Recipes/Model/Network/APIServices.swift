//
//  APIServices.swift
//  Recipes
//
//  Created by Ibram on 7/6/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class APIServices{
    
    static let shared = APIServices()
    
    func getRecipe(RecipeSearchWord: String,from: Int,to: Int, comletion: @escaping(RecipeModel)->()){
        let nilObject = RecipeModel()
        let RecipeSearchWordWithOutSpaces = RecipeSearchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" // search word without spaces
        Network.shared.makeHttpRequest(model: RecipeModel(), method: .get, APIName: "", parameters: ["q": RecipeSearchWordWithOutSpaces, "app_id": Constants.app_id, "app_key": Constants.app_key, "from": "\(from)", "to": "\(to)"]) { (result) in
            switch result{
            case .success(let response):
                comletion(response)
            case .failure(let error):
                print(error)
                comletion(nilObject)
            }
        }
    }
}
