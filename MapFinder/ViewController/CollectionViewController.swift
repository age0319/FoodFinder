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
        cell.imageview.image = UIImage(named: String(index))
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(categoryList[indexPath.row])
    }
}
