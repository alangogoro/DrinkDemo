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
    
}