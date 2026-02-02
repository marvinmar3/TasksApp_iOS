//
//  ContentView.swift
//  MyTasks
//
//  Created by Marvin Antonio Martinez Martinez on 01/02/26.
//

import SwiftUI

//vista principal
struct ContentView: View{
    //@State object: crea y mantiene una instancia unica del viewmodel
    //es como el cerebro que maneja todas las tareas
    @StateObject private var viewModel = TaskViewModel()
    
    //variable que controla si mostramos el sheet para agregar tareas
    @State private var showingAddTask = false
    
    //el body es lo que se muestra en pantalla
    var body: some View{
        //NavigationStack : permite navegacio y agrega la barra superior
        NavigationStack{
            //zstack apila vistas una encima de otra (como capas)
            ZStack{
                //fondo con degradado sutil
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                .ignoresSafeArea() //ocupa toda la pantalla
                
                //VStack: apila vistas verticalmente
                VStack(spacing:0){
                    //si no hay tareas mostramos un estado vacio bonito xd
                    if viewModel.tasks.isEmpty{
                        emptyStateView
                    }else{
                        //si hay tareas mostramos la lista
                        taskListView
                    }
                }
            }
            
            //titulo de la pantalla en la barra de navegacion
            .navigationTitle("Mis Tareas")
            //boton + en esquina sup derecha
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        //cuando se toca mostramos el sheet
                        showingAddTask = true
                    }label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                }
            }
            //sheet: modal que aparece desde abajo
            .sheet(isPresented: $showingAddTask){
                AddTaskView(viewModel: viewModel)
            }
        }
    }
    private var emptyStateView: some View{
        VStack(spacing:20){
            //icono grande del checklist
            Image(systemName: "checklist")
                .font(.system(size:80))
                .foregroundStyle(.gray.opacity(0.5))
            
            //titulo
            Text("No hay tareas")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            //subtitulo
            Text("Toca el botón + para crear tu primera tarea")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxHeight: .infinity) //centra verticalmente
    }
    
    //vista linea de tareas
    private var taskListView: some View{
        //List: crea una lista scrolleable (como uitableview)
        List{
            //foreach : itera sobre cada tarea
            ForEach(viewModel.tasks){ task in
                //componente personalizado para cada tarea
                TaskRowView(task: task, viewModel: viewModel)
                    .listRowSeparator(.hidden) // oculta lineas divisoral
                    .listRowBackground(Color.clear)// fondo transparente
            }
            //ondelete permite eliminar con swipe hacia la izquierda
            .onDelete(perform: deleteTask)
        }
        .listStyle(.plain) //estilo de lista simple sin agrupaciones
        .scrollContentBackground(.hidden) //oculta el fondo blanco predeterminado
    }
    
    //funcion : eliminar tarea con swipe
    private func deleteTask(at offsets: IndexSet){
        //offset contiene loa indices de las tareas a eliminr
        for index in offsets{
            //obtenemos la tarea en ese indice
            let task = viewModel.tasks[index]
            //llamamos a la funcion de viewmodel para eliminarla
            viewModel.deleteTask(task)
        }
    }
}

//mark - vista de fila de tarea (cada item de la lista)

struct TaskRowView: View{
    //la tarea que vamos a mostrar
    let task: Task
    
    //referencia al viewmodel para poder marcar como completada
    let viewModel: TaskViewModel
    
    //state controla la animacion del checkbox
    @State private var isAnimating = false
    
    var body : some View{
        HStack(spacing: 15) {//aplica elem horizontales
            //checkbox para marcar como completada
            Button {
                //animacion con rebote al tocar
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)){
                    viewModel.toggleTaskCompletion(task)
                    isAnimating = true
                }
                
                //despues de 0.3 seg quitamos la animacion
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    isAnimating = false
                }
            } label: {
                ZStack{
                    //circulo de fondo
                    Circle()
                        .stroke(Color(task.category.color), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    //si esta completa, mostrmos en checkmark
                    if task.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                        
                        //circulo relleno detras de checkmark
                        Circle()
                            .fill(Color(task.category.color))
                            .frame(width: 24, height: 24)
                            .scaleEffect(isAnimating ? 1.2 : 1.0) //efecto de escala
                    }
                }
            }
            .buttonStyle(.plain) // sin estilo del boton predeterminado
            
            //contenido de la tarea
            VStack(alignment: .leading, spacing: 4){
                //titulo de la tarea
                Text(task.title)
                    .font(.body)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                    .strikethrough(task.isCompleted)  // tachado si esta completada
                
                //badge de categoria
                HStack(spacing: 4){
                    Image(systemName: task.category.icon)
                        .font(.caption2)
                    Text(task.category.rawValue)
                        .font(.caption)
                }
                .foregroundColor(Color(task.category.color))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Color(task.category.color).opacity(0.15)
                )
                .cornerRadius(6)
            }
            Spacer() // empuja todo a la izquierda
            
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            //fondo blanco con sombra sutil
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y:2)
        )
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

//preview para ver en xcode como se ve
#Preview{
    ContentView()
}
