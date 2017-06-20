//
//  PhotosViewController.swift
//  FbPhotosAlbumDownload
//
//  Created by Abderrahman Ajid on 6/19/17.
//  Copyright © 2017 Abderrahman Ajid. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView! {
        didSet {
            photosCollectionView.allowsMultipleSelection = true
        }
    }
    
    @IBOutlet weak var dismissbtn: UIButton!
    
    @IBOutlet weak var uploadResultLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var albumId = ""
    
    var selectedPhotos = [Photo]()
    
    @IBAction func uploadImageToFireBase() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        var uploadTask: StorageUploadTask!
        
        for photo in selectedPhotos {
            let imageRef = imagesRef.child(photo.fbPhotoId)
            uploadTask = imageRef.putData(UIImageJPEGRepresentation(photo.fbPhoto, 0.8)!, metadata: metadata)
            
            uploadTask.observe(.progress) { snapshot in
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                DispatchQueue.main.async {
                    
                    if percentComplete < 100 {
                        self.dismissbtn.isHidden = false
                    }
                    
                    self.progressView.isHidden = false
                    self.progressView.progress = Float(percentComplete)
                }
            }
            
            uploadTask.observe(.success) { _ in
                self.uploadResultLabel.textColor = UIColor.black
                self.uploadResultLabel.text = "Upload completed successfully"
            }
            
            uploadTask.observe(.failure) { _ in
                self.uploadResultLabel.textColor = UIColor.red
                self.uploadResultLabel.text = "Upload failed, please try again"
            }
        }
    }
    
    @IBAction func dismiss() {
        
        dismissbtn.isHidden = true
        uploadResultLabel.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    func reloadData() {
        PhotoDataService.instance.downloadPhotos(albumId: albumId) {
            for photo in PhotoDataService.instance.photos {
                photo.downloadFbPhotos(completed: {
                    DispatchQueue.main.async {
                        self.photosCollectionView.reloadData()
                        self.loadingIndicator.stopAnimating()
                    }
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        PhotoDataService.instance.photos.removeAll()
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PictureCell
         selectedPhotos.append(PhotoDataService.instance.photos[indexPath.item])
         cell.layer.borderWidth = 4
         cell.layer.borderColor = UIColor.blue.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PictureCell
         selectedPhotos = selectedPhotos.filter { $0.fbPhotoId != PhotoDataService.instance.photos[indexPath.item].fbPhotoId }
         cell.layer.borderWidth = 0
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoDataService.instance.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! PictureCell
         let photo = PhotoDataService.instance.photos[indexPath.item]
         cell.configureCell(photo)
         return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photosCollectionView.bounds.width / 2 - 5, height: photosCollectionView.bounds.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

class PictureCell: UICollectionViewCell {
    @IBOutlet weak var pictureView: UIImageView!
    
    func configureCell( _ photo: Photo) {
        if photo.fbPhoto != nil {
            pictureView.image = photo.fbPhoto
            pictureView.layer.cornerRadius = 10
            pictureView.layer.masksToBounds = true
        }
    }
    
}

