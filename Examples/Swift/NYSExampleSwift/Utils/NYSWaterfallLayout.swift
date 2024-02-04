//
//  NYSWaterfallLayout.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

protocol NYSWaterfallLayoutDelegate: AnyObject {
    func waterfallLayout(_ waterfallLayout: NYSWaterfallLayout, itemHeightForWidth itemWidth: CGFloat, at indexPath: IndexPath) -> CGFloat
}

class NYSWaterfallLayout: UICollectionViewLayout {
    weak var delegate: NYSWaterfallLayoutDelegate?

    var columnCount: Int = 2
    var columnSpacing: CGFloat = 0
    var rowSpacing: CGFloat = 0
    var sectionInset: UIEdgeInsets = UIEdgeInsets.zero

    private var maxYDic: [Int: CGFloat] = [:]
    private var attributesArray: [UICollectionViewLayoutAttributes] = []

    override func prepare() {
        super.prepare()

        maxYDic.removeAll()

        for i in 0..<columnCount {
            maxYDic[i] = sectionInset.top
        }

        attributesArray.removeAll()

        guard let collectionView = collectionView else {
            return
        }

        let itemCount = collectionView.numberOfItems(inSection: 0)

        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            if let attributes = layoutAttributesForItem(at: indexPath) {
                attributesArray.append(attributes)
            }
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return nil
        }

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        let collectionViewWidth = collectionView.frame.width
        let itemWidth = (collectionViewWidth - sectionInset.left - sectionInset.right - CGFloat(columnCount - 1) * columnSpacing) / CGFloat(columnCount)

        var itemHeight: CGFloat = 0

        if let delegate = delegate {
            itemHeight = delegate.waterfallLayout(self, itemHeightForWidth: itemWidth, at: indexPath)
        }

        var minIndex = 0

        for (index, maxY) in maxYDic {
            if maxY < maxYDic[minIndex] ?? 0 {
                minIndex = index
            }
        }

        let itemX = sectionInset.left + CGFloat(minIndex) * (itemWidth + columnSpacing)
        let itemY = maxYDic[minIndex] ?? 0 + rowSpacing

        attributes.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)

        maxYDic[minIndex] = attributes.frame.maxY

        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray.filter { $0.frame.intersects(rect) }
    }

    override var collectionViewContentSize: CGSize {
        var maxIndex = 0

        maxYDic.forEach { (key, value) in
            if value > maxYDic[maxIndex] ?? 0 {
                maxIndex = key
            }
        }

        return CGSize(width: 0, height: maxYDic[maxIndex] ?? 0 + sectionInset.bottom)
    }
}

