//
//  CharacterDetailViewController.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit
import Gifu

protocol CharacterDetailViewControllerProtocol: AnyObject, LoadingViewProtocol {
    func showCharacter(_ characterViewModel: CharacterDetailViewModel)
    func showError(_ errorMessage: String)
}

/// View that show all the details of a character. User can see more details of the character (photo and description) and
///  navigate to the differants appearances.
class CharacterDetailViewController: UIViewController {
    var presenter: CharacterDetailPresenter
    var characterViewModel: CharacterDetailViewModel?
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var gifView: GIFImageView!
    @IBOutlet private weak var moreInfoButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
    init(characterDetailPresenter: CharacterDetailPresenter) {
        self.presenter = characterDetailPresenter
        super.init(nibName: "CharacterDetailViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoadingView()
        configureView()
        presenter.showCharacterDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureGradientBackground()
        configureNavigationBar()
    }
    
    /// Method that configures the navigation bar
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: comicsFontName, size: 20)!
        ]
    }
        
    /// Method that configures the way to show the details
    private func configureView() {
        nameLabel.font = UIFont(name: comicsFontName, size: 36)
        nameLabel.textColor = .white
        descriptionLabel.textColor = .white
        moreInfoButton.isHidden = true
    }
            
    @IBAction private func moreInfoButtonTapped(_ sender: Any) {
        presenter.navigateToDetailInfo()
    }
    
    /// Method that configures the gradient background
    private func configureGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradient.topColor, gradient.bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    /// Method that configures the button of the appearances types
    private func configureButtons() {
        characterViewModel?.buttons.forEach({
            let auxView = ItemButtonView()
            auxView.delegate = self
            auxView.configureView(viewModel: $0)
            buttonsStackView.addArrangedSubview(auxView)
        })
    }
}

extension CharacterDetailViewController: CharacterDetailViewControllerProtocol {
    
    /// Stores the character model retrieved and show the info
    /// - Parameter characterViewModel: Info retrieved from API
    func showCharacter(_ characterViewModel: CharacterDetailViewModel) {
        self.characterViewModel = characterViewModel
        
        title = characterViewModel.name
        nameLabel.text = characterViewModel.name
        
        if characterViewModel.description.isEmpty {
            descriptionLabel.text = "(This character hasn't description)"
        } else {
            descriptionLabel.text = characterViewModel.description
        }
        
        if let _ = characterViewModel.detailsUrl {
            moreInfoButton.isHidden = false
        } else {
            moreInfoButton.isHidden = true
        }
        
        photoImageView.setNetworkImage(urlString: characterViewModel.imageURL)
        configureButtons()
    }
    
    /// Shows error view with message. User can cancel or retry
    /// - Parameter errorMessage: Error to show
    func showError(_ errorMessage: String) {
        let alertController = UIAlertController(title: "App Error",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: .default))
        alertController.addAction(UIAlertAction(title: "Retry",
                                                style: .default,
                                                handler: { action -> Void in
                                                    self.presenter.showCharacterDetail()
                                                }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CharacterDetailViewController: ItemButtonViewDelegate {
    func buttonTapped(withType type: AppearanceType) {
        presenter.navigateToAppearances(characterId: characterViewModel?.id ?? 0, appearanceType: type)
    }
}

extension CharacterDetailViewController: LoadingViewProtocol {
    func configureLoadingView() {
        view.addSubview(loadingView)
        loadingView.addSubview(gifView)
        gifView.bringSubviewToFront(loadingView)
        gifView.prepareForAnimation(withGIFNamed: marvelGifName) {}
    }
    
    func startLoading() {
        loadingView.isHidden = false
        loadingView.backgroundColor = UIColor.black
        loadingView.alpha = 0.8
        
        gifView.startAnimatingGIF()
    }

    func stopLoading() {
        loadingView.isHidden = true
        
        gifView.stopAnimating()
    }
}
