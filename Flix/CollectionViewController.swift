//
//  CollectionViewController.swift
//  Flix
//
//  Created by Jonathan Grider on 1/16/18.
//  Copyright © 2018 Jonathan Grider. All rights reserved.
//

import UIKit
import AlamofireImage

class CollectionViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var movies: [[String: Any]] = []
  var refreshControl: UIRefreshControl!
  var alertController: UIAlertController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateColors()
    
    // Set up alert controller
    self.alertController = UIAlertController(title: "Cannot get Movies", message: "The Internet connection appears to be offline.", preferredStyle: .alert)
    
    // create an OK action & add it to the alertController
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
      self.getMovies()
    }
    alertController.addAction(OKAction)
    
    // Set up refresh controller
    self.refreshControl = UIRefreshControl()
    self.refreshControl.tintColor = .white
    refreshControl.addTarget(self, action: #selector (CollectionViewController.refreshTable(_:)), for: .valueChanged)
    collectionView.insertSubview(refreshControl, at: 0)
    collectionView.dataSource = self
    
    getMovies()
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies.count
  }
  
  
  // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
    
    let movie = movies[indexPath.item]
    
    if let posterPathString = movie["poster_path"] as? String {
      
      let posterURL = URL(string: MovieKeys.baseURLString + posterPathString)!
      
      cell.posterImageView.af_setImage(withURL: posterURL)
    }
    
    return cell
    
  }
  
  func getMovies() {
    
    // Start the activity indicator
    //activityIndicator.startAnimating()
    //activityIndicator.hidesWhenStopped = true
    
    let url = URL(string: "https://api.themoviedb.org/3/movie/181808/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: request) { (data, response, error) in
      
      // This will run when the network request returns
      if let error = error {
        print(error.localizedDescription)
        
        // Show error
        self.present(self.alertController, animated: true) { }
        
      } else if let data = data {
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        
        // Get the array of movies & store in global variable
        let movies = dataDictionary["results"] as! [[String: Any]]
        
        // Store the movies in a property to use elsewhere
        self.movies = movies
        
        // Reload your table view data
        self.collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
          // Stop the refresh controller
          self.refreshControl.endRefreshing()
          
          // Stop the activity indicator
          //self.activityIndicator.stopAnimating()
          
          self.collectionView.backgroundColor = .darkGray
          
        }
      }
    }
    task.resume()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func updateColors() {
    
    /* update navbar */
    view.backgroundColor = .darkGray
    let nav = self.navigationController?.navigationBar
    nav?.tintColor = .white
    nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    
    // Update navigation area
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .darkGray
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    navigationController?.navigationBar.barStyle = .black
    
    // Update tab bar area
    tabBarController?.tabBar.shadowImage = UIImage()
    tabBarController?.tabBar.barTintColor = .darkGray        // Sets overall bar tint
    tabBarController?.tabBar.barStyle = .black               // Sets up general style settings (white or black)
    tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.08418696511, green: 0.6317023602, blue: 1, alpha: 1)                // Changes active button color
    tabBarController?.tabBar.selectedItem?.badgeColor = #colorLiteral(red: 0.08418696511, green: 0.6317023602, blue: 1, alpha: 1)   // Changes active button text
    tabBarController?.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.942580149, green: 0.942580149, blue: 0.942580149, alpha: 1)    // Changes inactive button color
  }
  
  @objc func refreshTable(_ refreshControl: UIRefreshControl) {
    getMovies()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let cell = sender as! UICollectionViewCell
    if let indexPath = collectionView.indexPath(for: cell) {
      let destination = segue.destination as! DetailViewController
      destination.movie = movies[indexPath.row]
    }
  }
}
