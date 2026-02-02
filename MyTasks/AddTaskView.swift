//
//  AddTaskView.swift
//  MyTasks
//
//  Created by Marvin Antonio Martinez Martinez on 01/02/26.
//

import SwiftUI

//vista qeu muestra el formulario para agregar una nueva tarea
struct AddTaskView: View{
    
    //@enviroment: accede al entorno de swiftui
    //dismiss : funcion que cierra este sheer/modal
    @Environment(\.dismiss) var dismiss
    
    //referencia al viewmodel para poder agregar la tarea
    @ObservedObject var viewModel: TaskViewModel
    
    //@state variables locales que controlan el formulario
    @State private var taskTitle="" //textp que escribe el usuario
    @State private var selectedCategory: Task.TaskCategory = .personal //categoria seleccionada
    @State private var showError = false //si mostramos mensaje de error
    
    var body: some View{
        //NavigationStack : barra superior con botones
        NavigationStack{
            ZStack{
                LinearGradient(
                    colors:[Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                //scrollview: permite hacer scroll si el contenifo es grande
                ScrollView{
                    VStack(spacing: 25){
                        //icono decorativo en la parte superior
                        iconHeaderView
                        //campo de texto para el titulo de la tarea
                        taskInputSection
                        //selector de categorias
                        categorySelectionSection
                        //b para guardar tareea
                        saveButton
                    }
                    .padding()
                }
            }
            //titulo del modal
            .navigationTitle("Nueva Tarea")
            .navigationBarTitleDisplayMode(.inline) //titulo pequeño en el centro
            //boton x para cerrar modal
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancelar"){
                        dismiss() //cierra el modal
                    }
                }
            }
            //alert: mensaje de error si el campo esta vacio
            .alert("Campo vacío", isPresented: $showError){
                Button("OK", role: .cancel){}
            } message: {
                Text("Por favor escribe un titulo para la tarea")
            }
            
        }
    }
    
    //vista icono decorativo en el header
    private var iconHeaderView: some View{
        ZStack{
            Circle()
                .fill(Color(selectedCategory.color).opacity(0.2))
                .frame(width: 80, height: 80)
            
            //icono de la categoria seleccionada
            Image(systemName: selectedCategory.icon)
                .font(.system(size:40))
                .foregroundStyle(Color(selectedCategory.color))
        }
        //animacion suave cuando cambia de categoria
        .animation(.spring(response:0.3), value: selectedCategory)
        .padding(.top)
    }
    
    //vista: seleccion del campo de texto
    private var taskInputSection: some View{
        VStack(alignment: .leading, spacing: 10){
           //etiqueta
            Text("Titulo de la tarea")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            //TextField: campo de texto donde el usuario escribe
            TextField("Ej: Comprar leche", text: $taskTitle)
                .textFieldStyle(.plain)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius:12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.5),radius: 5)
                )
                .submitLabel(.done)// boton done en el teclado
        }
    }
    
    //vista : selector de categorias
    private var categorySelectionSection: some View{
        VStack(alignment: .leading, spacing: 12){
            //etiqueta
            Text("Categoria")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            //lazyVsgrid : cuadricula de 2 columnas
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing : 12
            ){
                ForEach(Task.TaskCategory.allCases, id: \.self){category in
                    CategoryButton(category: category,
                                   isSelected: selectedCategory == category) // esta seleccionada?
                    {
                        //accion al tocar: cambiar categoria seleccionada
                        withAnimation(.spring(response:0.3)){
                            selectedCategory = category
                        }
                    }
                    
                }
            }
        }
    }
    
    //vista: boton para guardar la tarea
    private var saveButton: some View{
        Button{
            //validacion: verificamos que el campo no este vacio
            guard !taskTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
                showError=true //mostramos alert del error
                return
            }
            
            //agregamos la tarea usando el viewmodel
            viewModel.addTask(title: taskTitle, category: selectedCategory)
            //cerramos el model
            dismiss()
        }label:{
            //Hstack: icono + texto horizonatal
            HStack{
                Image(systemName: "plus.circle.fill")
                Text("Agregar Tarea")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity) // ocupa todo el ancho
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: .blue.opacity(0.3), radius: 8, y:4 )
        }
        .padding(.top)
    }
    
}

//boton de categoria personalizado
struct CategoryButton: View {
    //propiedades que recibe este componente
    let category: Task.TaskCategory // la categoria a mostrar
    let isSelected: Bool // si esta seleccionada o no
    let action: () -> Void// accion al tocar
    
    var body: some View {
        Button(action: action){
            //vstack: icono arriba , texto abajo
            VStack(spacing:8){
                //icono de la cat
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundStyle(
                        //si esta seleccionada: color , si no : gris
                        isSelected ? Color(category.color) : .secondary
                    )
                //Nombre de la categoria
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? Color(category.color) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                //fondo que cambie segun si esta selecionado
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected
                        ? Color(category.color).opacity(0.15)
                        : Color(.systemGray6)
                    )
                //borde que aparece solo si esta seleccionado
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color(category.color): .clear,
                                lineWidth: 2
                            )
                    )
            )
            //efecto de escala al tocar
            .scaleEffect(isSelected ? 1.05 : 1.0)
            
        }
        .buttonStyle(.plain)
        //animacion suave
        .animation(.spring(response: 0.3), value: isSelected)
    }
}
#Preview{
    AddTaskView(viewModel: TaskViewModel())
}
