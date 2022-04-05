
# SHORTFALL
# add 3L-based utility scores to ref_df
# 05.04.2022
# Paul Schneider

# clear enviroment
rm(list=ls())

# load packages
library(eq5d)
library(data.table)

# HSE -------------  
# vars
select_vars12 = c("wt_int","age","sex", "mobility", "selfcare", "usualact", "pain", "anxiety")
select_vars14 = c("wt_int","age90","sex", "mobility", "selfcare", "usualact", "pain", "anxiety")
new_names = c("wt_int", "age","sex", "mo", "sc", "ua", "pd", "ad")

age5map = data.frame(
  age = 16:90,
  age5_start = c(
    rep(c(16,18), each = 2),
    rep(
      c(20,25,30,35,40,45,50,55,60,65,70,75,80,85),
      each = 5
    ),
    90
  ),
  age5_str = c(
    rep(c("16-17","18-19"), each = 2),
    rep(
      c("20-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79","80-84","85-89"),
      each = 5
      ),
    "90+"
    )
)

# read hse data
hse_12 = read.table("./data/hse2012ai.tab",sep = "\t",header = T)
hse_14 = read.table("./data/hse2014ai.tab",sep = "\t",header = T)

# select relevant vars and rename
names(hse_12) = tolower(names(hse_12))
hse_12 = hse_12[ , select_vars12]
names(hse_12) = new_names

names(hse_14) = tolower(names(hse_14))
hse_14 = hse_14[ , select_vars14]
names(hse_14) = new_names

# recode >90 as 90 for hse 2012
hse_12$age[hse_12$age > 90] = 90

# combine 2012 + 2014
hse_12$year = 2012
hse_14$year = 2014
hse = rbind(hse_12, hse_14)

# add alt age vars
hse = merge(hse, age5map, "age") # removes age < 16 

# recode sex
hse$sex[hse$sex==1] = "male"
hse$sex[hse$sex==2] = "female"

# recode missings as NA
hse$mo[hse$mo < 1] = NA
hse$sc[hse$sc < 1] = NA
hse$ua[hse$ua < 1] = NA
hse$pd[hse$pd < 1] = NA
hse$ad[hse$ad < 1] = NA

# as factor  
# hse$age = as.factor(hse$age)
hse$sex = as.factor(hse$sex)

# compute eq-5d scores
# 1. CW value set
hse$eq_3l = eq5d(
  scores = cbind("MO"=hse$mo, "SC"= hse$sc,"UA"= hse$ua, "PD"=hse$pd, "AD"=hse$ad),
  version = "3L", 
  country = "UK", # "England"
  type = "TTO", 
  ignore.invalid = T
)

# fit lm to estimate weighted means 
fit_3l = lm(eq_3l ~ age5_str * sex, hse, weights = wt_int)

# APPEND REFERENCE DF ------------

# predict eq5d scores
ludf = data.frame(
  age5_str = rep(unique(age5map$age5_str),2),
  sex = rep(c("male","female"), each = 17)
)

ludf$tto = predict(fit_3l, newdata = ludf)

original_ref_df = read.csv("./data/ref_df.csv")
ref_df_appended = merge(original_ref_df, ludf, by = c("age5_str","sex")) 

# SAVE REFERENCE DF ------
write.csv(ref_df_appended,"./data/ref_df_appended.csv", row.names = F)
