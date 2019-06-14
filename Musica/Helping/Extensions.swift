//
//  TableViewExtension.swift
//  Musica
//
//  Created by Arslan Asim on 10/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit

extension UITableView  {
    
    /// Register UITableViewCell with NIB to UITableView
    ///
    /// - Parameter _: Type of UITableViewCell
    func registerNib<T: UITableViewCell>(_: T.Type)  {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.identifierCell, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: T.identifierCell)
    }
    
    /// dequeue cell from UITableView with indexPath
    ///
    /// - Parameter indexPath:
    /// - Returns: UITableViewCell of specified type
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T  {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifierCell, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifierCell)")
        }
        return cell
    }
}
extension UICollectionView  {
    
    /// Register UICollectionViewCell with NIB to UICollectionView
    ///
    /// - Parameter _: Type of UICollectionViewCell
    func registerNib<T: UICollectionViewCell>(_: T.Type)  {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.identifierCell, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.identifierCell)
    }
    
    /// dequeue cell from UICollectionView with indexPath
    ///
    /// - Parameter indexPath:
    /// - Returns: UICollectionViewCell of specified type
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T  {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifierCell, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifierCell)")
        }
        return cell
    }
}

/// protocol to assign nib name as Identifer
public protocol Reusable {
    static var identifierCell: String { get } // reuse Identifer is also nib name
}
extension UITableViewCell: Reusable {
    public static var identifierCell: String { return String(describing: self)}
}
extension UICollectionViewCell: Reusable {
    public static var identifierCell: String { return String(describing: self)}
}
