//
//  PhotoDataService.swift
//  FbPhotosAlbumDownload
//
//  Created by Abderrahman Ajid on 6/17/17.
//  Copyright © 2017 Abderrahman Ajid. All rights reserved.
//

import Foundation

class PhotoDataService {
    
    static let instance = PhotoDataService()
    
    var photos = [Photo]()
    
    func downloadPhotos(albumId: String, completed: @escaping DownloadComplete) {
        let parameters = ["fields" : "photos{id, images}"]
        FBSDKGraphRequest(graphPath: albumId, parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let dataDict = result as? [String : Any], let photosDict = dataDict["photos"] as? [String : Any], let dataArray = photosDict["data"] as? [[String : Any]] {
                
                for data in dataArray {
                    let photoId = data["id"] as! String
                    if let images = data["images"] as? [[String : Any]] {
                        let source = images[0]["source"] as! String
                        let photo = Photo(photoId: photoId, photoUrl: source)
                        self.photos.append(photo)
                    }
                }
            }
            completed()
        }
    }
}
