import UIKit

class CustomCollectionView: UICollectionView {
  

  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
    backgroundColor = .clear
    bounces = true
    isPagingEnabled = true
    showsHorizontalScrollIndicator = true
    alwaysBounceVertical = false
    alwaysBounceHorizontal = true
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
