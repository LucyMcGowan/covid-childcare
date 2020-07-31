dashboardPage(
  title = "COVID-19 in Childcare Settings",
  dashboardHeader(
    title = "COVID-19 in Childcare Settings",
    titleWidth = 320,
    disable = FALSE
  ),
  dashboardSidebar(
    width = 320,
    sidebarMenu(
      id = "tabs",
      menuItem(
        "Search dataset",
        tabName = "search",
        icon = icon("search")
      ),
      menuItem(
        "Add to the database",
        tabName = "data",
        icon = icon("database")
      ),
      menuItem(
        "Summaries",
        tabName = "summary",
        icon = icon("tachometer-alt")
      ),
      menuItem(
        "About",
        tabName = "about",
        icon = icon("question")
      )
    )
  ),
  dashboardBody(
    useShinyjs(),
    includeCSS("www/custom.css"),
    tags$script(HTML("$('body').addClass('fixed');")),
    tabItems(
      tabItem(
        tabName = "search",
        includeMarkdown("data.md"),
        downloadButton(
          outputId = "download_full",
          label = "Download Full Data"
        ),
        downloadButton(
          outputId = "download_filtered",
          label = "Download Filtered Data"
        ),
        h3("Data set"),
        selectizeInput("age", "Filter the dataset by the following age categories:",
          choices = c(
            "6 weeks to 6 months",
            "6 months to 1 year",
            "Under 1 year",
            "1 to 2 years",
            "2 to 4 years",
            "1 to 3 years",
            "3 to 5 years",
            "5 to 7 years",
            "7 to 10 years",
            "Children over 10",
            "10 to 14 years",
            "14 to 17 years"
          ),
          multiple = TRUE
        ),
        dataTableOutput("df")
      ),
      tabItem(
        tabName = "data",
        tags$iframe(
          id = "googleform",
          src = "https://docs.google.com/forms/d/e/1FAIpQLSeRLl7QcqzUiqj6K6XGdBBpORWTc13tqgqWEe1OTKkpeOQoDA/viewform?embedded=true",
          width = "100%",
          height = 2158,
          frameborder = 0,
          marginheight = 0
        )
      ),
      tabItem(
        tabName = "summary",
        h3("All Settings"),
        dataTableOutput("summary"),
        h3("Texas, Arizona, Florida, California"),
        dataTableOutput("tx_az_fl_ca")
      ),
      tabItem(
        tabName = "about",
        includeMarkdown("about.md")
      )
    )
  )
)
