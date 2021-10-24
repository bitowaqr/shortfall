# QALE estimation

rm(list=ls())

# load ref df with life table (ONS) and HRQoL estimates (HSE) by age and sex 
ref_df = read.csv("./data/ref_df.csv")

# load function to compute life and quality-adjusted life expectancies
source("./compQale.R")


# van Hout et al. -------
  # HRQoL by age and sex
  hrqol_df = ref_df[,c("sex","age5_str","cw")]
  hrqol_df = hrqol_df[!duplicated(hrqol_df),]
  hrqol_df$cw = formatC(hrqol_df$cw, digits = 3, format = "f")
  hrqol_df = reshape(hrqol_df, direction = "wide", timevar = "sex", idvar = "age5_str")
  names(hrqol_df) = c("age", "female", "male")
  write.csv(hrqol_df, "./output/hrqol_df.csv")

  
  
# QALEs
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
  
  write.csv(qale_cw, "./output/Qx_cw_df.csv")
  
    