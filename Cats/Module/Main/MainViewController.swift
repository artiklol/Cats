//
//  ViewController.swift
//  Cats
//
//  Created by Artem Sulzhenko on 09.09.2023.
//

import UIKit

class MainViewController: UIViewController {

    private lazy var catsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CatCollectionViewCell.self,
                                forCellWithReuseIdentifier: CatCollectionViewCell.identifier)
        return collectionView
    }()

    private lazy var overlayActivityView = UIView()
    private lazy var activityIndicatorView = UIActivityIndicatorView()

    private lazy var totalPage = 0
    private lazy var currentPage = 0

    private var viewModel: MainViewControllerViewModelProtocol? {
        didSet {
            viewModel?.fetchCats(page: 0) {
                DispatchQueue.main.async {
                    self.catsCollectionView.reloadData()
                    self.stopActivityView()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewControllerViewModel()

        addSubview()
        configureLayout()
        configureNavigationBar()
        configureCollectionView()
        startActivityView()

    }

    private func addSubview() {
        [catsCollectionView].forEach(view.addSubview)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            catsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            catsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            catsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            catsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureCollectionView() {
        catsCollectionView.delegate = self
        catsCollectionView.dataSource = self
    }

    private func configureNavigationBar() {
         navigationController?.navigationBar.prefersLargeTitles = true
         navigationItem.title = "Cats 😺"
     }

    private func startActivityView() {
        overlayActivityView.backgroundColor = .gray.withAlphaComponent(0.7)
        overlayActivityView.frame = view.frame
        activityIndicatorView.style = UIActivityIndicatorView.Style.large
        activityIndicatorView.color = .white
        activityIndicatorView.center = CGPoint(x: overlayActivityView.bounds.width / 2,
                                               y: overlayActivityView.bounds.height / 2)
        overlayActivityView.addSubview(activityIndicatorView)
        view.addSubview(overlayActivityView)
        activityIndicatorView.startAnimating()
    }

    private func stopActivityView() {
        activityIndicatorView.stopAnimating()
        overlayActivityView.removeFromSuperview()
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalPage = (viewModel?.numberOfItems() ?? 0)/10
        return viewModel?.numberOfItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatCollectionViewCell.identifier,
                                                            for: indexPath) as? CatCollectionViewCell else {
            return CatCollectionViewCell()
        }

        cell.viewModel = viewModel?.cellViewModel(at: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPage && indexPath.row == (viewModel?.cats.count ?? 0) - 1 {
            startActivityView()
            currentPage = currentPage + 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.viewModel?.fetchNumberPageCats(page: self.currentPage) {
                    self.stopActivityView()
                    self.catsCollectionView.reloadData()
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            viewModel?.selectedCell(for: indexPath)
            guard let catViewModel = viewModel?.viewModelForSelectedCell() else { return }
            let wikiCat = WikiDetailViewController(viewModel: catViewModel)
            navigationController?.pushViewController(wikiCat, animated: true)
        }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.bounds.width - 120
        let cellWidth = (availableWidth / 2) + 10
        return CGSize(width: cellWidth, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
