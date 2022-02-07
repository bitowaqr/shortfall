# QALE estimation

rm(list=ls())

# load ref df with life table (ONS) and HRQoL estimates (HSE) by age and sex 
ref_df = read.csv("./data/ref_df.csv")

# load function to compute life and quality-adjusted life expectancies
source("./utils/compQale.R")

# QALEs MAIN RESULT 1 van Hout et al. -------
  Qx_mat = c()
  for(i in 1:nrow(ref_df)){
    age = ref_df$age[i]
    sex = ref_df$sex[i]
    for(j in c(0,0.015, 0.035)){
      qale_ij = compQale(
        ons_df = ref_df,
        prop_female = ifelse(sex == "female", 1,0),
        start_age = age,
        disc_rate = j,
        utils = "cw"
      ) 
      res_ij = c(
        "age" = age,
        "sex" = sex,
        "discount" = j, 
        "Qx" = formatC(qale_ij$Qx[qale_ij$age == age], digits = 2, format = "f")
        )
      Qx_mat = rbind(Qx_mat, res_ij)
    }
  }
    
  Qx_mat = data.frame(Qx_mat)
  Qx_mat$col = paste0(Qx_mat$sex,"_", Qx_mat$discount)
  Qx_mat = Qx_mat[,c("age","col","Qx")]
  Qx_mat = reshape(Qx_mat, direction = "wide", timevar = "col", idvar = "age")
  
  Lx_f = compQale(
    ons_df = ref_df,
    prop_female = 1,
    start_age = 0,
    disc_rate = 0
  )$ex
  
  Lx_m = compQale(
    ons_df = ref_df,
    prop_female = 0,
    start_age = 0,
    disc_rate = 0
  )$ex
  
  Qx_cw_df = data.frame(
    age = Qx_mat$age,
    
    f_Lx    = Lx_f,
    f_Qx_0  = Qx_mat$Qx.female_0,
    f_Qx_15 = Qx_mat$Qx.female_0.015,
    f_Qx_35 = Qx_mat$Qx.female_0.035,
    
    m_Lx    = Lx_m,
    m_Qx_0  = Qx_mat$Qx.male_0,
    m_Qx_15 = Qx_mat$Qx.male_0.015,
    m_Qx_35 = Qx_mat$Qx.male_0.035
  )
  
  write.csv(Qx_cw_df, "./output/Qx_cw_df.csv", row.names = F)
  

# QALEs MAIN RESULT 2 Hernandez-Alva et al. -------
  Qx_mat = c()
  for(i in 1:nrow(ref_df)){
    age = ref_df$age[i]
    sex = ref_df$sex[i]
    for(j in c(0,0.015, 0.035)){
      qale_ij = compQale(
        ons_df = ref_df,
        prop_female = ifelse(sex == "female", 1,0),
        start_age = age,
        disc_rate = j,
        utils = "co"
      ) 
      res_ij = c(
        "age" = age,
        "sex" = sex,
        "discount" = j, 
        "Qx" = formatC(qale_ij$Qx[qale_ij$age == age], digits = 2, format = "f")
      )
      Qx_mat = rbind(Qx_mat, res_ij)
    }
  }
  
  Qx_mat = data.frame(Qx_mat)
  Qx_mat$col = paste0(Qx_mat$sex,"_", Qx_mat$discount)
  Qx_mat = Qx_mat[,c("age","col","Qx")]
  Qx_mat = reshape(Qx_mat, direction = "wide", timevar = "col", idvar = "age")
  
  Lx_f = compQale(
    ons_df = ref_df,
    prop_female = 1,
    start_age = 0,
    disc_rate = 0
  )$ex
  
  Lx_m = compQale(
    ons_df = ref_df,
    prop_female = 0,
    start_age = 0,
    disc_rate = 0
  )$ex
  
  Qx_co_df = data.frame(
    age = Qx_mat$age,
    
    f_Lx    = Lx_f,
    f_Qx_0  = Qx_mat$Qx.female_0,
    f_Qx_15 = Qx_mat$Qx.female_0.015,
    f_Qx_35 = Qx_mat$Qx.female_0.035,
    
    m_Lx    = Lx_m,
    m_Qx_0  = Qx_mat$Qx.male_0,
    m_Qx_15 = Qx_mat$Qx.male_0.015,
    m_Qx_35 = Qx_mat$Qx.male_0.035
  )
  
  write.csv(Qx_co_df, "./output/Qx_co_df.csv", row.names = F)
  
  
  
  
  
# APPENDIX: using MVH population norms ----
  
  mvh_df = read.csv("./data/mvh_df.csv")
  
  ##### data for publication
  
  # HRQoL by age and sex
  mvh_hrqol_df = mvh_df[,c("sex","age5_str","tto")]
  mvh_hrqol_df = mvh_hrqol_df[!duplicated(mvh_hrqol_df),]
  mvh_hrqol_df$tto = formatC(mvh_hrqol_df$tto, digits = 2, format = "f")
  mvh_hrqol_df = reshape(mvh_hrqol_df, direction = "wide", timevar = "sex", idvar = "age5_str")
  names(mvh_hrqol_df) = c("age", "female", "male")
  write.csv(mvh_hrqol_df, "./output/mvh_hrqol_df.csv")
  
  
  # QALEs
  Qx_mat = c()
  for(i in 1:nrow(mvh_df)){
    age = mvh_df$age[i]
    sex = mvh_df$sex[i]
    for(j in c(0,0.015, 0.035)){
      qale_ij = compQale(
        ons_df = mvh_df,
        prop_female = ifelse(sex == "female", 1,0),
        start_age = age,
        disc_rate = j,
        utils = "tto"
      ) 
      res_ij = c(
        "age" = age,
        "sex" = sex,
        "discount" = j, 
        "Qx" = formatC(qale_ij$Qx[qale_ij$age == age], digits = 2, format = "f")
      )
      Qx_mat = rbind(Qx_mat, res_ij)
    }
  }
  
  Qx_mat = data.frame(Qx_mat)
  Qx_mat$col = paste0(Qx_mat$sex,"_", Qx_mat$discount)
  Qx_mat = Qx_mat[,c("age","col","Qx")]
  Qx_mat = reshape(Qx_mat, direction = "wide", timevar = "col", idvar = "age")
  
  Lx_f = compQale(
    ons_df = mvh_df,
    prop_female = 1,
    start_age = 0,
    disc_rate = 0,
    utils = "tto"
  )$ex
  
  Lx_m = compQale(
    ons_df = mvh_df,
    prop_female = 0,
    start_age = 0,
    disc_rate = 0,
    utils = "tto"
  )$ex
  
  Qx_mvh_df = data.frame(
    age = Qx_mat$age,
    
    f_Lx    = Lx_f,
    f_Qx_0  = Qx_mat$Qx.female_0,
    f_Qx_15 = Qx_mat$Qx.female_0.015,
    f_Qx_35 = Qx_mat$Qx.female_0.035,
    
    m_Lx    = Lx_m,
    m_Qx_0  = Qx_mat$Qx.male_0,
    m_Qx_15 = Qx_mat$Qx.male_0.015,
    m_Qx_35 = Qx_mat$Qx.male_0.035
  )
  
  write.csv(Qx_mvh_df, "./output/Qx_mvh_df.csv", row.names = F)

  
# fin.    