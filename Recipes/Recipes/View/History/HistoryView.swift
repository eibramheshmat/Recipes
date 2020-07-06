//
//  HistoryView.swift
//  Recipes
//
//  Created by Ibram on 7/6/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit

class HistoryView: UIView {

    @IBOutlet weak var histroyCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNibs()
        
    }
    
    func registerNibs(){
        self.histroyCollectionView.delegate = self
        self.histroyCollectionView.dataSource = self
        self.histroyCollectionView.register(UINib(nibName: "HistoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HistoryCollectionViewCell")
    }

}

//MARK:- collectionView

extension HistoryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = histroyCollectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as! HistoryCollectionViewCell
        return cell
    }
    
    
}
