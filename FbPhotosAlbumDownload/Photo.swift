//
//  Photo.swift
//  FbPhotosAlbumDownload
//
//  Created by Abderrahman Ajid on 6/17/17.
//  Copyright © 2017 Abderrahman Ajid. All rights reserved.
//

import UIKit

class Photo {
    
    var fbPhotoId: String!
    var fbPhotoUrl: String!
    
    var fbPhoto: UIImage!
    
    init(photoId: String, photoUrl: String) {
        self.fbPhotoId = photoId
        self.fbPhotoUrl = photoUrl
    }
    
    func downloadFbPhotos(completed : @escaping DownloadComplete) {
        guard let url = URL(string: fbPhotoUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.async(execute: { 
                self.fbPhoto = UIImage(data: data!)
            })
            completed()
        }.resume()
    }
}
