import SwiftUI
#if canImport(FirebaseCore)
import FirebaseCore
#endif

// ========================================================
// ☀️ KURDEXPENSEAPP iOS ENTRY POINT (@main)
// ========================================================

@main
struct KurdExpenseApp_iOS: App {
    @StateObject private var repo = FirebaseExpenseRepository()
    @AppStorage("kurd_app_language") private var savedLanguage: String = AppLanguage.kurdish.rawValue

    init() {
        #if canImport(FirebaseCore)
        FirebaseApp.configure()
        #endif
    }

    private var currentLanguageBinding: Binding<AppLanguage> {
        Binding<AppLanguage>(
            get: { AppLanguage(rawValue: savedLanguage) ?? .kurdish },
            set: { savedLanguage = $0.rawValue }
        )
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if repo.currentUser == nil {
                    KurdishAuthView(lang: currentLanguageBinding)
                        .environmentObject(repo)
                } else {
                    MainTabView(lang: currentLanguageBinding)
                        .environmentObject(repo)
                }
            }
            .preferredColorScheme(.light)
            .environment(\.layoutDirection, (AppLanguage(rawValue: savedLanguage) ?? .kurdish).layoutDirection)
        }
    }
}
