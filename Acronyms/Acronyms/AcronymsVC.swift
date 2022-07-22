//
//  ViewController.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import UIKit

class AcronymsViewController: UIViewController {
    

    @IBOutlet weak var acronymsTableView: UITableView! {
        didSet {
            acronymsTableView.dataSource = self
            acronymsTableView.delegate = self
        }
    }
    
    let viewModel: AcronymsViewModelable = AcronymsViewModel()
    
    lazy var indicatorView: UIActivityIndicatorView = {
      let view = UIActivityIndicatorView(style: .medium)
      view.color = .gray
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setupBindings()
        setupLoader()
        setupLayouts()
    }
    
    private func setUp() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        acronymsTableView.register(AcronymsTableViewCell.self, forCellReuseIdentifier: "AcronymsTableViewCell")

        acronymsTableView.estimatedRowHeight = 80.0
        acronymsTableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupLayouts() {
      NSLayoutConstraint.activate([
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
    }
    
    private func setupBindings() {
        bindTableViewReload()
        bindErrorHandling()
    }
    
    private func bindTableViewReload() {
        viewModel.shouldReloadTableView.bind {[weak self] (needsUpdate) in
            guard needsUpdate == true else {return}
            DispatchQueue.main.async {
                self?.acronymsTableView.isHidden = false
                self?.indicatorView.stopAnimating()
                self?.acronymsTableView.reloadData()
            }
        }
    }
    
    private func bindErrorHandling() {
        viewModel.errorMessage.bind {[weak self] (errorMessage) in
            guard let msg = errorMessage else {
                return
            }
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
                self?.showErrorMessgae(message: msg ?? "")
            }
        }
    }
    
    func setupLoader() {
        self.view.addSubview(indicatorView)
    }
    
    private func showErrorMessgae(message : String) {
        let alertController = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension AcronymsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = viewModel.data(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcronymsTableViewCell", for: indexPath) as! AcronymsTableViewCell
        cell.setData(cellData)
        return cell
    }
}

extension AcronymsViewController: UITableViewDelegate {}

extension AcronymsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        viewModel.fetchAcronyms(text)
        indicatorView.startAnimating()
    }
}

