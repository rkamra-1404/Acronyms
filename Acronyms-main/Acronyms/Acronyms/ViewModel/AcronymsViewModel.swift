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
    }
    @Published private(set) var acronyms: [AcronymsModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: String?
    private var cancellables = Set<AnyCancellable>()
    private var debounceTime: TimeInterval = 0.5
    private var debounceTask: Task<Void, Never>? = nil

    var changePublisher: AnyPublisher<Void, Never> {
        Publishers.MergeMany(
            $acronyms.map { _ in () }.eraseToAnyPublisher(),
            $isLoading.map { _ in () }.eraseToAnyPublisher(),
            $error.map { _ in () }.eraseToAnyPublisher()
        )
        .eraseToAnyPublisher()
    }
    func triggerSearch(for query: String) {
        debounceTask?.cancel()
        debounceTask = Task {
            do {
                try await Task.sleep(nanoseconds: UInt64(debounceTime * 1_000_000_000))
                guard !Task.isCancelled else { return }
                await performSearch(for: query)
            } catch {
                print("Debounce task was cancelled or an error occurred: \(error)")
            }
        } 
    }

    func resetSearch() {
        acronyms = []
        error = nil
    }

   func performSearch(for query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        // Check if the trimmed query is empty before proceeding
        error = nil
        acronyms = []
        guard !trimmedQuery.isEmpty else {
            isLoading = false
            return
        }
        isLoading = true
        do {
            let response = try await service.fetchAcronyms(for: query)
            guard let firstResponse = response.first else {
                    // Handle case where response is empty
                    self.error = "No acronyms found."
                    self.acronyms = []
                    return
                }

                // Safely unwrap and update the acronyms
                self.acronyms = firstResponse.fullFormArray
        } catch {
            self.error = error.localizedDescription
        }
        self.isLoading = false
    }
}
