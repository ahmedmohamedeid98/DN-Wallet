//
//  SettingVC+LanguageAlertSheet.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

extension SettingVC {
    
    func showLanguageActionSheet() {
        let alert = UIAlertController(title: "Choose Language", message: "select your prefere language", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let English = UIAlertAction(title: LanguageSection.English.description , style: .default) { (action) in
            UserDefaults.standard.set(LanguageSection.English.id, forKey: Defaults.Language.key)
            self.settingTable.updateRowWith(indexPaths: [GeneralOptions.language.indexPath], animate: .fade)
        }
        let Arabic = UIAlertAction(title: LanguageSection.Arabic.description , style: .default) { (action) in
            UserDefaults.standard.set(LanguageSection.Arabic.id, forKey: Defaults.Language.key)
            self.settingTable.updateRowWith(indexPaths: [GeneralOptions.language.indexPath], animate: .fade)
        }
        alert.addAction(English)
        alert.addAction(Arabic)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}
