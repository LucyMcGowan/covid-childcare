function(input, output, session) {
  d <- read_sheet(as_sheets_id("https://docs.google.com/spreadsheets/d/1e4RGnqt5j7dOqn2uo7lsf97g-8UP0-Z-fLTSngBwvRs"),
    skip = 1,
    sheet = "Raw Data"
  )


  d <- fix_data(d)

  out_d <- reactive({
    ages <- glue_collapse(input$age, sep = "|")
    if (!is.null(input$age)) {
      d %>%
        filter(grepl(ages, `Age Ranges`))
    } else {
      d
    }
  })

  ## Summary ----
  summary <- d %>%
    group_by(`Week of`) %>%
    summarise(
      `Number of Locations` = sum(
        !is.na(`Number of Children`) |
          !is.na(`Number of Staff`) |
          !is.na(`COVID-19 Cases in Children`) |
          !is.na(`COVID-19 Cases in Staff`)
      ),
      `Number of Students Served` = sum(`Number of Children`, na.rm = TRUE),
      `Number of Staff` = sum(`Number of Staff`, na.rm = TRUE),
      `COVID-19 Cases, Students` = sum(`COVID-19 Cases in Children`, na.rm = TRUE),
      `COVID-19 Cases, Staff` = sum(`COVID-19 Cases in Staff`, na.rm = TRUE)
    )

  output$summary <- renderDataTable(summary,
    rownames = FALSE,
    escape = FALSE,
    options = list(
      ordering = FALSE,
      dom = "t",
      autoWidth = TRUE,
      scrollX = TRUE,
      columnDefs = list(list(
        width = "75px",
        targets = "_all"
      ))
    )
  )

  ## Texas, Arizona, Florida, California ----

  tx_az_fl_ca <- d %>%
    filter(State %in% c("Texas", "Arizona", "Florida", "California")) %>%
    group_by(`Week of`) %>%
    summarise(
      `Number of Locations` = sum(
        !is.na(`Number of Children`) |
          !is.na(`Number of Staff`) |
          !is.na(`COVID-19 Cases in Children`) |
          !is.na(`COVID-19 Cases in Staff`)
      ),
      `Number of Students Served` = sum(`Number of Children`, na.rm = TRUE),
      `Number of Staff` = sum(`Number of Staff`, na.rm = TRUE),
      `COVID-19 Cases, Students` = sum(`COVID-19 Cases in Children`, na.rm = TRUE),
      `COVID-19 Cases, Staff` = sum(`COVID-19 Cases in Staff`, na.rm = TRUE)
    )

  output$tx_az_fl_ca <- renderDataTable(tx_az_fl_ca,
    rownames = FALSE,
    escape = FALSE,
    options = list(
      ordering = FALSE,
      dom = "t",
      autoWidth = TRUE,
      scrollX = TRUE,
      columnDefs = list(list(
        width = "75px",
        targets = "_all"
      ))
    )
  )
  output$df <- renderDataTable(out_d() %>%
    select(-starts_with("tracking")),
  rownames = FALSE,
  filter = "top",
  options = list(scrollX = TRUE)
  )

  output$download_full <-
    downloadHandler(
      filename = glue("{Sys.Date()}-covid-childcare-data.csv"),
      content = function(file) {
        write.csv(
          d,
          file
        )
      }
    )
  output$download_filtered <-
    downloadHandler(
      filename = glue("{Sys.Date()}-covid-childcare-filtered-data.csv"),
      content = function(file) {
        write.csv(
          out_d[input[["df_rows_all"]], ],
          file
        )
      }
    )
}
