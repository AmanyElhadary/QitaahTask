//
//  popularCell.swift
//  QitaahTask
//
//  Created by mac on 9/29/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import Haneke
class popularCell: UITableViewCell {

    @IBOutlet var popularMovies: UILabel!
    @IBOutlet var popularName: UILabel!
    @IBOutlet var popularImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var popularObj_ : popularObject? {
        didSet {
            guard let popularObj = popularObj_ else { return }


            self.popularImg.image = nil

            if let mainImg = popularObj.profile_path {
                let imageStr = "\(LibraryApi.APIConstants.ImagePath)\(mainImg)"
                if let mainImageURL = URL(string: imageStr){
                    self.popularImg.hnk_setImageFromURL(mainImageURL)
                    popularImg.dropShadow()

                }
            }
            if let popularName = popularObj.name {
                self.popularName.text = popularName
            }
            if let popularmovies = popularObj.known_for {
                var movies = ""
                for movie in popularmovies{
                     if let movietitle = movie.title {
                    movies += "\(movietitle)\n"
                    }
                }
                self.popularMovies.text = movies
            }

        }
    }
    
}
