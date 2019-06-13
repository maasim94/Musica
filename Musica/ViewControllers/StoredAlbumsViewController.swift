//
//  StoredAlbumsViewController.swift
//  Musica
//
//  Created by Arslan Asim on 10/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import RealmSwift
final class StoredAlbumsViewController: UIViewController {
    // MARK: - properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewPointing: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 20.0,
                                             bottom: 10.0,
                                             right: 20.0)
    private let itemsPerRow: CGFloat = 2
    var viewModel: StoredAlbumsViewModel!
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = AccessibilityIdentifiers.storedAlbumView
        collectionView.accessibilityIdentifier = AccessibilityIdentifiers.collectionView
        viewPointing.accessibilityIdentifier = AccessibilityIdentifiers.pointerView
        do {
            let realm = try Realm()
            viewModel = StoredAlbumsViewModel(realm: realm)
        } catch  {
            print("error \(error.localizedDescription)")
        }
        
        initUI()
        collectionViewInit()
        viewModel.refreshCollectionData = { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Saved Albums"
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.title = "" // don't want next controller to have long string but only back
    }
    
    // MARK: - initialUISetup
    private func collectionViewInit() {
        collectionView.registerNib(ArtCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func initUI() {
        if viewModel.isDataEmpty {
            viewPointing.isHidden = false
            collectionView.isHidden = true
            animateImage()
        } else {
            collectionView.isHidden = false
            viewPointing.isHidden = true
        }
    }
    
    private func animateImage() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            var frame = self.imageView.frame
            frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y + 20)
            self.imageView.frame = frame
            
        }, completion: nil)
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.mainPageToDetails {
            guard let destination = segue.destination as? AlbumDetailsViewController, let sender = sender as? Album else {
                return
            }
            let albumDetailsViewModel = AlbumDetailsViewModel(dataFetcher: DataFetcher(), album: sender, realm: try! Realm())
            destination.viewModel = albumDetailsViewModel
        }
    }

}
// MARK: - UICollection
extension StoredAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ArtCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let album =  viewModel.getAlbum(for: indexPath.row) {
            cell.configureCellFor(album: album)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)

    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let album =  viewModel.getAlbum(for: indexPath.row) {
            performSegue(withIdentifier: Segues.mainPageToDetails, sender: album)
        }
    }
    
}
