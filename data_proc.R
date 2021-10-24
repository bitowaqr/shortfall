
# SHORTFALL
# loading and processing raw ONS and HSE data
# 29.09.2021
# Paul Schneider

# clear enviroment
  rm(list=ls())

# load packages
  library(eq5d)

  
  
# HSE -------------  
# vars
  select_vars = c("wt_int","age16g5","sex", "mobil17", "selfca17", "usuala17", "pain17", "anxiet17")
  new_names = c("wt_int", "age", "sex", "mo", "sc", "ua", "pd", "ad")
  age5map = data.frame(
    age = 1:17,
    age5_start = c(16,18,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90),
    age5_str = c("16-17","18-19","20-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79","80-84","85-89","90+")
  )
  
# read hse data
  hse_17 = read.table("./data_raw//hse17i_eul_v1.tab",sep = "\t",header = T)
  hse_18 = read.table("./data_raw/hse_2018_eul_22052020.tab",sep = "\t",header = T)

# select relevant vars and rename
  names(hse_17) = tolower(names(hse_17))
  hse_17 = hse_17[ , select_vars]
  names(hse_17) = new_names
  
  names(hse_18) = tolower(names(hse_18))
  hse_18 = hse_18[ , select_vars]
  names(hse_18) = new_names

# combine 2017 + 2018
  hse_17$year = 2017
  hse_18$year = 2018
  hse = rbind(hse_17, hse_18)

# add alt age vars
  hse = merge(hse, age5map, "age")

# recode sex
  hse$sex[hse$sex==1] = "male"
  hse$sex[hse$sex==2] = "female"

# remove children < 16
  hse = hse[hse$age > -1,]

# recode missings as NA
  hse$mo[hse$mo < 1] = NA
  hse$sc[hse$sc < 1] = NA
  hse$ua[hse$ua < 1] = NA
  hse$pd[hse$pd < 1] = NA
  hse$ad[hse$ad < 1] = NA

# as factor  
  hse$age = as.factor(hse$age)
  hse$sex = as.factor(hse$sex)
  
  
# Save combined data set
  # write.csv(hse,"./hse.csv",row.names = F)
  # hse <- read.csv("./data/hse.csv" )
  
# compute eq-5d scores
  # 1. CW value set
  hse$eq_cw = eq5d(
    scores = cbind("MO"=hse$mo, "SC"= hse$sc,"UA"= hse$ua, "PD"=hse$pd, "AD"=hse$ad),
    version = "5L", 
    country = "UK", # "England"
    type = "CW", # "VT"
    ignore.invalid = T
    )

  
# fit simple lm (IGNORE MISSING DATA)
  fit_cw = lm(eq_cw ~ as.factor(age) * sex, hse, weights = wt_int)
  # fit_vt = lm(eq_vt ~ age * sex, hse, weights = wt_int)
  


# ONS -------------
  ons_male = read.csv(file = "./data/ons_lt_male_1719.csv")
  ons_male$sex = "male"
  ons_female = read.csv(file = "./data/ons_lt_female_1719.csv")
  ons_female$sex = "female"
  ons = rbind(ons_male,ons_female)
  
# QALE REFERENCE DF (WRONG) ------------
  
  # predict eq5d scores
  ludf = data.frame(
    age = as.factor(rep(1:17, 2)),
    sex = rep(c("male","female"), each = 17)
  )
  
  ludf$cw = predict(fit_cw, newdata = ludf)
  
  ludf = merge(ludf, age5map, "age")
  
  age_expand = list(
    0:17,
    18:19,
    20:24,
    25:29,
    30:34,
    35:39,
    40:44,
    45:49,
    50:54,
    55:59,
    60:64,
    65:69,
    70:74,
    75:79,
    80:84,
    85:89,
    90:100
  )
  
  
  ref_df = c()
  for(i in 1:nrow(ludf)){
    ref_i = ludf[i,]
    age_i = age_expand[[ref_i$age]]
    ref_i = ref_i[rep(1,length(age_i)),]
    ref_i$age = age_i
    ref_df = rbind(ref_df, ref_i)
  }
  
  ref_df = merge(ref_df, ons, by = c("age","sex"))
  ref_df = ref_df[order(ref_df$age),]
  
  # SAVE REFERENCE DF ------
  write.csv(ref_df,"./data/ref_df.csv", row.names = F)
  
  