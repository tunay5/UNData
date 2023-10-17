data_flow <- function(){

  url_1 <- "https://data.un.org/ws/rest/dataflow/"

  page_1<- xml2::read_xml(url_1)

  ids <- xml2::xml_attr(xml2::xml_find_all(page_1, "//structure:Dataflow"),"id")

  titles <- xml2::xml_text(xml2::xml_find_all(page_1, "//*[@xml:lang='en']"))

  ref_ids <- xml2::xml_attr(xml2::xml_find_all(page_1, "//Ref"),"id")

  agency_ids <- xml2::xml_attr(xml2::xml_find_all(page_1, "//Ref"),"agencyID")

  titles <- titles[-10]

  dataflow <- data.frame(titles, ids, ref_ids, agency_ids)

  dataflow
}



data_structure <- function(dataflow){

  data <- data_flow() |> dplyr::filter(ids == dataflow)

  ref_id <- data[1,3]

  agency_id <- data[1,4]

  url <- paste0("https://data.un.org/ws/rest/datastructure/",agency_id,"/",ref_id,"/?references=children")

  page <- xml2::read_xml(url)

  codelist <- xml2::xml_attr(xml2::xml_find_all(page, "//structure:Codelist"),"id")


  list_1 <- list()

  for(i in 1:length(codelist)){
    name <- codelist[i]
    as <- paste0(paste("//*[@id = '", name, "'", sep = ""),"]")
    data <- data.frame(title = xml2::xml_text(xml2::xml_children(xml2::xml_find_all(page,as))),
                              id = xml2::xml_attr(xml2::xml_children(xml2::xml_find_all(page, as)),"id"))
    data <- data |> tidyr::drop_na()
    list_1[[i]] <- data
    names_data <- paste0(codelist[i])
    alt_pos <- stringr::str_locate_all(names_data, "_")[[1]]
    alt_pos_first <- alt_pos[1,]
    str_sub(names_data, alt_pos_first[1],alt_pos_first[2]) <- ","
    names_data <- gsub(".*,","", names_data)

    names(list_1)[i] <- names_data
  }
  assign(paste0("list_", dataflow), list_1, env = .GlobalEnv)
  list_1
}



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

  get_final_data <- rsdmx::readSDMX(providerId = "UNSD", resource = "data", flowRef = as.character(dataflow),
                                    key = list_1, start = start, end = end)

  get_final_dataset <- data.frame(get_final_data)
  get_final_dataset


  }


