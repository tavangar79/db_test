import Foundation
import SQLite

class DatabaseHelper {
    static let shared = DatabaseHelper()
    private let db: Connection?
    private let exampleTable = Table("example_table")
    private let id = Expression<Int64>("id")
    private let value = Expression<Int>("value")

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/example.db")
        } catch {
            db = nil
            print("Unable to open database. Error: \(error)")
        }
    }

    func incrementValue() throws {
        guard let db = db else { return }
        let query = exampleTable.select(value).order(id.desc).limit(1)
        if let row = try db.pluck(query) {
            let currentValue = row[value]
            let update = exampleTable.update(value <- currentValue + 1)
            do {
                try db.run(update)
            } catch {
                print("Update failed. Error: \(error)")
            }
        }
    }
}
