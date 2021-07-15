//
//  AppearancesViewController.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit
import Gifu

protocol AppearancesViewControllerProtocol: AnyObject, LoadingViewProtocol {
    func showAppearances(_ appearances: [AppearancesViewModel])
    func showError(_ errorMessage: String)
}

/// View that show collection with all the appearances of a character. User can see image, title and decription
/// of the appearance and click to see more details
class AppearancesViewController: UIViewController {
    var presenter: AppearancesPresenter
    
    let characterId: Int
    let appearanceType: AppearanceType
    var appearancesArray: [AppearancesViewModel]?
    
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var gifView: GIFImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
    init(appearancesPresenter: AppearancesPresenter, characterId: Int, appearanceType: AppearanceType) {
        self.presenter = appearancesPresenter
        self.appearanceType = appearanceType
        self.characterId = characterId
        super.init(nibName: "AppearancesViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureLoadingView()
        presenter.getAppearances(characterId: characterId, apperanceType: appearanceType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureGradientBackground()
    }
    
    /// Method that configures the way to show the appearances
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: AppearanceViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: AppearanceViewCell.identifier)
    }
        
    /// Method that configures the background view
    private func configureGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradient.topColor, gradient.bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension AppearancesViewController: AppearancesViewControllerProtocol {
    
    /// Stores the appearances retrieved and update the collection view to show it
    /// - Parameter appearances: Appearances retrieved from API
    func showAppearances(_ appearances: [AppearancesViewModel]) {
        appearancesArray = appearances
        collectionView.reloadData()
    }
    
    /// Shows error view with message. User can cancel or retry
    /// - Parameter errorMessage: Error to show
    func showError(_ errorMessage: String) {
        let alertController = UIAlertController(title: "App Error",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action -> Void in
            self.dismiss(animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action -> Void in
            self.presenter.getAppearances(characterId: self.characterId, apperanceType: self.appearanceType)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension AppearancesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appearancesArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = appearancesArray?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppearanceViewCell.identifier, for: indexPath) as! AppearanceViewCell
        cell.configure(title: item?.title ?? "",
                       description: item?.description ?? "",
                       imageURL: item?.imageURL ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = appearancesArray?[indexPath.row].id else { return }
        presenter.navigateToAppearanceDetail(item)
    }
}

extension AppearancesViewController: LoadingViewProtocol {
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
    }
    
    func stopLoading() {
        loadingView.isHidden = true
        
        gifView.stopAnimating()
    }
}
