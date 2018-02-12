//
//  Movie.swift
//  Flix
//
//  Created by Jonathan Grider on 2/7/18.
//  Copyright © 2018 Jonathan Grider. All rights reserved.
//

import Foundation

enum MovieKeys {
  static let baseURLString = "https://image.tmdb.org/t/p/w500"
}

class Movie {
  
  var title: String
  var posterURL: URL?
  var backdropURL: URL?
  var overview: String
  
  init(dictionary: [String: Any]) {
    title = dictionary["title"] as? String ?? "No Title"
    overview = dictionary["overview"] as? String ?? "No Overview"
    posterURL = URL(string: MovieKeys.baseURLString + (dictionary["poster_path"] as! String))!
    backdropURL = URL(string: MovieKeys.baseURLString + (dictionary["backdrop_path"] as! String))!
  }
  
  class func movies(dictionaries: [[String: Any]]) -> [Movie] {
    var movies: [Movie] = []
    for dictionary in dictionaries {
      let movie = Movie(dictionary: dictionary)
      movies.append(movie)
    }
    
    return movies
  }
  
}
