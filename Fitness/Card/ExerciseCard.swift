import UIKit

class ExerciseCard: UICollectionViewCell {
  
  lazy var cardImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.masksToBounds = true
    
    return imageView
  }()
  
  lazy var exerciseNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Branding-SemiLight", size: 16)
    label.textAlignment = .left
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
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
    [cardImage, exerciseNameLabel].forEach{addSubview($0)}
    backgroundColor = .white
  }
  
  func setupCellConstraints(){
    NSLayoutConstraint.activate([
      exerciseNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
      exerciseNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.bottomMargin),
      exerciseNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
      
      cardImage.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.leftMargin),
      cardImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      cardImage.rightAnchor.constraint(equalTo: rightAnchor, constant: Constants.rightMargin ),
      cardImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
    ])
  }
}
