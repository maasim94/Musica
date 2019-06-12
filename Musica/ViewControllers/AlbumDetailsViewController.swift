//
//  AlbumDetailsViewController.swift
//  Musica
//
//  Created by Arslan Asim on 10/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit

final class AlbumDetailsViewController: UIViewController {
    // MARK: - properties
    @IBOutlet weak var tableView: UITableView!
    let spinner = UIActivityIndicatorView(style: .gray)
    var viewModel: AlbumDetailsViewModel!
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInit()
        addActivityIndicator()
        self.title = viewModel.title
        
        viewModel.getAlbumDetails { [weak self] in
            self?.tableView.reloadData()
            self?.spinner.stopAnimating()
        }
        let barButtonItem = UIBarButtonItem(image: getFavImage(isFav: viewModel.selectedAlbum.isFav), style: .plain, target: self, action: #selector(saveUnsaveBarButtonTapped(barButton:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    // MARK: - initialUISetup
    private func tableViewInit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerNib(ArtTableViewCell.self)
        tableView.registerNib(ImageTableViewCell.self)
        tableView.backgroundColor = UIColor.clear
    }
    private func addActivityIndicator() {
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        spinner.startAnimating()
    }
    // MARK: - bar button action
    private func getFavImage(isFav:Bool) -> UIImage? {
        var barImage = UIImage(named: "like")
        if isFav {
            barImage = UIImage(named: "liked")
        }
        return barImage
    }
    
    @objc private func saveUnsaveBarButtonTapped(barButton: UIBarButtonItem) {
        viewModel.saveUnSaveAlbum { (isFav) in
            barButton.image = getFavImage(isFav: isFav)
        }
    }

}
// MARK: - UITableViewDelegate & UITableViewDataSource
extension AlbumDetailsViewController: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(of: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let paralexImageCell: ImageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            paralexImageCell.configureCell(album: viewModel.selectedAlbum)
            return paralexImageCell
        } else {
            let cell: ArtTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureCellFor(track: viewModel.getTrack(for: indexPath.row))
            return cell
        }   
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageTableViewCell {
            imageCell.scrollViewDidScroll(scrollView: scrollView)
        }
    }
}
