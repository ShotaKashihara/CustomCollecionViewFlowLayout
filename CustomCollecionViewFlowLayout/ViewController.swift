//
//  ViewController.swift
//  CustomCollecionViewFlowLayout
//
//  Created by amitan on 2015/06/20.
//  Copyright (c) 2015年 amitan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate let cellIdentifier = "cell"
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? CustomCollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            
            var cellPattern:[(sideLength: CGFloat, heightLength:CGFloat, column:CGFloat, row:CGFloat)] = []
            cellPattern.append((sideLength: 2, heightLength: 2, column: 0, row: 0))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 2, row: 0))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 4, row: 0))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 0, row: 2))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 2, row: 2))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 4, row: 2))
            cellPattern.append((sideLength: 3, heightLength: 3, column: 0, row: 4))
            cellPattern.append((sideLength: 3, heightLength: 3, column: 3, row: 4))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 0, row: 7))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 2, row: 7))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 4, row: 7))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 0, row: 9))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 2, row: 9))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 4, row: 9))
            cellPattern.append((sideLength: 4, heightLength: 4, column: 0, row: 11))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 4, row: 11))
            cellPattern.append((sideLength: 2, heightLength: 2, column: 4, row: 13))
            
            layout.setLayout(
                maxColumn: 6,
                headerCellHeight: 200,
                cellPattern: cellPattern)
        }
        
        collectionView?.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: cellIdentifier)
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UICollectionViewDelegate {
    
    
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        // 第1セクションはヘッダー(UIColor.red)
        // 第2セクション以降がメインコンテンツ(UIColor.blue)
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let mainLabel = UILabel(frame: cell.frame)
        
        mainLabel.text = "\(indexPath.section)-\(indexPath.item)"
        mainLabel.textAlignment = .center
        mainLabel.backgroundColor = UIColor.blue
        cell.backgroundView = mainLabel
        cell.clipsToBounds = true
        cell.addSubview(mainLabel)
        
        if indexPath.section == 0 {
            mainLabel.backgroundColor = UIColor.red
        }
        
        return cell
    }
}
