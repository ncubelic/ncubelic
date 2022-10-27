public class Keychain {
    
    public enum Identifier: String {
        case accessToken
        case refreshToken
    }
    
    public let identifier: String
    
    public var value: String? {
        get {
            string(forKey: kSecValueData)
        }
        set {
            set(newValue, forKey: kSecValueData)
        }
    }
    
    private var loaded = false
    private var loadedData = NSMutableDictionary()
    private var changedData = NSMutableDictionary()
    
    public init(identifier: String) {
        self.identifier = identifier
        
        resetLoadedData()
    }
    
    public init(identifier: Identifier) {
        self.identifier = identifier.rawValue
        
        resetLoadedData()
    }
    
    public func load() {
        let query = NSMutableDictionary()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrGeneric] = identifier
        query[kSecAttrAccount] = identifier
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnAttributes] = true
        query[kSecReturnData] = true
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        
        var data: AnyObject?
        
        let status = withUnsafeMutablePointer(to: &data) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        if status == errSecSuccess,
            let data = data as? NSDictionary,
            let mutableData = data.mutableCopy() as? NSMutableDictionary {
            
            loadedData = mutableData
        } else {
            resetLoadedData()
        }
        
        changedData.removeAllObjects()
        
        loaded = true
    }
    
    private func resetLoadedData() {
        loadedData.removeAllObjects()
        loadedData[kSecClass] = kSecClassGenericPassword
        loadedData[kSecAttrGeneric] = identifier
        loadedData[kSecAttrAccount] = identifier
    }
    
    @discardableResult public func save() -> Bool {
        let query = NSMutableDictionary()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrGeneric] = identifier
        query[kSecAttrAccount] = identifier
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        
        changedData.forEach {
            self.loadedData[$0.key] = $0.value
        }
        
        if status == errSecSuccess {
            status = SecItemUpdate(query as CFDictionary, changedData as CFDictionary)
        } else {
            loadedData[kSecAttrSynchronizable] = true
            status = SecItemAdd(loadedData, nil)
            loadedData.removeObject(forKey: kSecAttrSynchronizable)
        }
        
        changedData.removeAllObjects()
        
        return status == errSecSuccess
    }
    
    @discardableResult public func remove() -> Bool {
        let success = Keychain.remove(identifier: identifier)
        if success {
            resetLoadedData()
        }
        return success
    }
    
    @discardableResult public class func remove(identifier: String) -> Bool {
        let query = NSMutableDictionary()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrGeneric] = identifier
        query[kSecAttrAccount] = identifier
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        
        let status = SecItemDelete(query as CFDictionary)
        
        return (status == errSecSuccess)
    }
    
    public func string(forKey key: CFString) -> String? {
        if !loaded {
            load()
        }
        
        var string: String?
        
        let data = loadedData[key]
        
        if key == kSecValueData, let data = data as? Data, let password = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            string = password as String
        } else {
            string = loadedData[key] as? String
        }
        
        if string?.isEmpty == true {
            string = nil
        }
        
        return string
    }
    
    public func set(_ string: String?, forKey key: CFString) {
        var newValue: Any?
        
        if let string = string {
            if key == kSecValueData, let data = string.data(using: String.Encoding.utf8) {
                newValue = data
            } else {
                newValue = string
            }
        }
        
        changedData[key] = newValue
    }
    
}
