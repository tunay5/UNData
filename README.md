
# Install Package

First, you have to install devtools package and adding to your library

``` r
install.packages("devtools")
library(devtools)
```

And then you can download UN package by tools that devtools provides

``` r
install_github("tunay5/UNData")
library(UN)
```

## data_flow()

data_flow() function will return a dataframe which includes dataflows in
UN database, the names of each dataflow and other (unimportant for your
usage) details of each dataflow.

``` r
data_flow()
```

    ##                               titles                     ids
    ## 1          Annual financial accounts         NASEC_IDCFINA_A
    ## 2       Quarterly financial accounts         NASEC_IDCFINA_Q
    ## 3      Annual non-financial accounts         NASEC_IDCNFSA_A
    ## 4   Quarterly non-financial accounts         NASEC_IDCNFSA_Q
    ## 5                 NA Main Aggregates                 NA_MAIN
    ## 6  SEEA Global DSD for Air Emissions                 SEEAAIR
    ## 7         SEEA Global DSD for Energy                 SEEANRG
    ## 8                          SDMX-MDGs           DF_UNDATA_MDG
    ## 9     SDG Harmonized Global Dataflow              DF_SDG_GLH
    ## 10                   SDMX_UIS_UNData           DF_UNData_UIS
    ## 11                  SDMX-CountryData   DF_UNDATA_COUNTRYDATA
    ## 12        Energy statistics dataflow        DF_UNDATA_ENERGY
    ## 13                  SEEA SUPPLY DATA   DF_UNDATA_SEEA_SUPPLY
    ## 14                     SEEA USE DATA      DF_UNDATA_SEEA_USE
    ## 15           Energy Balance DataFlow DF_UNData_EnergyBalance
    ## 16                   SDMX_GHG_UNDATA         DF_UNData_UNFCC
    ## 17   WB World Development Indicators           DF_UNDATA_WDI

## data_structure

After selecting which dataflow you want to fetch data from, if you want
to see the data structure, the informations on the data of selected
dataflow, is appopriate.
