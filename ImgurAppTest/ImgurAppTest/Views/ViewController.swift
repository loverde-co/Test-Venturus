//  
// Copyright (c) 2020 Loverde Co.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
 

import UIKit
import LCEssentials

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var arrayPictures: [ImgurModel] = [ImgurModel]()
    var updatedSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.setupCollectionView(spacings: 20, direction: .vertical, edgesInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), allowMulpleSelection: false)
        
        ImgurModel.request { [unowned self] (objeto) in
            if let output = objeto {
                self.arrayPictures = output
                self.collectionView.reloadData()
            }else{
                let message = LCEMessages.instantiate()
                //message.delegate = self
                message.setDirection = .bottom
                message.setDuration = .fiveSecs
                message.tapToDismiss = true
                message.setBackgroundColor = .darkGray
                message.show(message: "Ops! Tente novamente mais tarde...", withImage: nil, showLoading: false)
            }
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.updatedSize = size
        self.collectionView!.performBatchUpdates(nil, completion: nil)
    }
}

//MARK: - CollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMainCells.identifier, for: indexPath) as? HomeMainCells {
            cell.objeto = arrayPictures[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if updatedSize == nil {
            // At this point, the correct ViewController frame is set.
            self.updatedSize = self.view.frame.size
        }

        // Check for iPad and resize to fit in better
        if LCEssentials.isPad {
            if self.updatedSize.width > self.updatedSize.height {
                return CGSize(width: (self.view.frame.width / 4) - 80, height: (self.view.frame.width / 4) - 80)
            } else {
                return CGSize(width: (self.view.frame.width / 3) - 40, height: (self.view.frame.width / 3) - 40)
            }
        }
        if self.updatedSize.width > self.updatedSize.height {
            return CGSize(width: (self.view.frame.width / 2) - 80, height: (self.view.frame.width / 2) - 80)
        } else {
            return CGSize(width: (self.view.frame.width / 2) - 40, height: (self.view.frame.width / 2) - 40)
        }
    }
}

