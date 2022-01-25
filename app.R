# Required packages. Install if they are not installed.
packages_used <- c('tidyverse', 'shiny', 'fs')
invisible(lapply(packages_used, function(x) if(!x %in% installed.packages()) install.packages(x)))

library(shiny)
library(tidyverse)
library(fs)
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
    choices = list('M', 'F'),
    selected = 'F'),
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