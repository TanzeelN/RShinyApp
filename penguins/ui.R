#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(DT)

ui <- fluidPage(
    #Creates A Panel on the left
    navlistPanel(
        id = "PenguinDashboard",
        "Penguin Dashboard",
        widths = c(2,10),
        tabPanel("Penguin Plot",
                 #keep the varible selectors on the same row
                 fluidRow(
                     column(uiOutput("x_var_selector"),width = 4),
                     column(uiOutput("Y_var_selector"), width = 4)
                     ),
                 plotOutput("PenguinPlot")
                 ),
        tabPanel("Data View",
                 DTOutput("PenguinDataTable"),
                 
                 )
    )
)

