//
//  SnappingLayout.swift
//  CompositionalLayout
//
//  Created by Hardik Patel on 11/9/22.
//

import UIKit

class SnappingLayout: UICollectionViewLayout {
  private var contentInsetVertical: CGFloat = 15
  private var itemWidthPercent: CGFloat = 0.8
  private var itemSpacing: CGFloat = 15
  
  private var cachedAttributes: [UICollectionViewLayoutAttributes] = []
  
  private var collectionViewWidth: CGFloat {
    return collectionView!.bounds.width
  }
  
  private var itemWidth: CGFloat {
    return collectionViewWidth * itemWidthPercent
  }
  
  private var contentInsetHorizontal: CGFloat {
    return collectionViewWidth * (1 - itemWidthPercent) * 0.5
  }
  
  private var contentWidth: CGFloat = 0
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: itemWidth)
  }
  
  override func prepare() {
    super.prepare()
    
    if cachedAttributes.isEmpty {
      collectionView!.contentInset = UIEdgeInsets(top: contentInsetVertical,
                                                  left: contentInsetHorizontal,
                                                  bottom: contentInsetVertical,
                                                  right: contentInsetHorizontal)
      
      let numberOfItems = collectionView!.numberOfItems(inSection: 0)
      
      var x: CGFloat = 0
      for index in 0..<numberOfItems {
        let indexPath = IndexPath(item: index, section: 0)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        attributes.frame = CGRect(x: x, y: 0, width: itemWidth, height: itemWidth)
        cachedAttributes.append(attributes)
        
        let nextIndex = CGFloat(index + 1)
        x = nextIndex * (itemWidth + itemSpacing)
      }
      
      let itemWidthSum = CGFloat(numberOfItems) * itemWidth
      let itemSpacingSum = CGFloat(numberOfItems - 1) * itemSpacing
      contentWidth = itemWidthSum + itemSpacingSum
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    for attributes in cachedAttributes {
      if rect.intersects(attributes.frame) {
        layoutAttributes.append(attributes)
      }
    }
    return layoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cachedAttributes[indexPath.item]
  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    // Account for leading content inset when calculating total scroll drag
    let totalOffsetX = proposedContentOffset.x + contentInsetHorizontal
    let index: CGFloat = round(totalOffsetX/(itemWidth + itemSpacing))
    
    // Subtract by leading content inset to position the card in center
    let targetX = index * (itemWidth + itemSpacing) - contentInsetHorizontal

    return CGPoint(x: targetX, y: proposedContentOffset.y)
  }
}
