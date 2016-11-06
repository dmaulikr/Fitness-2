import UIKit

class ExerciseCard: UICollectionViewCell {
  
  lazy var cardImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(named: "Default")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.masksToBounds = true
    
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupCellConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //MARK: - Setup the view
  
  func setupView() {
    layer.cornerRadius = 10
    [cardImage].forEach{addSubview($0)}
    backgroundColor = .white
  }
  
  func setupCellConstraints(){
  }
}
