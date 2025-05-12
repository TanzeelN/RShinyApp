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
    
    #Variable Selectors for Penguin Plot
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
            geom_line()+
            theme_classic()
    })
    
    output$PenguinDataTable <- renderDT({
        datatable(Data[!is.na(bill_len) & !is.na(bill_dep),
            .(bill_len = round(mean(bill_len),2), bill_dep = round(mean(bill_dep),2)),
            by = .(species,island)],
        selection = 'single')})
    
    observeEvent(input$PenguinDataTable_rows_selected,{
        RowSelected <- input$PenguinDataTable_rows_selected
        
        if(length(RowSelected) == 1){
            RowData <- Data[!is.na(bill_len) & !is.na(bill_dep),
                            .(bill_len = round(mean(bill_len), 2), bill_dep = round(mean(bill_dep), 2)),
                            by = .(species, island)][RowSelected]
            showModal(
                modalDialog(
                    title = paste("Details For: ", RowData$species, " & ",RowData$island),
                    DTOutput("Detail_Table"),
                    easyClose = TRUE,
                    footer = modalButton("Close")
                )
            )
            output$Detail_Table <- renderDT({
                datatable(
                    Data[species == RowData$species & island == RowData$island,],
                    options = list(
                        width = '100%',
                        scrollX = TRUE,
                        autoWidth = TRUE
                    ))
            })
            
        }
    })
    
    
            
    
}


