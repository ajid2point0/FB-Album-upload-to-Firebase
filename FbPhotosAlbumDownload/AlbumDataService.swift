//
//  AlbumDataService.swift
//  FbPhotosAlbumDownload
//
//  Created by Abderrahman Ajid on 6/19/17.
//  Copyright © 2017 Abderrahman Ajid. All rights reserved.
//

import Foundation

class AlbumDataService {
    
    static let instance = AlbumDataService()
    
    var albums = [Album]()
    
    func downloadAlbums(completed : @escaping DownloadComplete) {
        
        let parameters = ["fields" : "albums{name, id}"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let dataDict = result as? [String : Any], let albumsDict = dataDict["albums"] as? [String : Any], let data = albumsDict["data"] as? [[String : Any]] {
                for album in data {
                    let albumName = album["name"] as! String
                    let albumId = album["id"] as! String
                    let album = Album(albumName: albumName, albumId: albumId)
                    self.albums.append(album)
                }
            }
            completed()
        }
        
    }
    
    
}
