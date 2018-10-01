//
//  ViewController.swift
//  test
//
//  Created by mac on 10/1/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet var movieImgsCollectionView: UICollectionView!

    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        movieImgsCollectionView.register(UINib.init(nibName: "CollectionImgCell", bundle: nil), forCellWithReuseIdentifier: "CollectionImgCell")

//         movieImgsCollectionView.register(CollectionImgCell.self, forCellWithReuseIdentifier: "CollectionImgCell")
        movieImgsCollectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30)

        // Do any additional setup after loading the view, typically from a nib.
        if let flowLayout = movieImgsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionImgCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionImgCell", for: indexPath) as! CollectionImgCell



            cell.backgroundView?.backgroundColor = UIColor.red


        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  


}

