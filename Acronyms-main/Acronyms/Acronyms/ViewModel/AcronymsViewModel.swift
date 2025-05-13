//
//  AcronymsViewModel.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import Foundation
import Combine

protocol AcronymViewModelProtocol: ObservableObject {
    var acronyms: [AcronymsModel] { get }
    var isLoading: Bool { get }
    var error: String? { get }
    var changePublisher: AnyPublisher<Void, Never> { get }
    func triggerSearch(for query: String)
    func resetSearch()
}

class AcronymsViewModel: AcronymViewModelProtocol {
    let service: AcronymServiceProtocol
    init(service: AcronymServiceProtocol = AcronymService()) {
        self.service = service
        setUpBindings()
    }
    @Published private(set) var acronyms: [AcronymsModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: String?
    private var cancellables = Set<AnyCancellable>()
    private var querySubject = PassthroughSubject<String, Never>()
    private var debounceTime: TimeInterval = 0.5

    var changePublisher: AnyPublisher<Void, Never> {
        Publishers.MergeMany(
            $acronyms.map { _ in () }.eraseToAnyPublisher(),
            $isLoading.map { _ in () }.eraseToAnyPublisher(),
            $error.map { _ in () }.eraseToAnyPublisher()
        )
        .eraseToAnyPublisher()
    }

    func setUpBindings() {
        querySubject
            .debounce(for: .seconds(debounceTime), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(for: query)
            }
            .store(in: &cancellables)
    }

    func triggerSearch(for query: String) {
        querySubject.send(query)
    }

    func resetSearch() {
        acronyms = []
        error = nil
    }

    func performSearch(for query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        // Check if the trimmed query is empty before proceeding
        error = nil
        acronyms = []
        guard !trimmedQuery.isEmpty else {
            isLoading = false
            return
        }
        isLoading = true
        service.fetchAcronyms(for: query) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    guard let firstResponse = response.first else {
                            // Handle case where response is empty
                            self.error = "No acronyms found."
                            self.acronyms = []
                            return
                        }

                        // Safely unwrap and update the acronyms
                        self.acronyms = firstResponse.fullFormArray
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
