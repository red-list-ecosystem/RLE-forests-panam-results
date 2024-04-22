library(readxl)
library(dplyr)
library(stringr)
library(tidyr)
library(readr)

here::i_am("R/xwalks.R")

Chile_IVC_xwalk <- read_csv(here::here("data","xwalk-ChileVeg-IVC.csv"))

xwalk <- read_excel(here::here("data","xwalk-IVC-GET.xlsx"), 
                    sheet=2) |>
  rename("eco_name"=`IVC Macrogroup`) |>
  mutate("eco_code" = str_extract(eco_name, "M[0-9]+")) |>
  filter(!is.na(eco_name))

## reduce column names to EFG code
xwalk <- xwalk |>
  rename_with(~ str_replace(.x,"^([TMF0-9 ]+)\\.([0-9]+)[A-Za-z, */-]+","\\1.\\2"))

## delete spaces in codes
xwalk <- xwalk |>
  rename_with(~ gsub(" ","",.x), starts_with(c("F","M","MFT","FM","TM")))

## fix biome code for coastal functional groups
xwalk <- xwalk |>
  rename_with(~ gsub("TM","MT",.x), starts_with(c("TM")))

## fix "x" and "?" with fixed values
fix_cols <- function(x) {
  case_when(
    x == "x" ~ 0.25,
    x == "?" ~ 0.05,
    TRUE ~ as.numeric(x)
  )
}

xwalk <- xwalk |>
  mutate(across(`T2.1`:`MFT1.3`,
                fix_cols))



IVC_GET_xwalk <- xwalk |> 
  pivot_longer(`T1.1`:`MFT1.3`, names_to = "efg", values_to="membership") %>% 
  filter(!is.na(membership)) |> 
  transmute(eco_code, 
            eco_name, 
            efg_code=str_extract(efg,"[A-Z0-9\\.]+"), 
            biome_code=str_extract(efg,"[A-Z0-9]+"), 
            membership)

xwalk <- read_excel(here::here("data/xwalk-ChileVeg-GET.xlsx"), 
                    sheet=2) |>
  rename("form_name" = starts_with("Chile Form"),
         "eco_name" = starts_with("Vegetation belt")) |>
  mutate(eco_code=`map unit #`) |>
  filter(!is.na(eco_name))


## reduce column names to EFG code
xwalk <- xwalk |>
  rename_with(~ str_replace(.x,"^([TMF0-9 ]+)\\.([0-9]+)[A-Za-z, */-]+","\\1.\\2"))

## delete spaces in codes
xwalk <- xwalk |>
  rename_with(~ gsub(" ","",.x), starts_with(c("F","M","MFT","FM","TM")))

## fix biome code for coastal functional groups
xwalk <- xwalk |>
  rename_with(~ gsub("TM","MT",.x), starts_with(c("TM")))

chile_xwalk <- xwalk |>
  pivot_longer(`T1.1`:`MFT1.3`, names_to = "efg", values_to="membership") %>% 
  filter(!is.na(membership)) %>% 
  transmute(eco_code, form_name, eco_name, 
            efg_code=str_extract(efg,"[A-Z0-9\\.]+"), 
            biome_code=str_extract(efg,"[A-Z0-9]+"), 
            membership)



save(file = here::here("Rdata", "all-xwalks.rda"), IVC_GET_xwalk, Chile_IVC_xwalk)
