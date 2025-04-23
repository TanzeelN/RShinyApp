library(shiny)
library(data.table)

ui <- fluidPage(
    radioButtons(
        inputId = "XVars",
        label = "Choose a column:",
        choices = NULL  # choices filled dynamically
    ),
    textOutput("choice")
)

server <- function(input, output, session) {
    # Load your data
    Data <- fread("Penguins.csv")
    
    # Populate the radio buttons with column names
    updateRadioButtons(
        session,
        inputId = "XVars",
        choices = setNames(colnames(Data), colnames(Data))
    )
    
    # Live update based on selection
    output$choice <- renderText({
        req(input$XVars)
        paste("You selected:", input$XVars)
    })
}

shinyApp(ui = ui, server = server)
