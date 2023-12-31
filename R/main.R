#' Get Dataflows for United Nations Data and Its Details
#' @description This function will return all dataflows (categories) in UNData database, and its several details in a dataframe.
#' @return
#' @export
#' @details The data.flow column represents dataflows for each variable.
#' @examples
data_flow <- function(){

  url_1 <- "https://data.un.org/ws/rest/dataflow/"

  page_1<- xml2::read_xml(url_1)

  data.flow <- xml2::xml_attr(xml2::xml_find_all(page_1, "//structure:Dataflow"),"id")

  titles <- xml2::xml_text(xml2::xml_find_all(page_1, "//*[@xml:lang='en']"))

  ref_ids <- xml2::xml_attr(xml2::xml_find_all(page_1, "//Ref"),"id")

  agency_ids <- xml2::xml_attr(xml2::xml_find_all(page_1, "//Ref"),"agencyID")

  titles <- titles[-10]

  dataflow <- data.frame(titles, data.flow, ref_ids, agency_ids)

  dataflow
}



#' Get the Data Structure of a Selected Dataflow
#' @description Returns a structure of the selected dataflow.
#' @return
#' @export
#' @details This function will return in a list format which includes all variables (criteria) in selected dataflow. Dataflow ids can be found in data frame that \code{data_flow()} returns.
#' @param dataflow
#' @examples data_structure(dataflow = "DF_UNData_UNFCC")
data_structure <- function(dataflow){

  data <- data_flow() |> dplyr::filter(data.flow == dataflow)

  ref_id <- data[1,3]

  agency_id <- data[1,4]

  url <- paste0("https://data.un.org/ws/rest/datastructure/",agency_id,"/",ref_id,"/?references=children")

  page <- xml2::read_xml(url)

  object_ids <- xml2::xml_attr(xml2::xml_find_all(page, "//structure:DimensionList/structure:Dimension/structure:LocalRepresentation/structure:Enumeration/Ref"),"id")

  object_names <- xml2::xml_attr(xml2::xml_find_all(page, "//structure:DimensionList/structure:Dimension"),"id")

  list_1 <- list()

  for(i in 1:length(object_names)){
    name <- object_ids[i]
    as <- paste0(paste("//*[@id = '", name, "'", sep = ""),"]")
    data <- data.frame(title = xml2::xml_text(xml2::xml_children(xml2::xml_find_all(page,as))),
                              id = xml2::xml_attr(xml2::xml_children(xml2::xml_find_all(page, as)),"id"))
    data <- data |> tidyr::drop_na()
    list_1[[i]] <- data

    names(list_1)[i] <- object_names[i]
  }
  assign(paste0("list_", dataflow), list_1, env = .GlobalEnv)
  list_1
}



#' Get Dataset for Selected Dataflow and Several Filters
#' @description This function will return a dataframe according to the chosen \code{dataflow} and informations in \code{filter}.
#' @return
#' @export
#' @param dataflow
#' @param filter
#' @param start
#' @param end
#' @usage get_data(dataflow, filter, start, end)
#' @details For the filter variable one has to indicate a list which includes vectors that contains the name of variable (criteria) and selected object in this criteria.
#' @examples #To fetch the Environment data for Germany for the indicator of Methane (EN_ATM_METH_XLULUCF) between the years of 2010 and 2015:
#' @examples \code{get_data("DF_UNData_UNFCC", filter = list(c("REF_AREA","DEU"),c("INDICATOR", "EN_ATM_METH_XLULUCF")), start = 2010, end = 2015)}
get_data <- function(dataflow, filter = NULL, start = NULL , end = NULL){
  data <- data_structure(dataflow)

  list_1 <- list()

  for(i in 1:length(data)){
    data_1 <- data[[i]]
    name_data <- names(data)[i]
    for (a in 1:length(filter)) {
      filter_1 <- filter[[a]]
      id_filter_1 <- intersect(as.vector(data_1[,2]), as.vector(filter_1))
      title_filter_1 <- intersect(name_data, as.vector(filter_1))

      if(length(id_filter_1)!=0 & length(title_filter_1)!=0){
        d <- c(id_filter_1)
        break
      }else{
        d <- NULL
        next
      }
    }
    if(!is.null(d)){
      list_1[[i]] <- d
    }else{
      list_1[[i+1]] <- "as"
      list_1[[i+1]] <- d
    }
  }

  tryCatch(data.frame(rsdmx::readSDMX(providerId = "UNSD", resource = "data", flowRef = as.character(dataflow),
                                    key = list_1, start = start, end = end)),
           error = function(e){
             message("The Filtered Data Cannot be Found, Try Another Filter")
           }
  )




  }


