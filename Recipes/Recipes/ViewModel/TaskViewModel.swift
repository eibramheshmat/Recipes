//
//  TaskViewModel.swift
//  Recipes
//
//  Created by Ibram on 7/6/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class TaskViewModel{
    
    func getData(RecipeSearchWord: String, from: Int, to: Int){
        APIServices.shared.getRecipe(RecipeSearchWord: RecipeSearchWord, from: from, to: to) { (result) in
            print(result)
        }
    }
}
