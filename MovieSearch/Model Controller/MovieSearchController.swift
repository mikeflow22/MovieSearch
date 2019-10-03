//
//  MovieSearchController.swift
//  MovieSearch
//
//  Created by Michael Flowers on 10/3/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import UIKit

//// apikey:  3021207a0f44385e84ef7cc905fb9320
///  baseURL: https://api.themoviedb.org/3/search/movie?api_key=3021207a0f44385e84ef7cc905fb9320&query=Jack+Reacher
struct NamingKeys {
    fileprivate static let baseURLkey = "https://api.themoviedb.org/3/search/movie"
    fileprivate static let apiKey = "3021207a0f44385e84ef7cc905fb9320"
    fileprivate static let querykey = "query"
    fileprivate static let MovieaseURL = "http://image.tmdb.org/t/p/w500"
    
}

class MovieSearchController {
    static let shared = MovieSearchController()
    var movies: [Movie] = []
    func fetchMoviesWith(searchTerm: String, completion: @escaping() -> Void) {
        guard let baseURL = URL(string: NamingKeys.baseURLkey) else {
            print("Error with base url")
            completion()
            return
        }
        //now we have the base url so we can initialize urlcomponents to add the query items
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        //create a dictionary of the query items
        let urlParameters = ["api_Key" : NamingKeys.apiKey, NamingKeys.querykey : searchTerm.lowercased()]
        
        //use compactMap to iterate through the query item dictionary and initialize query items with the keys and values
        var queryItems = urlParameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        
        //assign the query items to urlComponents
        urlComponents?.queryItems = queryItems
        
        //guard the final url
        guard let finalURL = urlComponents?.url else {
            print("Error with final url")
            completion()
            return
        }
        
        print("Final url: \(finalURL)")
        
        //call the urlsession
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("This is the http status code: \(response.statusCode)")
            }
            
            if let error = error {
                print("Error making urlsession network call: \(error) READABLE ERROR: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = data else {
                print("Error unwraping data in the movie urlSession")
                completion()
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let inMovieSearchStruct = try jsonDecoder.decode(MovieSearch.self, from: data)
                let movieArrayInMovieSearchStruct = inMovieSearchStruct.results
                self.movies = movieArrayInMovieSearchStruct
                completion()
            } catch {
                print("Error decoding movie objects: \(error) READABLE ERROR: \(error.localizedDescription)")
                completion()
                return
            }
        }.resume()
        
        func fetchPoster(with movie: String, completion: @escaping(UIImage?) -> Void){
            let movieImageUrl = NamingKeys.MovieaseURL + movie
            guard let url = URL(string: movieImageUrl) else {print("Error with movieImageUrl"); completion(nil) ; return}
            
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print("Error with poster: \(error), READABLE ERROR:::\(error.localizedDescription), \(#function)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("Error unwerapping data for image")
                    completion(nil)
                    return
                }
                
                let image = UIImage(data: data)
                completion(image)
            }.resume()
        }
    }
}
