//
//  DetailViewController.swift
//  Flix
//
//  Created by Jonathan Grider on 1/16/18.
//  Copyright © 2018 Jonathan Grider. All rights reserved.
//

import UIKit

import AlamofireImage

enum MovieKeys {
  static let baseURLString = "https://image.tmdb.org/t/p/w500"
}

class DetailViewController: UIViewController {
  
  @IBOutlet weak var backDropImageView: UIImageView!
  @IBOutlet weak var posterImageview: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var releaseDateLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  

  
  var movie: [String: Any]?
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateColors()
    
    // If we have a movie, set up the labels
    if let movie = movie {
      titleLabel.text = movie["title"] as? String
      releaseDateLabel.text = movie["release_date"] as? String
      //ratingLabel.text = (movie["vote_average"] as! String) + " / 10"
      overviewLabel.text = movie["overview"] as? String
      
      // Set up image views
      let backdropPathString = movie["backdrop_path"] as! String
      let backdropURL = URL(string: MovieKeys.baseURLString + backdropPathString)!
      backDropImageView.af_setImage(withURL: backdropURL)
      
      let posterPathString = movie["poster_path"] as! String
      let posterURL = URL(string: MovieKeys.baseURLString + posterPathString)!
      posterImageview.af_setImage(withURL: posterURL)
    }
    
    // Update Overview text font
    overviewLabel.sizeToFit()
    overviewLabel.numberOfLines = 0
    
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
    
  }
  
}
