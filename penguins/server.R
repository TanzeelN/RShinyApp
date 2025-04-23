#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(data.table)
library(ggplot2)

server <- function(input,output){
    Data <- fread("Penguins.csv")
    
    
    output$x_var_selector <- renderUI({
        radioButtons(
            inputId = "XVars",
            label = "X",
            choices = setNames(seq_along(colnames(Data)), colnames(Data)),
            selected = input$XVars
        )
    })

    output$Y_var_selector <- renderUI({
        radioButtons(
            inputId = "YVars",
            label = "Y",
            choices = setNames(seq_along(colnames(Data)),colnames(Data)),
            selected = input$YVars 
        )
    })
    
    SelectedColumnX <- reactive({
        colnames(Data)[as.integer(input$XVars)]
    })
        
    SelectedColumnY <- reactive({
        colnames(Data)[as.integer(input$YVars)]
    })
        
    output$PenguinPlot <- renderPlot({
        ggplot(Data, aes(x = .data[[SelectedColumnX()]], y = .data[[SelectedColumnY()]] ))+
            geom_line()
    })
    
            
    
}


