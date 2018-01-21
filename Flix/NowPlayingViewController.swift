//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Jonathan Grider on 1/14/18.
//  Copyright © 2018 Jonathan Grider. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var movies: [[String: Any]] = []
  var filteredMovies: [[String: Any]]!
  var refreshControl: UIRefreshControl!
  var alertController: UIAlertController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Update navbar colors
    updateColors()
    
    // Set up alert controller
    self.alertController = UIAlertController(title: "Cannot get Movies", message: "The Internet connection appears to be offline.", preferredStyle: .alert)
    // create an OK action
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
      self.getMovies()
    }
    
    // add the OK action to the alert controller
    alertController.addAction(OKAction)
    
    // Set up search bar
    searchBar.delegate = self
    
    // Set up refresh controller
    self.refreshControl = UIRefreshControl()
    self.refreshControl.tintColor = .white
    refreshControl.addTarget(self, action: #selector (NowPlayingViewController.refreshTable(_:)), for: .valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    // Update data source
    tableView.dataSource = self
    filteredMovies = movies
    
    // Obtain movie data
    getMovies()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func getMovies() {
    
    // Start the activity indicator
    activityIndicator.startAnimating()
    activityIndicator.hidesWhenStopped = true
    
    let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
        self.filteredMovies = movies
        
        // Reload your table view data
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
          // Stop the refresh controller
          self.refreshControl.endRefreshing()
          
          // Stop the activity indicator
          self.activityIndicator.stopAnimating()
          
          self.tableView.backgroundColor = .darkGray
          
        }
      }
    }
    task.resume()
    
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
    searchBar.resignFirstResponder()
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchBar.showsCancelButton = true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchBar.text = ""
    searchBar.resignFirstResponder()
  }
  
  
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // Filter the movie list as needed
    filteredMovies = searchText.isEmpty ? movies : movies.filter { (item: [String: Any]) -> Bool in
      return (item["title"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
    }
    tableView.reloadData()
  }
  
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredMovies.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    
    // Obtain movie information
    let movie = filteredMovies[indexPath.row]
    let title = movie["title"] as! String
    let overview = movie["overview"] as! String
    let posterPathString = movie["poster_path"] as! String
    let baseURLString = "https://image.tmdb.org/t/p/w500"
    let posterURL = URL(string: baseURLString + posterPathString)!

    // Set MovieCell fields
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview
    cell.posterImageView.af_setImage(withURL: posterURL)
    cell.selectionStyle = .none
    
    
    return cell
  }
  
  @objc func refreshTable(_ refreshControl: UIRefreshControl) {
    getMovies()
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let cell = sender as! UITableViewCell
    if let indexPath = tableView.indexPath(for: cell) {
      let movie = movies[indexPath.row]
      
      let detailViewController = segue.destination as! DetailViewController
      detailViewController.movie = movie
    }
    
    tableView.reloadData()
    
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
    tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.08418696511, green: 0.6317023602, blue: 1, alpha: 1)                  // Changes active button color
    tabBarController?.tabBar.selectedItem?.badgeColor = #colorLiteral(red: 0.08418696511, green: 0.6317023602, blue: 1, alpha: 1)   // Changes active button text
    tabBarController?.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.942580149, green: 0.942580149, blue: 0.942580149, alpha: 1)    // Changes inactive button color
    
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  
  
}
