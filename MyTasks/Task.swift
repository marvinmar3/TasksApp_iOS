//
//  Task.swift
//  MyTasks
//
//  Created by Marvin Antonio Martinez Martinez on 01/02/26.
//

//contiene tipos básicos como date, uuid etc
import Foundation

//Identifiable : permite que swiftui identifique cada tarea de forma unica
// codable : permite convertir ls tsres s json psrs gusrdsrla

struct Task: Identifiable, Codable {
    var id = UUID() //id unico para cada tarea (autom)
    var title : String
    var isCompleted:Bool = false
    var category: TaskCategory
    var createdAt: Date = Date()
    
    //enum define los tipos de categorias posibles
    // string: el valor raw es un texto
    // -codable : se puede guardar
    // caseiterable : podemos listar todas las categorias
    enum TaskCategory: String, Codable, CaseIterable {
        case personal = "Personal"
        case work = "Trabajo"
        case shopping = "Compras"
        case health = "Salud"
        
        //propiedad computada que devuleve el color segu la categoria
        var color : String{
            switch self{
            case .personal: return "blue"
            case .work: return "purple"
            case .shopping: return "orange"
            case .health: return "green"
            }
        }
        
        //propiedad computada que devuelve el icono sf symbol
        var icon: String{
            switch self{
            case .personal: return "person.fill" //icono de persona
            case .work: return "briefcase.fill" //icono de maletin
            case .shopping: return "cart.fill"
            case .health: return "heart.fill"
            }
        }
    }
}

