//
//  AlbumsViewController.swift
//  FbPhotosAlbumDownload
//
//  Created by Abderrahman Ajid on 6/16/17.
//  Copyright © 2017 Abderrahman Ajid. All rights reserved.
//

import UIKit
import FirebaseStorage

class AlbumsViewController: UIViewController {
    
    @IBOutlet weak var albumCollectionView: UICollectionView! {
        didSet {
            albumCollectionView.allowsMultipleSelection = false
        }
    }
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var albumId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    func reloadData() {
        AlbumDataService.instance.downloadAlbums {
            DispatchQueue.main.async {
                self.albumCollectionView.reloadData()
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPhotosVC" {
            if let photosVC = segue.destination as? PhotosViewController {
                if let albumId = sender as? String {
                    photosVC.albumId = albumId
                }
            }
        }
        
    }
    
}

extension AlbumsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        albumId = AlbumDataService.instance.albums[indexPath.item].fbAlbumId
        performSegue(withIdentifier: "showPhotosVC", sender: albumId)
        
    }

}

extension AlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumDataService.instance.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! AlbumCell
        cell.albumTitleLabel.text = AlbumDataService.instance.albums[indexPath.item].fbAlbumName
        return cell
    }
}

extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: albumCollectionView.bounds.width / 2 - 5, height: albumCollectionView.bounds.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

class AlbumCell: UICollectionViewCell {
    @IBOutlet weak var albumTitleLabel: UILabel!
}
