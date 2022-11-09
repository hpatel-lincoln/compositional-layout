//
//  SnappingLayoutViewController.swift
//  CompositionalLayout
//
//  Created by Hardik Patel on 11/9/22.
//

import UIKit

class SnappingLayoutViewController: UIViewController {
  
  private struct Constants {
    static let CellReuseIdentifier: String = "SnappingLayoutCell"
  }
  
  @IBOutlet var collectionView: UICollectionView!
  
  private var colors: [UIColor] = [.red, .blue, .orange, .purple]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.decelerationRate = .fast
    collectionView.collectionViewLayout = SnappingLayout()
  }
}

extension SnappingLayoutViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseIdentifier, for: indexPath)
    
    let colorIndex = indexPath.item % colors.count
    cell.backgroundColor = colors[colorIndex]
    cell.layer.cornerRadius = 10
    
    return cell
  }
}
