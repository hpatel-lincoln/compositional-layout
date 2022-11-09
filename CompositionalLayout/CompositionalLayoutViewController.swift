//
//  CompositionalLayoutViewController.swift
//  CompositionalLayout
//
//  Created by Hardik Patel on 11/9/22.
//

import UIKit

class CompositionalLayoutViewController: UIViewController {
  
  private struct Constants {
    static let ItemInsetVertical: CGFloat = 7.5
    static let ItemInsetHorizontal: CGFloat = 7.5
    
    static let SectionInsetVertical: CGFloat = 7.5
    static let SectionInsetHorizontal: CGFloat = 0
    
    static let ItemWidthPercent: CGFloat = 0.8
    
    static let CellReuseIdentifier: String = "CompositionalLayoutCell"
    static let CellCornerRadius: CGFloat = 10
  }
  
  enum Section: Int {
    case main = 0
  }
  
  @IBOutlet var collectionView: UICollectionView!
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
  private var colors: [UIColor] = [.red, .blue, .orange, .purple]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.collectionViewLayout = configureCollectionViewLayout()
    configureDataSource()
    configureSnapshot()
  }
  
  private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: Constants.ItemInsetVertical,
                                                 leading: Constants.ItemInsetHorizontal,
                                                 bottom: Constants.ItemInsetVertical,
                                                 trailing: Constants.ItemInsetHorizontal)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(Constants.ItemWidthPercent),
      heightDimension: .fractionalWidth(Constants.ItemWidthPercent)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.contentInsets = NSDirectionalEdgeInsets(top: Constants.SectionInsetVertical,
                                                    leading: Constants.SectionInsetHorizontal,
                                                    bottom: Constants.SectionInsetVertical,
                                                    trailing: Constants.SectionInsetHorizontal)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { [unowned self]
      collectionView, indexPath, number -> UICollectionViewCell? in
      
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: Constants.CellReuseIdentifier,
        for: indexPath
      )
      
      let colorIndex = indexPath.item % colors.count
      cell.backgroundColor = colors[colorIndex]
      cell.layer.cornerRadius = Constants.CellCornerRadius
      
      return cell
    }
  }
  
  private func configureSnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
    snapshot.appendSections([.main])
    let numbers = stride(from: 0, to: 10, by: 1)
    snapshot.appendItems(Array(numbers), toSection: .main)
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
