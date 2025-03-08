//
//  LanguageManager.swift
//  Waterly
//
//  Created by Sena Çırak on 6.03.2025.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var currentLanguage: String = "en" // Varsayılan dil

    func changeLanguage(to languageCode: String) {
        currentLanguage = languageCode
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        // Uygulamayı yeniden başlatmak için kullanıcıya bir uyarı göster
        let alert = UIAlertController(title: NSLocalizedString("restart_required", comment: ""), message: NSLocalizedString("restart_message", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { _ in
            exit(0) // Uygulamayı kapat
        }))
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first {
                window.rootViewController?.present(alert, animated: true)
            }
    }}







