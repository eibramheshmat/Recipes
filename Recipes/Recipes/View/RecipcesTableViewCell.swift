//
//  RecipcesTableViewCell.swift
//  Recipes
//
//  Created by Ibram on 7/6/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit

class RecipcesTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeSource: UILabel!
    @IBOutlet weak var recipeHealthLbl: UILabel!
    
    var dataObject : RecipesDataInto?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDesign(){
        self.mainView.layer.cornerRadius = 10
        self.mainView.clipsToBounds = true
        self.recipeImage.layer.cornerRadius = 10
        self.recipeImage.clipsToBounds = true
    }
    
    func setupData(){
        self.recipeTitle.text = dataObject?.label
        self.recipeSource.text = dataObject?.source
        fillHealthLBL()
    }
    
    func fillHealthLBL(){
        var healthLbls : [String] = []
        var healthLblsShow = ""
        if dataObject?.healthLabels?.count ?? 0 > 0{
            let counterLoop = (dataObject?.healthLabels?.count ?? 0) - 1
                for n in 0 ... counterLoop{
                    healthLbls.append(dataObject?.healthLabels?[n] ?? "")
            }
        }
        if healthLbls.count > 0{
            for n in 0 ... (healthLbls.count - 1){
                if healthLblsShow == "" {
                    healthLblsShow = healthLbls[n]
                }else{
                    healthLblsShow = healthLblsShow + " , " + healthLbls[n]
                }
            }
        }
        self.recipeHealthLbl.text = healthLblsShow
    }
}
