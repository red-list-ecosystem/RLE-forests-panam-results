#!R --vanilla
require(dplyr)

## This is the raw table of results used for preparing figures in the original peer-reviewed publication:
(load("Rdata/20181123_tablas_Mgs.rda"))

## For criterion A, the current/future estimates for subcriterion A2b are here:
str(b.pres)
## the past/historicals estimates for subcriteria A1 and A3 are here:
str(b.hist)

## For criterion B the estimates of AOO and EOO are here
str(AOOs)

## For criterion C the estimates of future climate change for subcriterion C2a are here:
str(c.futr)
## the estimates of current change in surface water are here:
str(w.pres)

## For criterion D the estimates of current defaunation pressure for subcriterion D2b are here:
str(d.pres) 
## the past/historicals estimates of intensity in resource use for subcriteria D1 and D3 are here:
str(d.hist)


## These tables present  summaries of the results of each subcriterion for the whole ecosystems (`.Global`) and disaggregated by country (`.Country`).
(load("Rdata/20181123_MacrogroupsCountry.rda"))

## Here are the categories for each subcriterion and the overall category of threat with plausible bounds 
str(Macrogroups.Global)
str(Macrogroups.Country)

## Detailed tables for spatial criteria A and B
str(SpatialCriteria.Global)
str(SpatialCriteria.Country)

## Detailed tables for functional criteria C and D
str(FunctionalCriteria.Global)
str(FunctionalCriteria.Country)
