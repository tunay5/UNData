
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

    ##                               titles               data.flow
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

## data_structure()

After selecting which dataflow you want to fetch data from, if you want
to see the data structure, the informations on the data of selected
dataflow, you should use function. It will also assign the list of
selected dataflow into your global environment.

Since this function returns a list of variables for the selected
dataflow, to get the dataframe for a variable (COMMODITY variable for
DF_UNDATA_ENERGY dataflow) use:

``` r
data_structure(dataflow = "DF_UNDATA_ENERGY")

list_DF_UNDATA_ENERGY$COMMODITY
```

    ##                    title   id
    ## 1              Hard Coal 0100
    ## 2             Anthracite 0110
    ## 3            Coking coal 0121
    ## 4  Other bituminous coal 0129
    ## 5             Brown Coal 0200
    ## 6    Sub-bituminous coal 0210
    ## 7                Lignite 0220
    ## 8         Coke Oven Coke 0311
    ## 9               Gas Coke 0312
    ## 10           Patent fuel 0320

## get_data()

With information that you accumulated from function, you are able to
fetch data based on these information.

Let’s say you want to fetch the Environment data (DF_UNData_UNFCC
dataflow) for Germany for the indicator of Methane (EN_ATM_METH_XLULUCF)
between the years of 2010 and 2015:

``` r
get_data("DF_UNData_UNFCC", filter = list(c("REF_AREA","DEU"),c("INDICATOR", "EN_ATM_METH_XLULUCF")), start = 2010, end = 2015)
```

    ##   FREQ           INDICATOR REF_AREA   UNIT obsTime obsValue
    ## 1    A EN_ATM_METH_XLULUCF      DEU Gg_CO2    2010 58139.52
    ## 2    A EN_ATM_METH_XLULUCF      DEU Gg_CO2    2011 57051.24
    ## 3    A EN_ATM_METH_XLULUCF      DEU Gg_CO2    2012 57597.41
    ## 4    A EN_ATM_METH_XLULUCF      DEU Gg_CO2    2013 56966.25
    ## 5    A EN_ATM_METH_XLULUCF      DEU Gg_CO2    2014 55847.31
    ## 6    A EN_ATM_METH_XLULUCF      DEU Gg_CO2    2015 55626.71

## Notes

To reach the database (UNData):

<https://data.un.org/SdmxBrowser/start>

To learn more and understand the basics of how sdmx api of UNSD works,
check out:

<https://unstats.un.org/sdgs/files/SDMX_SDG_API_MANUAL.pdf>

<https://data.un.org/Host.aspx?Content=API>


