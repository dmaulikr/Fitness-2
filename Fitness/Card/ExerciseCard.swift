import UIKit

class ExerciseCard: UICollectionViewCell {
  
  lazy var cardImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(named: "Exercise")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.masksToBounds = true
    
    return imageView
  }()
  
  lazy var exerciseNameLabel: UILabel = {
    let label = UILabel()
    label.text = "PushUps"
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
      exerciseNameLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -50),
      exerciseNameLabel.rightAnchor.constraint(equalTo: rightAnchor),
      
      cardImage.leftAnchor.constraint(equalTo: leftAnchor),
      cardImage.topAnchor.constraint(equalTo: topAnchor),
      cardImage.rightAnchor.constraint(equalTo: rightAnchor),
      cardImage.bottomAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor, constant: -30)
    ])
  }
}
