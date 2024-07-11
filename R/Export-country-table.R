## This code reads information from different files and reformats the results into a table as requested by Sean MacGregor @ IUCN
## 11 Jul 2024

library(dplyr)
here::i_am("R/Export-country-table.R")
load(here::here("Rdata/20150130_EcoVeg_hierarchy.rda"))
load(here::here("Rdata/20181123_MacrogroupsCountry.rda"))
load(here::here("Rdata/all-xwalks.rda"))
load("~/proyectos/Forests-Americas/RLE-forests-panam-results/Rdata/20150401_Macrogroup_validation_data.rda")


EFG_codes <- IVC_GET_xwalk |> 
  group_by(eco_code) |> 
  summarise("Ecosystem Functional Group" = paste(efg_code, collapse=","))

NS_areas <- NS_validation |>
  select(macrogroup, "Area"=NS_current_extent_km2)

Americas_ecosystem_table <- Macrogroups.Country |> 
  select(all_of(c("IVC.Name", "Country"))) |>
  left_join(Macrogroups.Global, by="IVC.Name") |>
  left_join(EFG_codes, by=c("IVC.macrogroup_key"="eco_code")) |>
  left_join(NS_areas, by=c("IVC.Name"="macrogroup")) |>
  rename("Ecosystem Name" = "IVC.Name",
         "Threat Bounds" = "Overall.Bounds",
         "Threat" = "Overall.Category",
         "Trigger" = "Threat.criteria",
         "Country" = "Country.x",
           ) |>
    mutate(
         "Assessment System" = "IUCN RLE 2.2",
         "Source" = "https://doi.org/10.1111/conl.12623",
         "Reference" = "Ferrer-Paris et al. 2019") |>
  select(all_of(c("Ecosystem Name", 
                  "Country",
                  "Ecosystem Functional Group",
                  "Threat",
                  "Threat Bounds",
                  "Trigger",
                  "Area",
                  "Assessment System",
                  "Source",
                  "Reference"
                  ))) 

write.csv(Americas_ecosystem_table, 
          here::here("data", "Americas_ecosystem_datasheet.csv"),
          row.names = FALSE)

