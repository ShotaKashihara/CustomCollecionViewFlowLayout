//
//  CollectionViewFlowLayout.swift
//  CollectionViewSample
//
//  Created by Shota Kashihara on 2017/04/06.
//  Copyright © 2017年 Shota Kashihara. All rights reserved.
//

import UIKit

open class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var maxColumn = 1
    var headerCellHeight: CGFloat = 0.0
    var cellPattern:[(sideLength: CGFloat, heightLength:CGFloat, column:CGFloat, row:CGFloat)] = []
    
    private var sectionCells = [[CGRect]]()
    private var contentSize = CGSize.zero
    
    ///
    open func setLayout(maxColumn: Int, headerCellHeight: CGFloat, cellPattern: [(sideLength: CGFloat, heightLength:CGFloat, column:CGFloat, row:CGFloat)]) {
        
        self.maxColumn = maxColumn
        self.headerCellHeight = headerCellHeight
        self.cellPattern = cellPattern
    }
    
    /// (1) prepare
    /// UICollectionView 上に配置する要素の位置と大きさを計算する
    /// コンテンツ領域の大きさを計算する
    override open func prepare() {
        super.prepare()
        
        sectionCells = [[CGRect]]()
        
        if let collectionView = self.collectionView {
            contentSize = CGSize(width: collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right, height: 0)
            let smallCellSideLength: CGFloat = (contentSize.width - super.sectionInset.left - super.sectionInset.right - (super.minimumInteritemSpacing * (CGFloat(maxColumn) - 1.0))) / CGFloat(maxColumn)
            
            for section in (0..<collectionView.numberOfSections) {
                
                var cells = [CGRect]()
                let numberOfCellsInSection = collectionView.numberOfItems(inSection: section);
                var height = contentSize.height
                
                if section == 0 {
                    height = CGFloat(self.headerCellHeight)
                    contentSize = CGSize(width: contentSize.width, height: height)
                    continue
                }
                
                for i in (0..<numberOfCellsInSection) {
                    let position = i  % (numberOfCellsInSection)
                    let cellPosition = position % cellPattern.count
                    let cell = cellPattern[cellPosition]
                    let x = (cell.column * (smallCellSideLength + super.minimumInteritemSpacing)) + super.sectionInset.left
                    let y = (cell.row * (smallCellSideLength + super.minimumLineSpacing)) + contentSize.height + super.sectionInset.top
                    let cellwidth = (cell.sideLength * smallCellSideLength) + ((cell.sideLength-1) * super.minimumInteritemSpacing)
                    let cellheight = (cell.heightLength * smallCellSideLength) + ((cell.heightLength-1) * super.minimumLineSpacing)
                    let cellRect = CGRect.init(x: x, y: y, width: cellwidth, height: cellheight)
                    cells.append(cellRect)
                    
                    if (height < cellRect.origin.y + cellRect.height) {
                        height = cellRect.origin.y + cellRect.height
                    }
                }
                // 最大サイズを更新
                contentSize = CGSize(width: contentSize.width, height: height)
                // セルリストに追加
                sectionCells.append(cells)
            }
        }
    }
    
    /// 
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        if let collectionView = self.collectionView {
            for i in (0..<collectionView.numberOfSections) {
                for j in (0..<collectionView.numberOfItems(inSection: i)) {
                    if let attributes = self.layoutAttributesForItem(at: IndexPath.init(row: j, section: i)) {
                        if (rect.intersects(attributes.frame)) {
                            layoutAttributes.append(attributes)
                        }
                    }
                }
            }
        }
        
        return layoutAttributes
    }
    
    ///
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        if indexPath.section == 0 {
            attributes?.frame = CGRect.init(
                x: Int(0 + super.sectionInset.left),
                y: Int(0 + super.sectionInset.top),
                width: Int(self.collectionViewContentSize.width - super.sectionInset.left - super.sectionInset.right),
                height: Int(self.headerCellHeight - super.sectionInset.top))
        } else {
            attributes?.frame = sectionCells[indexPath.section - 1][indexPath.row]
        }
        return attributes
    }
    
    /// ※スクロールするのに必須
    override open var collectionViewContentSize: CGSize {
        return contentSize
    }
}
