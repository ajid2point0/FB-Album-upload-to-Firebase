//
//  Album.swift
//  FbPhotosAlbumDownload
//
//  Created by Abderrahman Ajid on 6/19/17.
//  Copyright © 2017 Abderrahman Ajid. All rights reserved.
//

import UIKit

class Album {
    var fbAlbumName: String!
    var fbAlbumId: String!
    
    init(albumName: String, albumId: String) {
        self.fbAlbumName = albumName
        self.fbAlbumId = albumId
    }
    
}
