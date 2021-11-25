
import Foundation
import UIKit

let APPLE_LANGUAGE_KEY = "AppleLanguages"
class SBLanguage {
    static var shared = SBLanguage()
    var currentLanguage: String {
        let langArray = UserDefaults.standard.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        let endIndex = current.startIndex
        let currentWithoutLocale = String(current[..<current.index(endIndex, offsetBy: 2)])
        return currentWithoutLocale
    }
    var currentLanguageFull: String {
        let langArray = UserDefaults.standard.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    func set(language: String) {
        UserDefaults.standard.set([language, self.currentLanguage], forKey: APPLE_LANGUAGE_KEY)
    }
}

extension Bundle {
    @objc func myLocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if self == Bundle.main {
            let currentLanguage = SBLanguage.shared.currentLanguageFull
            var bundle = Bundle();
            if let path = Bundle.main.path(forResource: SBLanguage.shared.currentLanguageFull, ofType: "lproj") {
                bundle = Bundle(path: path)!
            }else
                if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                    bundle = Bundle(path: path)!
                } else {
                    let path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
                    bundle = Bundle(path: path)!
            }
            return (bundle.myLocalizedString(forKey: key, value: value, table: tableName))
        } else {
            return (self.myLocalizedString(forKey: key, value: value, table: tableName))
        }
    }
}
func swizzleMethod(className: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let origMethod: Method = class_getInstanceMethod(className, originalSelector)!;
    let overrideMethod: Method = class_getInstanceMethod(className, overrideSelector)!;
    if (class_addMethod(className, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(className, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}
