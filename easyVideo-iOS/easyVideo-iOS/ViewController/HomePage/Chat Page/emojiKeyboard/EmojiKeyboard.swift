//
//  EmojiKeyboard.swift
//  EasyVideo
//
//  Created by quanhao huang on 2019/11/20.
//  Copyright © 2019 fo. All rights reserved.
//

import UIKit

typealias EmojiBlock = (_ str: String) -> Void
class EmojiKeyboard: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    @objc var emojiPackages: NSMutableArray!
    @objc var emojiBlock: EmojiBlock!
    
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        self.emojiCollectionView.register(UINib(nibName: "EmojiCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell_id")
        
        emojiPackages = Utils.defaultEmoticons()
        
        emojiCollectionView.reloadData()
        
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiPackages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath) as! EmojiCollectionCell
        cell.emojiStr.text = emojiPackages[indexPath.row] as? String
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.emojiBlock != nil {
            self.emojiBlock!(emojiPackages[indexPath.row] as! String)
        }
    }
}
