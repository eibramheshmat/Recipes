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
    
}
