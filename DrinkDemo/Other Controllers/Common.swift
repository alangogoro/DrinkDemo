//
//  Common.swift
//  DrinkDemo
//
//  Created by usr on 2020/9/3.
//

import Foundation
import UIKit

struct Common {
    
    static let shared = Common()
    
    /* ========== 確認視窗 function ========== */
    func showAlert(in viewController: UIViewController, with message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確認", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
        }))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    /** 確認視窗，按『確定』後返回主頁 */
    func showAlertNavToRoot(in viewController: UIViewController, with message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
            guard let navigationController = viewController.navigationController else { return }
            navigationController.popToRootViewController(animated: true)
        }))
        viewController.present(alertController, animated: true)
    }
    
    /** 初始化 AcitivtyIndicatorView */
    func setIndicator(in viewController: UIViewController,
                      with activityIndicator: UIActivityIndicatorView)
    -> UIActivityIndicatorView {
        
        let view = viewController.view!
        let frame = CGRect(origin: .zero, size: viewController.view.safeAreaLayoutGuide.layoutFrame.size)
        activityIndicator.frame = frame
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                  constant: 0).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: 0).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: 0).isActive = true
                
        activityIndicator.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        activityIndicator.color = UIColor.systemGray
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.alpha = 1
        
        return activityIndicator
        
    }
    func displayActivityIndicator(_ activityIndicator: UIActivityIndicatorView,
                                  isActive: Bool) {
        DispatchQueue.main.async {
            if isActive {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    /* ========== 文字輸入視窗 function ========== */
    func showInputAlertController(in viewController: UIViewController,
                       withTitle title: String,
                       withPlaceholders placeHolders: [String],
                       completionHandler: @escaping (Bool, [String]?) -> Void) {
                    /* 完成後傳出 Bool 和 TextField 的值 */
        
        // 建立 UIAlertController 的主體
        let controller = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        // 利用 placeholder 陣列加入 TextField
        for placeholder in placeHolders {
            controller.addTextField { (textField) in
                textField.placeholder = placeholder
            }
        }
        
        // 若使用者點選確定，就將 TextField 的值 inputsTexts 回傳
        controller.addAction(UIAlertAction(title: "確定", style: .default, handler: { (_) in
            
            viewController.dismiss(animated: true, completion: nil)
            var inputsTexts = [String]()
            guard let textFields = controller.textFields else { return }
            for textField in textFields {
                inputsTexts.append(textField.text!)
            }
            completionHandler(true, inputsTexts)
        }))
        // 如果點選取消，則單純 dismiss AlertController
        controller.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
            completionHandler(false, nil)
        }))
        /* ⚠️ 加上 .present 才會出現 ⚠️ */
        viewController.present(controller, animated: true, completion: nil)
    }
    
    /**
     取得現在日期的字串
     */
    func dateString() -> String {
        let time = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm"
        
        let dateStr = formatter.string(from: time)
        return dateStr
    }

}

struct PropertyKeys {
    static let orderController = "OrderViewController"
}
