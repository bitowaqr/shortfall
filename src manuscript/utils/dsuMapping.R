
# SHORTFALL
# EQ-5D-5L -> 3L MAPPING 
# 07.02.2022
# Paul Schneider

# ADAPTED FROM:
  # The Decision Support Unit (DSU)
  # http://nicedsu.org.uk/mapping-eq-5d-5l-to-3l/ 
  # http://nicedsu.org.uk/wp-content/uploads/2022/02/R-20220207T115958Z-001.zip


# required packages:
# dplyr, magrittr, stringr, purrr

dsu_lookup <- read.csv("./data/dsu_lookup.csv")
dsu_lookup$Domain = as.character(dsu_lookup$Domain)

fun_map = function(var_age,
                   var_male,
                   input,
                   df,
                   dsu_lookup) {
  
  # var_age = Age, var_male = Male, summary = 0/1 for if summary scores are provided
  # Input: either individual domains, or summary score. E.g. 'input = c(1, 3, 5, 1, 5)' or 'input = 0.75'
  
  output = "3L"
  # import tidyverse functions without loading tidyverse
  `%>%` <- magrittr::`%>%`
  
  df = df %>% 
    dplyr::rename(
      "X_male" = dplyr::all_of(var_male),
      "tmp_age" = dplyr::all_of(var_age)
      ) %>%
    dplyr::mutate(
      X_age = dplyr::case_when(
        tmp_age >= 16 & tmp_age < 35 ~ 1,
        tmp_age >= 35 & tmp_age < 45 ~ 2,
        tmp_age >= 45 & tmp_age < 55 ~ 3,
        tmp_age >= 55 & tmp_age < 65 ~ 4,
        tmp_age >= 65 & tmp_age <= 100 ~ 5,
        tmp_age >= 1 &
          tmp_age <= 5 ~ as.double(tmp_age),
        TRUE ~ 9999
      )
    )

    df[input] = sapply(df[input], as.character)   
    df = df %>% 
      dplyr::mutate(
        Domain = purrr::pmap_chr(df[input], stringr::str_c, collapse = "")) %>% 
      dplyr::left_join(
        dplyr::select(
          dsu_lookup, 
          c(Domain, Output, X_age, X_male)
          ), 
        by = c("Domain", "X_age", "X_male")
        )
  
  return(df$Output)
}

# fun_map(
#   var_age = "age",
#   var_male =  "male", 
#   input = c("Y5_1", "Y5_2", "Y5_3", "Y5_4", "Y5_5"),
#   df =  EQdata1,dsu_lookup
#   )  
