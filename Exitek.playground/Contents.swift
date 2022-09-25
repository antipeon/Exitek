import Foundation
// Implement mobile phone storage protocol
// Requirements:
// - Mobiles must be unique (IMEI is an unique number)
// - Mobiles must be stored in memory

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

struct Mobile: Hashable {
    let imei: String
    let model: String
}

// MARK: - MobileStorageImpl

class MobileStorageImpl {
    private var mobiles = Set<Mobile>()
    
    enum MobileStorageError: Error {
        case mobileAlreadyInStorage
        case mobileNotInStorage
    }
}

// MARK: - MobileStorage
extension MobileStorageImpl: MobileStorage {
    func getAll() -> Set<Mobile> {
        mobiles
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        mobiles.first { mobile in
            mobile.imei == imei
        }
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        let (success, model) = mobiles.insert(mobile)
        guard success else {
            throw MobileStorageError.mobileAlreadyInStorage
        }
        return model
    }
    
    func delete(_ product: Mobile) throws {
        guard mobiles.remove(product) != nil else {
            throw MobileStorageError.mobileNotInStorage
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
        mobiles.contains(product)
    }
}

let iphoneElevenPro = Mobile(imei: UUID().uuidString, model: "iphone11Pro")
let iphoneSE = Mobile(imei: UUID().uuidString, model: "iphoneSE")
let iphoneMiniThirteen = Mobile(imei: UUID().uuidString, model: "iphoneMini13")

let storage: MobileStorage = MobileStorageImpl()

// -MARK: - Simple tests
assert(storage.getAll().isEmpty)
assert((try? storage.save(iphoneElevenPro)) != nil)
assert((try? storage.save(iphoneElevenPro)) == nil)
assert((try? storage.delete(iphoneSE)) == nil)
assert((try? storage.save(iphoneSE)) != nil)
assert(storage.exists(iphoneSE))
assert(storage.exists(iphoneElevenPro))
assert(!storage.exists(iphoneMiniThirteen))
assert(storage.getAll() == [iphoneSE, iphoneElevenPro])
