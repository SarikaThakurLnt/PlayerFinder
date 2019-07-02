//
//  AppUtility.swift
//  PlayerFinder
//
//  Created by Sarika on 27/06/19.
//  Copyright © 2019 Airadmin. All rights reserved.
//

import Foundation
import UIKit

class AppUtility
{
    static let sharedInstance = AppUtility()
    
    private init()
    {
    }
    
    /**
     Use to check string is valid or not
     - Returns : Bool result string validation
     */
    class func isValid(_ string: String?) -> Bool
    {
        var result : Bool = true
        if string == nil || string!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || string == "<null>"
        {
            result = false
        }
        return result
    }

    /**
     Use to check internet connectivity
     - Returns : Bool result connectivity status
     */
    func isNetworkConnected() -> Bool
    {
        var result = false
        let reach = Reachability.forInternetConnection()
        if reach!.isReachableViaWiFi() || reach!.isReachableViaWWAN()
        {
            result = true
        }
        return result
    }
}

extension UIViewController
{
    /**
     UIViewController extenstion
     Use to show UIAlertController with title and message on UIViewController
     */
    func showAlert( _ screenTitle: String?,msg:String?)
    {
        if AppUtility.isValid(msg)
        {
            let alertVC = UIAlertController(title: AppUtility.isValid(screenTitle) ? screenTitle : nil , message: msg!, preferredStyle: .alert)
            let okAction = UIAlertAction(title: OK, style: .default , handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    // Check Internet connection
    func checkNetwork() -> Bool
    {
        let reach = Reachability.forInternetConnection()
        if reach!.isReachableViaWiFi() || reach!.isReachableViaWWAN() {
            return true
        } else {
            return false
        }
    }

    // Show Loader spinner
    func startActivityIndicator()
    {
        let loc =  self.view.center
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.tag = ACTIVITY_INDICATOR_TAG
        activityIndicator.center = loc
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    func stopActivityIndicator()
    {
        if let activityIndicator = self.view.subviews.filter(
            { $0.tag == ACTIVITY_INDICATOR_TAG}).first as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}


extension StringProtocol
{
    var firstUppercased: String
    {
        return prefix(1).uppercased() + dropFirst()
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}

