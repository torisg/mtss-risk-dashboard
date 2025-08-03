library(shiny)
library(tidyverse)
library(DT)
library(plotly)  # ✅ new dependency for interactive chart

# ---- UI ----
ui <- fluidPage(
    titlePanel("MTSS Risk Dashboard"),
    sidebarLayout(
        sidebarPanel(
            fileInput("file_upload", "Upload Student Data (CSV)", accept = ".csv"),
            uiOutput("grade_filter"),
            uiOutput("student_filter"),
            downloadButton("download_data", "Download Filtered Data"),
            br(), br(),
            h4("How Students Are Classified"),
            helpText("Students are placed into tiers based on GPA, attendance, and behavior referrals:\n\n• Tier 1 (On Track): GPA ≥ 3.0, attendance ≥ 95%, and ≤ 1 referral\n• Tier 2 (Monitor Closely): GPA between 2.5–3.0, attendance between 90–95%, or 1–2 referrals\n• Tier 3 (Immediate Support): GPA < 2.5, attendance < 90%, or 3+ referrals")
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Dashboard Overview",
                         h4("Student Risk Overview"),
                         plotlyOutput("tier_plot"),
                         DTOutput("student_table")
                ),
                tabPanel("About", 
                         h4("About This Dashboard"),
                         p("This MTSS Risk Dashboard helps educators identify students at risk and supports data-driven interventions."))
            )
        )
    )
)

# ---- SERVER ----
server <- function(input, output, session) {
    
    # Reactive dataset (reads CSV)
    student_data <- reactive({
        req(input$file_upload)
        read_csv(input$file_upload$datapath)
    })
    
    # Dynamic UI filters
    output$grade_filter <- renderUI({
        req(student_data())
        selectInput("grade_select", "Filter by Grade:",
                    choices = c("All", sort(unique(student_data()$Grade))))
    })
    
    output$student_filter <- renderUI({
        req(student_data())
        selectInput("student_select", "Filter by Student:",
                    choices = c("All", student_data()$Name))
    })
    
    # Filtered dataset based on selections
    filtered_data <- reactive({
        df <- student_data()
        if (input$grade_select != "All") {
            df <- df %>% filter(Grade == input$grade_select)
        }
        if (input$student_select != "All") {
            df <- df %>% filter(Name == input$student_select)
        }
        df
    })
    
    # Interactive tier chart
    output$tier_plot <- renderPlotly({
        req(filtered_data())
        df <- filtered_data()
        
        # Tier classification logic
        df <- df %>% mutate(Risk_Tier = case_when(
            GPA < 2.5 | Attendance_Rate < 0.9 | Behavior_Referrals >= 3 ~ "Tier 3: Immediate Support",
            GPA < 3.0 | Attendance_Rate < 0.95 | Behavior_Referrals >= 1 ~ "Tier 2: Monitor Closely",
            TRUE ~ "Tier 1: On Track"
        ))
        
        # Count students per tier but keep names for hover text
        df_summary <- df %>%
            group_by(Risk_Tier) %>%
            summarise(Count = n(), Students = paste(Name, collapse = ", "))
        
        # Create ggplot with custom colors for tiers
        gg <- ggplot(df_summary, aes(x = Risk_Tier, y = Count, fill = Risk_Tier, text = paste("<b>Students:</b>", Students))) +
            geom_col() +
            geom_text(aes(label = Count), vjust = -0.5) +
            scale_fill_manual(values = c(
                "Tier 1: On Track" = "#4CAF50",        # green
                "Tier 2: Monitor Closely" = "#FFEB3B", # yellow
                "Tier 3: Immediate Support" = "#F44336" # red
            )) +
            labs(title = "Risk Tier Distribution", x = "Tier", y = "Number of Students") +
            theme_minimal()
        
        # Convert to interactive Plotly chart with hover info
        ggplotly(gg, tooltip = c("x", "y", "text"))
    })
    
    # Student table
    output$student_table <- renderDT({
        datatable(filtered_data(), options = list(pageLength = 10))
    })
    
    # Download filtered data
    output$download_data <- downloadHandler(
        filename = function() {
            paste("filtered_students.csv")
        },
        content = function(file) {
            write_csv(filtered_data(), file)
        }
    )
}

# ---- RUN APP ----
shinyApp(ui, server)
