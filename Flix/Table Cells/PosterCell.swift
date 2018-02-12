//
//  PosterCell.swift
//  Flix
//
//  Created by Jonathan Grider on 1/16/18.
//  Copyright © 2018 Jonathan Grider. All rights reserved.
//

import UIKit

class PosterCell: UICollectionViewCell {
    
  @IBOutlet weak var posterImageView: UIImageView!
  
  var movie: Movie! {
    didSet {
      posterImageView.af_setImage(withURL: movie.posterURL!)
    }
  }
}
