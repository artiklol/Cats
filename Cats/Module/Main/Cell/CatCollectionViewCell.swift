//
//  CatCollectionViewCell.swift
//  Cats
//
//  Created by Artem Sulzhenko on 09.09.2023.
//

import UIKit

class CatCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "catCell"

    var coverImageView: CoverImageView = {
        let imageView = CoverImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowOffset = CGSizeZero
        imageView.layer.shadowRadius = 5
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy private var catNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var viewModel: CatCollectionViewCellViewModelProtocol? {
        didSet {
            if let viewModel {
                catNameLabel.text = viewModel.catName
                coverImageView.fetchImage(with: viewModel.urlCoverImage)
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubview() {
        [coverImageView, catNameLabel].forEach(contentView.addSubview)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            coverImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            coverImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            coverImageView.heightAnchor.constraint(equalToConstant: 120),

            catNameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 5),
            catNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3),
            catNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3)
        ])
    }
}
