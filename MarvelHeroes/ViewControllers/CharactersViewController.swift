//
//  CharactersViewController.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import UIKit
import Lottie
import Gifu

protocol CharactersViewControllerProtocol: AnyObject, LoadingViewProtocol {
    func showCharacters(_ characters: [CharacterListViewModel])
    func showSearchedCharacters(_ characters: [CharacterListViewModel])
    func appendMoreCharacters(_ characters:[CharacterListViewModel])
    func showError(_ errorMessage: String?)
}

/// View that show a list with all the characters. User can scroll, search and navigate to more character details
class CharactersViewController: UIViewController {
    var presenter: CharactersPresenterProtocol
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var emptyResultsView: UIView!
    @IBOutlet private weak var animationView: AnimationView!
    @IBOutlet private weak var emptyResultsLabel: UILabel!
    @IBOutlet private weak var gifView: GIFImageView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var charactersModel: [CharacterListViewModel] = []
    private var filteredCharacters: [CharacterListViewModel] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    private let cellReuseIdentifier = "CharactersTableViewCell"
    
    init(charactersPresenter: CharactersPresenterProtocol) {
        self.presenter = charactersPresenter
        super.init(nibName: "CharactersViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureLoadingView()
        configureSearchView()
        configureEmptyResultsView()
        presenter.getCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureGradientBackground()
    }
    
    /// Method that configures the background view
    private func configureGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradient.topColor, gradient.bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    /// Method that configures the table to see the characters list
    private func configureTableView() {
        let charactersTableViewCell = UINib(nibName: "CharactersTableViewCell", bundle: nil)
        tableView.register(charactersTableViewCell, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.backgroundColor = .clear
    }
    
    /// Method that configures the search view
    private func configureSearchView() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        searchController.delegate = self

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// Method that configures the view to show when no results
    private func configureEmptyResultsView () {
        emptyResultsView.isHidden = true
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        
        emptyResultsLabel.text = "Sorry, character not found"
        emptyResultsLabel.font = UIFont(name: comicsFontName, size: 32.0)
        emptyResultsLabel.textColor = .white
    }
}

extension CharactersViewController: CharactersViewControllerProtocol {
    
    /// Show the characters retrieved from API
    /// - Parameter charactersModel: Characters info retrieved
    func showCharacters(_ charactersModel: [CharacterListViewModel]) {
        self.charactersModel = charactersModel
        
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    /// Show more characters retrieved from API
    /// - Parameter characters: Characters info retrieved
    func appendMoreCharacters(_ characters: [CharacterListViewModel]) {
        characters.forEach { character in
            if !charactersModel.contains(where: { $0.id == character.id }) {
                self.charactersModel.append(character)
            }
        }
        self.tableView.reloadData()
    }
    
    /// Show the characters that match with the search
    /// - Parameter characters: Characters to show
    func showSearchedCharacters(_ charactersModel: [CharacterListViewModel]) {
        self.filteredCharacters = charactersModel
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    /// Shows error view with message. User can cancel or retry
    /// - Parameter errorMessage: Error to show
    func showError(_ errorMessage: String?) {
        charactersModel = []
        self.tableView.reloadData()
        
        let alertController = UIAlertController(title: "App Error",
                                                message: errorMessage ?? "Unknown error description",
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action -> Void in
            self.presenter.getCharacters()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            if filteredCharacters.count == 0 {
                showEmptyResultsView()
            }
            else {
                hideEmptyResultsView()
            }
            return filteredCharacters.count
        } else {
            if charactersModel.count == 0 {
                showEmptyView()
            }
            else {
                hideEmptyResultsView()
            }
            return charactersModel.count
        }
    }
    
    private func showEmptyView() {
        tableView.isHidden = true
        emptyResultsView.isHidden = true
    }
    
    private func showEmptyResultsView() {
        tableView.isHidden = true
        emptyResultsView.isHidden = false
        animationView.play()
    }
    
    private func hideEmptyResultsView() {
        tableView.isHidden = false
        emptyResultsView.isHidden = true
        animationView.stop()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let characterCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? CharactersTableViewCell {
            var characterModel: CharacterListViewModel
            if isFiltering {
                characterModel = filteredCharacters[indexPath.row]
            } else {
                characterModel = charactersModel[indexPath.row]
            }
            characterCell.configureCell(characterModel)
            return characterCell
        } else {
            return UITableViewCell()
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var characterModel: CharacterListViewModel
        if isFiltering {
            characterModel = filteredCharacters[indexPath.row]
        } else {
            characterModel = charactersModel[indexPath.row]
        }
        presenter.navigateToCharacterDetail(character: characterModel)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement: Int
        if isFiltering {
           lastElement = filteredCharacters.count - 5
        } else {
            lastElement = charactersModel.count - 5
        }
        
        if indexPath.row == lastElement && isFiltering == false {
            presenter.getMoreCharacters()
        }
    }
}

extension CharactersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCharacters = charactersModel.filter { character -> Bool in
            return character.name.lowercased().contains(searchText.lowercased())
        }
        if filteredCharacters.count == 0 && searchText.count > 0 {
            presenter.searchCharacters(name: searchText)
        }
        tableView.reloadData()
    }
}

extension CharactersViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController){
        presenter.getCharacters()
    }
}

extension CharactersViewController: LoadingViewProtocol {
    func configureLoadingView() {
        loadingView.addSubview(gifView)
        
        gifView.bringSubviewToFront(loadingView)
        gifView.prepareForAnimation(withGIFNamed: marvelGifName) {}
    }
    
    func startLoading() {
        loadingView.isHidden = false
        loadingView.backgroundColor = UIColor.black
        loadingView.alpha = 0.8
        
        gifView.startAnimatingGIF()
        
        tableView.isHidden = true
        tableView.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        loadingView.isHidden = true
        
        gifView.stopAnimating()
        
        tableView.isHidden = false
        tableView.isUserInteractionEnabled = true
    }
}
