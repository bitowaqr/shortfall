
# SHORTFALL
# loading and processing raw ONS and HSE data
# 10.09.2021
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
  
# compute eq-5d scores
  # 1. CW value set
  hse$eq_cw = eq5d(
    scores = cbind("MO"=hse$mo, "SC"= hse$sc,"UA"= hse$ua, "PD"=hse$pd, "AD"=hse$ad),
    version = "5L", 
    country = "UK", # "England"
    type = "CW", # "VT"
    ignore.invalid = T
    )

  # 2. VT value set
  # hse$eq_vt = eq5d(
  #   scores = cbind("MO"=hse$mo, "SC"= hse$sc,"UA"= hse$ua, "PD"=hse$pd, "AD"=hse$ad),
  #   version = "5L", 
  #   country = "England",
  #   type = "VT",
  #   ignore.invalid = T
  # )
  
# fit simple lm (IGNORE MISSING DATA)
  fit_cw = lm(eq_cw ~ age * sex, hse, weights = wt_int)
  # fit_vt = lm(eq_vt ~ age * sex, hse, weights = wt_int)
  
# Save combined data set
  # write.csv(hse,"./hse.csv",row.names = F)


# ONS -------------
  ons_male = read.csv(file = "./data_raw/ons_lt_male_1719.csv")
  ons_male$sex = "male"
  ons_female = read.csv(file = "./data_raw/ons_lt_female_1719.csv")
  ons_female$sex = "female"
  ons = rbind(ons_male,ons_female)
  ons = ons[,c("age","sex","qx")]
  ons$surv = 1-ons$qx
  # write.csv(ons, "./ons.csv", row.names = F)

  
  
# QALE REFERENCE DF (WRONG) ------------
  
  # predict eq5d scores
  ludf = data.frame(
    age = as.factor(rep(1:17, 2)),
    sex = rep(c("male","female"), each = 17)
  )
  
  ludf$cw = predict(fit_cw, newdata = ludf)
  # ludf$vt = predict(fit_vt, newdata = ludf)
  
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
  
  ref_df = ref_df[order(ref_df$age),]
  
  ref_df$S_cum = 1
  ref_df$QALE_cum = 0
  ref_df$S = ref_df$S_cum = ref_df$QALE = c()
  
  for(s in c("male","female")){
    
    S_cum = 1
    QALE_cum = 0
    S  = QALE =  c()
    
    for(i in 0:100){
      
      s_i = ons$surv[ons$sex == s & ons$age == i]
      
      ref_df$S[ref_df$age == i & ref_df$sex == s] = s_i
      ref_df$S_cum[ref_df$age == i & ref_df$sex == s] = S_cum[length(S_cum)]*s_i
      
      S = c(S, s_i)
      S_cum = c(S_cum, S_cum[length(S_cum)]*s_i)
      
      s_mid_i = s_i + ( (1-s_i)/2 )
      
      qale_i = s_mid_i * ref_df$cw[ref_df$age == i & ref_df$sex == s]
      
      ref_df$QALE[ref_df$age == i & ref_df$sex == s] = qale_i
      ref_df$QALE_cum[ref_df$age == i & ref_df$sex == s] = QALE_cum[length(QALE_cum)] + qale_i 
      
      QALE = c(QALE, qale_i)
      QALE_cum = c(QALE_cum, QALE_cum[length(QALE_cum)]+qale_i)
      
    }
  
  }

  rownames(ref_df) = NULL  
  
  # SAVE REFERENCE DF ------
  write.csv(ref_df,"ref_df.csv", row.names = F)
  
  
  
  
# # Life table function from JAMES -----------
  # life.table <- function(dfMort,dfHRQL,a,prob){
  #   
  #   mx <- if(prob==0){dfMort$mx}else{rbeta(nrow(dfMort),
  #                                          dfMort$mx_a,dfMort$mx_b)}# draw mx
  #   hrqlx <- dfHRQL$eq5d
  #   ########------- CHECK
  #   # hrqlx <- append(hrqlx,hrqlx[1],1)   # # chaned  --- CHECK WITH JAMES
  #   # x <- c(0,1,seq(5,85,5))             # # changed -- CHECK WITH JAMES
  #   ########------- CHECK
  #   x <- c(0,16,25,35,45,55,65,75)
  #   
  #   int <- length(x)      # number of age intervals   
  #   n <- c(diff(x),85-x[int])          # width of the intervals
  #   ax <- rep(a,int)
  #   qx <- (n*mx)/(1 + (n-ax)*mx) # ?????
  #   qx[int] <- 1.0 # ?
  #   px <- 1-qx 
  #   lx <- c(1,cumprod(1-qx)) ;  # ??
  #   lx <- lx[1:length(mx)] # ??
  #   dx <- lx * qx ; # ????
  #   Lx <- n*(lx*px) + n*ax*(lx*qx); # # mean survival years per interval  ?
  #   Lx[int] <- lx[int]/mx[int]
  #   Tx <- rev(cumsum(rev(Lx)))   # # life expectancy per interval ?
  #   ex <- ifelse( lx[1:int] > 0, Tx/lx[1:int] , NA);
  #   yx <- Lx*hrqlx  # mean quality adj. years per interval
  #   TQx <- rev(cumsum(rev(yx)))  # quality adj. life expectancy per interval
  #   Qx <- ifelse( lx[1:int] > 0, TQx/lx[1:int] , NA); # ??? now I am lost.... ??? why TQx/lx?
  #   lt <- data.frame(x=x,ax=ax,mx=mx,qx=qx,lx=lx,dx=dx,Lx=Lx,Tx=Tx,ex=ex,hrqlx=hrqlx,yx=yx,TQx=TQx,Qx=Qx)
  #   return(lt)
  # }
  # 
  # # QALE wrapper function
  # qale_wrapper = function(eq5d, mort){
  #   
  #   # # wrapper to get qale from raw eq5d + mort data
  #   # # eq5d,   # data.frame with age, imd, sex, eq5d
  #   # # mort    # data.frame with age, imd, sex, pop, deaths
  #   
  #   require(tidyverse)
  #   
  #   # Calculate mortality rate, variance & beta dist parameters
  #   mort <- mort %>% mutate(mx=deaths/pop,mx_var=((mx^2)*(1-mx))/deaths,
  #                           mx_a=mx*(mx*(1-mx)/(mx_var^2)-1),mx_b=mx_a*((1-mx)/mx),
  #                           mx_draw=rbeta(1,mx_a,mx_b))
  #   
  #   # Run the function for each subgroup
  #   sex.i <- unique(mort$sex)
  #   imd.i <- unique(mort$imd)
  #   
  #   qale <- data.frame(age=numeric(),qale=numeric(),ex=numeric(),sex=character(),imd=numeric())
  #   for(i in 1:length(sex.i)){
  #     for(j in 1:length(imd.i)) {
  #       t_eq5d <- filter(eq5d,sex==sex.i[i],imd==imd.i[j])   # CAVE: 'filer()' scoping!!!
  #       t_mort <- filter(mort,sex==sex.i[i],imd==imd.i[j])   # same names lead to error!
  #       t_lt <- life.table(dfMort = t_mort,dfHRQL = t_eq5d,a =  0.5,prob =0)
  #       t_res <- data.frame(age=t_lt$x,qale=t_lt$Qx,ex = t_lt$ex)
  #       t_res$sex <- sex.i[i]; t_res$imd <- imd.i[j]
  #       qale <- rbind(qale,t_res)
  #     }
  #   }
  #   
  #   return(qale)
  # }
  # 