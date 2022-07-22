//
//  AcronymsViewModel.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import Foundation

protocol AcronymsViewModelable {
    var errorMessage: Container<String?> { get }
    var shouldReloadTableView : Container<Bool> { get }
    func numberOfRows(in section: Int) -> Int
    func data(for indexpath: IndexPath) -> String
    func fetchAcronyms(_ input: String)
}

class AcronymsViewModel: AcronymsViewModelable {
    let service: ServiceProtocol
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    var acronyms: [AcronymsModel] = []
    let error = Container<Bool>(value: false)
    var errorMessage = Container<String?>(value: nil)
    var shouldReloadTableView : Container<Bool> = Container.init(value: false)
    
    func fetchAcronyms(_ input: String) {
        service.fetchDataToDisplay(queryParam: input) { (_ result: Result<[AcronymsData], Error>) in
            switch result {
            case .success(let response):
                self.errorMessage.value = nil
                if response.isEmpty {
                    self.acronyms = []
                    return
                }
                self.acronyms = response.first!.fullFormArray
                self.shouldReloadTableView.value = true
                return
            case .failure(let error):
                self.setError(error.localizedDescription)
            }
        }
    }
    
    func setError(_ message: String) {
        self.error.value = true
        self.errorMessage.value = message
    }
    
    
    func numberOfRows(in section: Int) -> Int {
        return acronyms.count
    }
    
    func data(for indexpath: IndexPath) -> String {
        if indexpath.row < acronyms.count {
            return acronyms[indexpath.row].fullForm
        }
        return ""
    }
}
