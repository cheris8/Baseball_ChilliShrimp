library(tidyverse)

pitcher_all = read.csv('C:/Users/seungjun/Desktop/baseball/data/pitcher.csv',header=T)
head(pitcher_all)

## ERA
ERA = pitcher_all %>%
  mutate(ERA = ER/PA)

ERA$ERA[is.na(ERA$ERA)] = 0
ERA$ERA[is.infinite(ERA$ERA)] = 0


## WHIP
WHIP = ERA %>%
  mutate(WHIP = (HIT + BB)/PA )

WHIP$WHIP[is.na(WHIP$WHIP)] = 0
WHIP$WHIP[is.infinite(WHIP$WHIP)] = 0

## FIP  NA값 어떻게 해결해야할까,  C는 상수라고 해서 그냥 제외 -> 압도적으로 줄었다.
# FIP = (13*HR + 3*(BB-IBB+HBP) - 2*K) / IP + C
# C = (9*lgER + 2*lgK - 13*lgHR - 3*(lgBB-lgIBB+lgHBP)) / lgIP

FIP = C %>%
  mutate(FIP=(13*HR + 3*(BB-IB+HP) - 2*KK) / PA )
FIP = FIP %>%
  select(-C)

head(FIP)
length(FIP$FIP)
sum(is.na(FIP$FIP))

FIP$FIP[is.na(FIP$FIP)] = 0
sum(is.na(FIP$FIP))


## 도루시도율 도루 성공율

SB_try = FIP %>%
  mutate(SB_try = (SB + CS) / PA, SB_succ = SB/(SB + CS) )


sum(is.na(SB_try$SB_try))
sum(is.infinite(SB_try$SB_try))
sum(is.na(SB_try$SB_succ))
sum(is.infinite(SB_try$SB_succ))

SB_try$SB_try[is.na(SB_try$SB_try)] = 0
SB_try$SB_succ[is.na(SB_try$SB_succ)] = 0

## ERC 고의사구를 인정할 경우

ERC = SB_try %>%
  mutate(PTB= 0.89*(1.255*(HIT-HR)+4*HR)+0.56*(BB + HP -IB) )  %>%
  mutate(ERC = 9*((HIT + BB + HP)*PTB)/(PA*AB)-0.56) %>%
  select(-PTB)

sum(is.na(ERC$ERC))
sum(is.infinite((ERC$ERC)))

ERC$ERC[is.na(ERC$ERC)] = 0
ERC$ERC[is.infinite(ERC$ERC)] = 0

write.csv(ERC,'C:/Users/seungjun/Desktop/baseball/data/pitcher_ERA_FIP_WHIP_SB_try_SB_succ.csv')



