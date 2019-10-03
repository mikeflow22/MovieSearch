//
//  MovieListTableViewController.swift
//  MovieSearch
//
//  Created by Michael Flowers on 10/3/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { print("something wrong with the text in the searchBar"); return }
        MovieSearchController.shared.fetchMoviesWith(searchTerm: text) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchBar.text = ""
                self.searchBar.resignFirstResponder()
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MovieSearchController.shared.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCellTableViewCell
        let movie = MovieSearchController.shared.movies[indexPath.row]
        if let moviePoster = movie.poster {
            MovieSearchController.shared.fetchPoster(withMovie: moviePoster) { (posterImage) in
                DispatchQueue.main.async {
                    cell.movie = movie
                    cell.poster = posterImage
                }
            }
        }
        // Configure the cell...
        return cell
    }

}
