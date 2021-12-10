//
//  PostViewController.swift
//  firebaseApp
//
//  Created by fedot on 08.12.2021.
//

import UIKit
import SnapKit
import Photos

class PostViewController: UIViewController {
    let identifier = "Cell"
    var colView: UICollectionView!
    let stackViewVerticalFooter = UIStackView()
    let selectedImage = UIImageView()
    var images = [PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 103, height: 103)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        colView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        colView.delegate   = self
        colView.dataSource = self
        colView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: identifier)
        
        view.addSubview(selectedImage)
        view.addSubview(stackViewVerticalFooter)
        stackViewVerticalFooter.addSubview(colView)
        settingStackV()
        settingContraints()
        requestPhotoLibrary()
        
        selectedImage.clipsToBounds = true
        
        
    }

    private func settingStackV() {
        stackViewVerticalFooter.distribution = .fill
        stackViewVerticalFooter.axis = .vertical
        
    }
    private func settingContraints() {
        selectedImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.right.equalToSuperview()
            make.height.equalTo(stackViewVerticalFooter)
        }
        stackViewVerticalFooter.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(400)
            make.height.equalTo(400)
        }
    }
    
    private func requestPhotoLibrary() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard self != nil else { return }
            if status == .authorized {
                let assetsImage = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assetsImage.enumerateObjects { object, _, _ in
                    self?.images.append(object)
                }
                
                DispatchQueue.main.async {
                    self?.images.reverse()
                    self?.colView.reloadData()
                }
            }
        }
    }
    
    
}

extension PostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            self.selectedImage.image = cell.image.image
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let selectedImages = self.images[indexPath[0]]
            let manager = PHImageManager.default()
            manager.requestImage(for: selectedImages, targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.height), contentMode: .default, options: nil) { image, _ in
                    DispatchQueue.main.async {
                        self.selectedImage.image = image
                    }
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CollectionViewCell else { fatalError("cell error") }
        
        let images = self.images[indexPath.row]
        
        let manager = PHImageManager.default()
        
        manager.requestImage(for: images, targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.height), contentMode: .default, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.image.image = image
            }
        }
        
        return cell
    }
}
