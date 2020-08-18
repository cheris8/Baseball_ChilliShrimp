## ������ ��ġ��
library(tidyverse)

batter_all = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_tidy.csv',header=T)
batter_KK_BB_HR_rate = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_KK_BB_HR_rate.csv',header=T)
batter_tidy_AVG_OBP_SLG_OPS =read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_tidy_AVG_OBP_SLG_OPS.csv',header=T)
batter_tidy_XR = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_tidy_XR.csv',header=T)
batter_tidy_���ݴ����_���缺���� = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_tidy_���ݴ����_���缺����.csv',header=T)
batter_Total_BABIP = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_Total_BABIP.csv',header=T)

head(batter_all)
head(batter_KK_BB_HR_rate)
head(batter_tidy_AVG_OBP_SLG_OPS)
head(batter_tidy_XR)
head(batter_tidy_���ݴ����_���缺����)
head(batter_Total_BABIP)

batter_KK_BB_HR_rate = batter_KK_BB_HR_rate %>% select(-X)
batter_tidy_AVG_OBP_SLG_OPS = batter_tidy_AVG_OBP_SLG_OPS %>% select(-X)
batter_tidy_XR = batter_tidy_XR %>% select(-X)
batter_tidy_���ݴ����_���缺���� = batter_tidy_���ݴ����_���缺���� %>% select(-X)
batter_Total_BABIP = batter_Total_BABIP %>% select(-X)

batter_all =batter_all %>%
  left_join(batter_KK_BB_HR_rate, by=names(batter_all)) %>%
  left_join(batter_tidy_AVG_OBP_SLG_OPS, by=names(batter_all)) %>%
  left_join(batter_tidy_XR, by=names(batter_all)) %>%
  left_join(batter_tidy_���ݴ����_���缺����, by=names(batter_all)) %>%
  left_join(batter_Total_BABIP, by=names(batter_all)) 

write.csv(batter_all,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_all.csv')