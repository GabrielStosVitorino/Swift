//
//  DataBaseController.swift
//  Estudo
//
//  Created by stefanini on 03/05/22.
//

import Foundation
import CoreData

class DataBseController {
    
    static var persistentController: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Estudo")
        container.loadPersistentStores(completionHandler: {(storeDescription,error) in
        if let error = error as NSError? {
            fatalError("Erro ao criar banco de dados \(error) , \(error.userInfo)")
        }
        })
        return container
    }()
    
    init(){}
    
    class func getContext() -> NSManagedObjectContext {
        return DataBseController.persistentController.viewContext
    }
    
    class func saveContext() -> Bool {
        let context = persistentController.viewContext
        if context.hasChanges {
            do{
                try context.save()
                return true
            }
            catch {
//                let nserror = error as NSError
//                fatalError("Reeo ao acessar o banco de dados \(nserror.userInfo)")
            }
        }
        return false
    }
    
    static func fetchLog<T:NSManagedObject>(logar: T.Type, parametro:NSPredicate) -> [T] {
        let entityName = String(describing: logar)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = parametro
        do {
            let receber = try getContext().fetch(fetchRequest) as? [T]
            guard let objeto = receber else{return []}
            return objeto
        }
        catch{
            return []
        }
    }
}


