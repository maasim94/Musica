//
//  AlbumsListViewController.swift
//  Musica
//
//  Created by Arslan Asim on 10/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import RealmSwift
final class AlbumsListViewController: UIViewController {
    // MARK: - properties
    @IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
    var viewModel: AlbumsListViewModel!
    let spinner = UIActivityIndicatorView(style: .gray)
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = AccessibilityIdentifiers.albumListView
        tableView.accessibilityIdentifier = AccessibilityIdentifiers.albumListTableView
        tableViewInit()
        addActivityIndicator()
        viewModel.getAlbumsForArtist()
        self.title = viewModel.title
        
        viewModel.refreshTableData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
            }
        }
    }
    // MARK: - initialUISetup
    private func tableViewInit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerNib(ArtTableViewCell.self)
        tableView.backgroundColor = UIColor.clear
    }
    private func addActivityIndicator() {
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        spinner.startAnimating()
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.albumsListToDetails {
            guard let destination = segue.destination as? AlbumDetailsViewController, let sender = sender as? Album else {
                return
            }
            let albumDetailsViewModel = AlbumDetailsViewModel(dataFetcher: DataFetcher(), album: sender, realm: viewModel.realm)
            destination.viewModel = albumDetailsViewModel
        }
    }


}
// MARK: - UITableViewDelegate & UITableViewDataSource
extension AlbumsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArtTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let albumData  = viewModel.getAlbum(for: indexPath.row)
        cell.configureCellFor(album: albumData)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.albumsListToDetails, sender: viewModel.getAlbum(for: indexPath.row))
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.bounds.height + 100 >= scrollView.contentSize.height {
            spinner.startAnimating()
            viewModel.askForNextPage()
        }
    }
}
