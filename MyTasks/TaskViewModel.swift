//
//  TaskViewModel.swift
//  MyTasks
//
//  Created by Marvin Antonio Martinez Martinez on 01/02/26.
//

import Foundation
import Combine

//observableobject: permite que swiftui observe cambios en esta clase

class TaskViewModel: ObservableObject {
    //@published: cuando este array cambie , la ui se actualizara autmaticamente
    //este array contiene todas nuestras tareas
    @Published var tasks: [Task] = []
    
    //clave para guardar/cargar tareas en userDefaults (como un nobre de archivo)
    private let tasksKey = "savedTasks"
    
    //init() se ejecuta cuando se crea el viewModel
    //aqui cargamos las tareas guardadas anteriormente
    init(){
        loadTasks()
    }
    
    func addTask(title: String, category: Task.TaskCategory){
        //creamos tarea con datos proporcionados
        let newTask = Task(title: title, category: category)
        
        //AGREGAmos la tarea al array
        tasks.append(newTask)
        
        saveTasks()// guardamos el array actualizado
    }
    
    //funcion: cambiar el estado de completado (true a false o vieversa)
    func toggleTaskCompletion(_ task: Task){
        //buscamos la posicion de la tarea en el array
        if let index = tasks.firstIndex(where: { $0.id == task.id}){
            //cambiamos el estado
            tasks[index].isCompleted.toggle()
            
            saveTasks()
        }
    }
    
    //eliminar tarea
    func deleteTask(_ task: Task){
        //removemos todas las tareas que tengan el mismo id
        tasks.removeAll{ $0.id == task.id}
        
        saveTasks()
    }
    
    //funcion privada: guardar tareas en el almacenamiento local
    private func saveTasks(){
        //intentamos convertir el array de tareas a formato json
        if let encoded = try? JSONEncoder().encode(tasks){
            //guardamos el json en userDefaults connuestra clave
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    //func privada: cargar tareas del almacenamiento local
    private func loadTasks(){
        //intentamos otener los datos guardados con nuestra clave
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           //intentamos convertir el json de vuelta a un array de tareas
        let decoded = try? JSONDecoder().decode([Task].self, from : data){
            //si todo salio bien actualizamos nuestro array
            tasks = decoded
        }
        // si no hay datos guardados , task quedará como array vacío
    }
}
