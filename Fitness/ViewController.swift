import UIKit
import FMDB

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
    label.font = UIFont(name: "Branding-Medium", size: 18)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  // MARK: - Vars
  
  let fitnessClient = FitnessClient()
  var database = ViewController.createDatabase()
  
  var exercises: [Exercise] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  
  var didFinishedFetching: Bool = false {
    didSet {
      // Add the exercises into a table
      for exercise in exercises {
        self.addExerciseToTableSQL(exercise: exercise)
      }
    }
  }
  
  
  // MARK: - ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //Setup the view
    setupView()
    setupConstraints()
    print(database.databasePath())

    do {
      // Open the data base
      try openDatabaseSQL()
      
      // Create a new table
      try createTableSQL()
      
      // If there are exercises inside the stored table, don't read them from the network
      try readExerciseFromTableSQL()
      
      // Fetch the Exercises from the network, if the exercises array is empty
      if exercises.count == 0 {
        fetchExercises()
      } else {
        collectionView.reloadData()
        
        // Close the data base
        closeDatabaseSQL()
      }
    
    } catch (let error) {
      showAlert(title: error.localizedDescription)
    }
    
  }
  
  override func viewDidLayoutSubviews() {
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
  
  // MARK: - Fetch Data from Network
  
  func fetchExercises() {
    fitnessClient.fetchExercises() { result in
      switch result {
      case .Success(let exercises):
        self.exercises = exercises
        self.didFinishedFetching = true
      case .Failure(let error):
        // TODO: Handle no exercises error
        print(error)
      }
    }
  }
  
  func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
      (data, response, error) in
      completion(data, response, error)
      }.resume()
  }
  
  // MARK: SQL Methods
  
  static func createDatabase() -> FMDatabase {
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("exercises.sqlite")
    return FMDatabase(path: fileURL.path)
  }
  
  func openDatabaseSQL() throws {
    if !database.open() {
      throw DataBaseError.notOpened
    }
  }
  
  func closeDatabaseSQL() {
    database.close()
  }
  
  func createTableSQL() throws {
    do {
      try database.executeUpdate("create table if not exists list (id text, name text, image_url text)", values: nil)
    } catch {
      throw DataBaseError.tableNotCreated
    }
  }
  
  func addExerciseToTableSQL(exercise: Exercise)  {
    do {
      let id = exercise.id
      let name = exercise.name
      let image_url = exercise.imageURL
      let insertQuery = "insert into list (id,name,image_url) values (?,?,?)"
      try database.executeUpdate(insertQuery, values: [id,name,image_url])
    } catch {
      showAlert(title: DataBaseError.exerciseNotAdded.rawValue)
    }
  }
  
  func readExerciseFromTableSQL() throws {
    do {
      let queryExercises = "select * from list"
      self.exercises = [Exercise]()
      if let resultSet = database.executeQuery(queryExercises, withArgumentsIn: nil) {
        while resultSet.next() {
          if let id = resultSet.string(forColumn: "id"),
            let name = resultSet.string(forColumn: "name"),
            let url = resultSet.string(forColumn: "image_url") {
            guard let idInt = try id.convertStringToInt() else { throw ConversionError.fromStringToInt }
            print(name)
            exercises.append(Exercise(id: idInt, name: name, imageURL: url))
          }
        }
      }
    } catch {
      throw DataBaseError.execisesCannotBeRead
    }
    
  }
  
  // MARK: - Alert ViewController
  
  // Description: Shows an alert windows
  func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: dismissAlert)
    
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  // Description: Action executed when dismissed an alert window
  func dismissAlert(sender: UIAlertAction) {
  }
  
}

// MARK: - CollectionView Extensions

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return exercises.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as? ExerciseCard else { return UICollectionViewCell() }
    
    // For each item update the exercise Label name
    cell.exerciseNameLabel.text = exercises[indexPath.row].name
    
    // If the length of the label is higher than 25, then decrease the label font size
    if let length = cell.exerciseNameLabel.text?.characters.count {
      if length > 25 {
        cell.exerciseNameLabel.font = UIFont(name: "Branding-SemiLight", size: 14)
      }
    }
    
    // For each item, download the image from the link
    let url = URL(string: exercises[indexPath.row].imageURL)
    
    if let url = url {
      getDataFromUrl(url: url) { (data, response, error)  in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() { () -> Void in
          cell.cardImage.image = UIImage(data: data)
        }
      }
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cardHeight = Constants.cardHeight
    let cardWidth = Constants.cardWidth
    
    return CGSize(width: cardWidth, height: cardHeight)
  }
  
}
