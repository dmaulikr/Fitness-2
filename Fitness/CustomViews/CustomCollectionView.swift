import UIKit

class CustomCollectionView: UICollectionView {
  

  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
    backgroundColor = .clear
    bounces = true
    showsVerticalScrollIndicator = true
    alwaysBounceVertical = true
    alwaysBounceHorizontal = false
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
