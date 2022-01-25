library(shiny)
library(tidyverse)
source('file_creation.R')

bbynames <- read_csv('bbynames.csv')

ui <- fluidPage(

  textInput(
    'name',
    'Enter a name:',
    value = 'Alexa',
    placeholder = '...'),
  selectInput(
    'sex',
    'Select Gender:',
    choices = list('M', 'F')),
  plotOutput('plt')

)

server <- function(input, output, session){

  filtered <- reactive({
    bbynames |>
      filter(
        sex == input$sex,
        name == input$name
      )
  })

  output$plt <- renderPlot({

    filtered() |>
      ggplot(
        aes(
          x = year,
          y = count)) +
      geom_line() +
      scale_x_continuous(breaks = seq(1880, 2020, by = 20))

  })

}

shinyApp(ui, server)