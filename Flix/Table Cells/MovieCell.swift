//
//  MovieCell.swift
//  Flix
//
//  Created by Jonathan Grider on 1/14/18.
//  Copyright © 2018 Jonathan Grider. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!
  
  var movie: Movie! {
    didSet {
      titleLabel.text = movie.title
      overviewLabel.text = movie.overview
      posterImageView.af_setImage(withURL: movie.posterURL!)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    
  }
  
}
