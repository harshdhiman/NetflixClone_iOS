//
//  DataPersistentManager.swift
//  NetlifyClone
//
//  
//

import Foundation
import CoreData
import UIKit


enum DataPersistentError:Error {
    case failed
}


class DataPersistentManager{
    static let shared  = DataPersistentManager()
    
    
    
    func saveMovie(with title:Title,completion:@escaping (Result<Void,DataPersistentError>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        
        item.id = Int64(title.id)
        item.title = title.title
        item.video = title.video ?? false
        item.overview = title.overview
        item.posterPath = title.posterPath
        item.originalTitle = title.originalTitle
        item.adult = title.adult
        item.mediaType = title.mediaType
        item.backdrropPath = title.backdropPath
        item.originalLanguage = title.originalLanguage
        item.popularity = title.popularity ?? 0.0
        item.releaseDate = title.releaseDate
        item.voteAverage = title.voteAverage ?? 0.0
        item.voteCount = Int64(title.voteCount ?? 0)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataPersistentError.failed))
        }
    }
    
    func loadSavedMovies(completion : @escaping(Result<[TitleItem],DataPersistentError>)-> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(.failed))
        }
    }
    
    
    func deleteMovie(with item:TitleItem,completion: @escaping (Result<Void,DataPersistentError>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(item)
        
        do {
            try context.save()
            completion(.success(()))
        }catch {
            completion(.failure(.failed))
        }
    }
    
}
