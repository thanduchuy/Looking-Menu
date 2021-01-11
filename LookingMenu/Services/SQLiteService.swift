import Foundation
import SQLite3

private enum ConstantSqlite {
    static let path = "LookingMenu.sqlite"
    static let queryCreateTableDiet = "CREATE TABLE IF NOT EXISTS Diet(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,  calor REAL, recipeSessions TEXT);"
    static let queryCreateTableDietFavourite = "CREATE TABLE IF NOT EXISTS FavouriteDiet(id INTEGER PRIMARY KEY, image TEXT, title TEXT, readyInMinutes Integer);"
    static let queryInsertDataDiet = "INSERT INTO Diet (name, calor, recipeSessions) VALUES (?, ?, ?);"
    static let queryReadDataDiet = "SELECT * FROM Diet"
    static let queryDeleteDataDiet =  "DELETE FROM Diet WHERE id=?;"
    static let queryReadDataDietFavourite = "SELECT * FROM FavouriteDiet"
    static let queryCheckDataDietFavourite = "SELECT * FROM FavouriteDiet WHERE id=?;"
    static let queryInsertDataDietFavourite = "INSERT INTO FavouriteDiet (id, title, readyInMinutes, image) VALUES (?, ?, ?, ?);"
    static let queryDeleteDataDietFavourite = "DELETE FROM FavouriteDiet WHERE id=?;"
}

class SQLiteService {
    var db: OpaquePointer?
    init() {
        db = createDatabaseLookingMenu()
    }
    
    func createDatabaseLookingMenu() -> OpaquePointer? {
        guard let filePath = try? FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: false).appendingPathExtension(
                                                            ConstantSqlite.path)
        else { return nil }
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            return nil
        } else {
            return db
        }
    }
    
    func createTableDiet()  {
        let query = ConstantSqlite.queryCreateTableDiet
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_step(statement)
        } else {
            print("Prepration fail")
        }
    }
    
    func createTableDietFavourite()  {
        let query = ConstantSqlite.queryCreateTableDietFavourite
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_step(statement)
        } else {
            print("Prepration fail")
        }
    }
    
    func insertQueryDiet(name : String, calorie : Double, recipeSessions : [RecipeSession]) {
        let query = ConstantSqlite.queryInsertDataDiet
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            let nameUtf8 = String(describing: name.cString(using: String.Encoding.utf8))
            sqlite3_bind_text(statement, 1, nameUtf8, -1, nil)
            sqlite3_bind_double(statement, 2, Double(calorie))
            guard let data = try? JSONEncoder().encode(recipeSessions)
            else { return }
            let listString = String(data: data, encoding: .utf8)?.cString(using: String.Encoding.utf8)
            sqlite3_bind_text(statement, 3, listString, -1, nil)
            sqlite3_step(statement)
        } else {
            print("Query is not as per requirement")
        }
    }
    
    func readTableDiet() -> [Diet] {
        var result = [Diet]()
        let query = ConstantSqlite.queryReadDataDiet
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let calor = Double(sqlite3_column_double(statement, 2))
                let list = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                guard let data = try? JSONDecoder().decode([RecipeSession].self,
                                                           from: list.data(using: .utf8) ?? Data())
                else { return result }
                let element = Diet(id: id,
                                   name: name,
                                   calor: calor,
                                   recipeSessions: data)
                result.append(element)
            }
        }
        return result
    }
    
    func deleteDiet(idDiet : Int) {
        let query = "DELETE FROM Diet WHERE id=?;"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_int(statement, 1, Int32(idDiet))
            sqlite3_step(statement)
        }
        sqlite3_finalize(statement)
    }
    
    func checkRecipeFavourite(idDiet : Int) -> Bool{
        var result = false
        let query = ConstantSqlite.queryCheckDataDietFavourite
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) ==
            SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(idDiet))
            if sqlite3_step(statement) == SQLITE_ROW {
                result = true
            }
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func insertRecipeFavourite(id: Int, title: String, readyInMinutes: Int, image: String) {
        let query = ConstantSqlite.queryInsertDataDietFavourite
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            let titleUtf8 = String(describing: title.cString(using: String.Encoding.utf8))
            let imageUtf8 = String(describing: image.cString(using: String.Encoding.utf8))
            sqlite3_bind_int(statement, 1, Int32(id))
            sqlite3_bind_text(statement, 2, titleUtf8, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(readyInMinutes))
            sqlite3_bind_text(statement, 4, imageUtf8, -1, nil)
            sqlite3_step(statement)
        }
    }
    
    func deleteDietFavourite(idDiet: Int) {
        let query = ConstantSqlite.queryDeleteDataDietFavourite
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(idDiet))
            sqlite3_step(statement)
        }
        sqlite3_finalize(statement)
    }
    
    func readTableDietFavourite() -> [Recipe] {
        var result = [Recipe]()
        let query = ConstantSqlite.queryReadDataDietFavourite
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let readyInMinutes = Int(sqlite3_column_int(statement, 2))
                let image = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                result.append(Recipe(id: id,
                                     title: title,
                                     readyInMinutes: readyInMinutes,
                                     image: image))
            }
        }
        return result
    }
}
