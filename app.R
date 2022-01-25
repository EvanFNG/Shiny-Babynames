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
  radioButtons(
    'sex',
    'Select Gender:',
    choices = list('M', 'F'),
    selected = 'F'),
  actionButton(
    'refresh',
    'Plot!'),
  plotOutput('plt'),
  tableOutput('summary')

)

server <- function(input, output, session){

  filtered <- eventReactive(input$refresh, {
    bbynames |>
      filter(
        sex == input$sex,
        name == input$name
      )
  })

  summary_table <- reactive({
    filtered() |>
      slice_max(order_by = prop, n = 5) |>
      arrange(desc(prop)) |>
      mutate(year = as.character(year)) |>
      select(year, count)
  })

  output$plt <- renderPlot({
    filtered() |>
      ggplot(
        aes(
          x = year,
          y = count)) +
      geom_line() +
      scale_x_continuous(breaks = seq(1880, 2020, by = 20)) +
      labs(
        x = '',
        y = 'Births',
        title = str_glue("Babies Named '{filtered()$name}' Over Time"),
        subtitle = '1880 - 2020'
      )
  }, res = 96)

  output$summary <- renderTable({
    summary_table()},
    caption = 'Top 5 Years by Proportion of Population')

}

shinyApp(ui, server)