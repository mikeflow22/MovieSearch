//
//  MovieCellTableViewCell.swift
//  MovieSearch
//
//  Created by Michael Flowers on 10/3/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class MovieCellTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    var movie: Movie? {
        didSet{
            updateViews()
        }
    }
    var poster: UIImage? {
        didSet{
            updateViews()
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleOfMovieLabel: UILabel!
    @IBOutlet weak var ratingOfMovieLabel: UILabel!
    @IBOutlet weak var movieSummaryTextView: UITextView!
    
    //MARK: - Functions
    func updateViews(){
        guard let movie = movie else {return}
        titleOfMovieLabel.text = movie.title
        ratingOfMovieLabel.text = "\(movie.rating)"
        movieSummaryTextView.text = movie.summary
        
        guard let poster = poster else {return}
        movieImageView.image = poster
    }
    

}
