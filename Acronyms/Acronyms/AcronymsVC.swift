//
//  ViewController.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import UIKit
import Combine

class AcronymsViewController: UIViewController {

    @IBOutlet weak var acronymsTableView: UITableView! {
        didSet {
            acronymsTableView.dataSource = self
            acronymsTableView.delegate = self
        }
    }
    
    private var viewModel: any AcronymViewModelProtocol = AcronymsViewModel()
    private var cancellables = Set<AnyCancellable>()

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
        viewModel.changePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
            .store(in: &cancellables)
    }

    func updateUI() {
        indicatorView.isHidden = !viewModel.isLoading
        if viewModel.isLoading {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }

        if let error = viewModel.error {
            showErrorMessgae(message: error)
            acronymsTableView.isHidden = true
        } else {
            acronymsTableView.isHidden = false
            acronymsTableView.reloadData()
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
        viewModel.acronyms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.acronyms.count else {
            return UITableViewCell() // or a default fallback
        }
        let cellData = viewModel.acronyms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcronymsTableViewCell", for: indexPath) as! AcronymsTableViewCell
        cell.setData(cellData.fullForm)
        return cell
    }
}

extension AcronymsViewController: UITableViewDelegate {}

extension AcronymsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

            if text.trimmingCharacters(in: .whitespaces).isEmpty {
                viewModel.triggerSearch(for: "")
            } else {
                viewModel.triggerSearch(for: text)
                indicatorView.startAnimating()
            }
    }
}


