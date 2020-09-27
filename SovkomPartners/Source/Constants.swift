//
//  Constants.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 07.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

enum Constants {
    
    static let sideOffset: CGFloat = 16
    static let paginationLimit = 30
    
    static let collectionCellHeight: CGFloat = 240
    static let collectionMinimumLineSpacing: CGFloat = 8
    static let collectionMinimumInteritemSpacing: CGFloat = 10
    static let collectionCellSize = CGSize(width: (UIScreen.main.bounds.width - 2 * sideOffset - collectionMinimumLineSpacing) / 2, height: collectionCellHeight)
}
