//
//  ArtistSearchViewController.swift
//  Musica
//
//  Created by Arslan Asim on 10/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit

final class ArtistSearchViewController: UIViewController {
    // MARK: - properties
    let viewModel = ArtistSearchViewModel(dataFetcher: DataFetcher())
    let spinner = UIActivityIndicatorView(style: .gray)
    @IBOutlet weak var tableView: UITableView!
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationSearchBar()
        tableViewInit()
        addActivityIndicator()
        
        viewModel.refreshTableData = { [weak self] in
            self?.tableView.reloadData()
            self?.spinner.stopAnimating()
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
    private func addNavigationSearchBar() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    private func addActivityIndicator() {
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.artistSearchToAlbums {
            guard let destination = segue.destination as? AlbumsListViewController, let sender = sender as? Artist else {
                return
            }
            let albumListViewModel = AlbumsListViewModel(dataFetcher: DataFetcher(), artist: sender)
            destination.viewModel = albumListViewModel
        }
    }

}
// MARK: - UITableViewDelegate & UITableViewDataSource
extension ArtistSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArtTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCellFor(artist: viewModel.getArtist(for: indexPath.row))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.artistSearchToAlbums, sender: viewModel.getArtist(for: indexPath.row))
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.bounds.height + 100 >= scrollView.contentSize.height {
            spinner.startAnimating()
            viewModel.askForNextPage()
        }
    }
}
// MARK: - UISearchBarDelegate
extension ArtistSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getArtistForQuery(name: searchBar.text!)
        spinner.startAnimating()
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
}
