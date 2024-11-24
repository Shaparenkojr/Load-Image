
import UIKit
class ImagesView: UIView {
    
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 85, height: 85)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: ImagesCell.identifier)
        return collectionView
    }()
    
    private lazy var uiimageview: UIImageView = {
        let imageview = DownloadableImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private let imagesURLs: [String] = [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQDivTbJ6HClFfgSDEjUSP0985sRcn4mClVA&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTb3qEBgNMMiUclbyIwrfbhXEVDvbuEEaR_nA&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUh_NMBK5XlS3Wlfhd3Q4fDz9xENUUkeRAaw&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgvw_13XVmE3WGkFDqWDU_wztRdCZ9_PDQmw&s",
        "https://3dnews.ru/assets/external/illustrations/2023/10/23/1094867/0.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMDfn0028wRKhIRKg_-mO7aEowQYGw-SEh5Q&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiOxk2qny8AqatO0NAXVGi43fHekTLCfASXg&s",
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImagesView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 512
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCell.identifier, for: indexPath) as? ImagesCell else {
            return UICollectionViewCell()
        }
        
        let cellData = imagesURLs[indexPath.item % imagesURLs.count]
        cell.configureImage(for: cellData)
        return cell
    }
}

private extension ImagesView {
    
    func setupView() {
        addSubview(imagesCollectionView)
        

        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imagesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
