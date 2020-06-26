//
//  CollectionViewController.swift
//  MapFinder
//
//  Created by haru on 2020/06/26.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController {
    
    var categoryList = Utility().categoryList
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell

        let index = indexPath.row
        cell.janre.text = categoryList[index].name
        if index == 0{
            cell.imageview.image = UIImage(named: "izakaya")
        }else if(index == 1){
            cell.imageview.image = UIImage(named: "japanese")
        }else if(index == 2){
            cell.imageview.image = UIImage(named: "sushi")
        }else if(index == 3){
            cell.imageview.image = UIImage(named: "nabe")
        }else if(index == 4){
            cell.imageview.image = UIImage(named: "yakiniku")
        }else if(index == 5){
            cell.imageview.image = UIImage(named: "yakitori")
        }else if(index == 6){
            cell.imageview.image = UIImage(named: "wasyoku")
        }else if(index == 7){
            cell.imageview.image = UIImage(named: "okonomiyaki")
        }else if(index == 8){
            cell.imageview.image = UIImage(named: "ra-men")
        }else if(index == 9){
            cell.imageview.image = UIImage(named: "chinese")
        }else if(index == 10){
            cell.imageview.image = UIImage(named: "itarian")
        }else if(index == 11){
            cell.imageview.image = UIImage(named: "western")
        }else if(index == 12){
            cell.imageview.image = UIImage(named: "oubei")
        }else if(index == 13){
            cell.imageview.image = UIImage(named: "curry")
        }else if(index == 14){
            cell.imageview.image = UIImage(named: "asian")
        }else if(index == 15){
            cell.imageview.image = UIImage(named: "organic")
        }else if(index == 16){
            cell.imageview.image = UIImage(named: "bar")
        }else if(index == 17){
            cell.imageview.image = UIImage(named: "beer")
        }else if(index == 18){
            cell.imageview.image = UIImage(named: "sweets")
        }else if(index == 19){
            cell.imageview.image = UIImage(named: "entertainment")
        }else if(index == 20){
            cell.imageview.image = UIImage(named: "family")
        }else if(index == 21){
            cell.imageview.image = UIImage(named: "other")
        }
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(categoryList[indexPath.row])
    }
}
