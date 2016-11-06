import UIKit

private let reusableIdentifier = "ExerciseItemCell"

class ViewController: UIViewController {
  
  // MARK: - FLow Layout
  
  lazy var flowLayout: UICollectionViewFlowLayout = {
    var flow = UICollectionViewFlowLayout()
    flow.scrollDirection = .vertical
    flow.sectionInset = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)
    return flow
  }()
  
  // MARK: - UI Objects
  
  lazy var collectionView: CustomCollectionView = {
    let collectionView = CustomCollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(ExerciseCard.self, forCellWithReuseIdentifier: reusableIdentifier)
    
    return collectionView
  }()
  
  lazy var userButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "User"), for: .normal)
    button.setImage(UIImage(named: "User_selected"), for: .highlighted)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  lazy var workoutDayLabel: UILabel = {
    let label = UILabel()
    label.text = "Day 1"
    label.textColor = .white
    label.font = UIFont(name: "Branding-Black", size: 30)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var completedLabel: UILabel =  {
    let label = UILabel()
    label.text = "Completed: 30%"
    label.textColor = Colors.yellowGreen
    label.font = UIFont(name: "Branding-Black", size: 18)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  
  // MARK: - ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
  }
  
  // MARK: - Setup the view
  
  func setupView() {
    // Add visual properties to the view Controller
    view.backgroundColor = Colors.darkBlue
    
    // Add views to the view controller
    [userButton,collectionView, workoutDayLabel,completedLabel].forEach{view.addSubview($0)}
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      userButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Constants.rightMargin*2),
      userButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topMargin + 10),
      userButton.heightAnchor.constraint(equalToConstant: Constants.userIconHeight),
      userButton.widthAnchor.constraint(equalToConstant: Constants.userIconWidth),
      
      collectionView.topAnchor.constraint(equalTo: userButton.bottomAnchor, constant: Constants.topMargin),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Constants.rightMargin),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.leftMargin),
      
      workoutDayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.leftMargin*2),
      workoutDayLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topMargin),
      
      completedLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.leftMargin*2),
      completedLabel.topAnchor.constraint(equalTo: workoutDayLabel.bottomAnchor)
    ])
  }
  
}

// MARK: - CollectionView Extensions

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as? ExerciseCard else { return UICollectionViewCell() }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cardHeight = Constants.cardHeight
    let cardWidth = Constants.cardWidth
    
    return CGSize(width: cardWidth, height: cardHeight)
  }
  
}

