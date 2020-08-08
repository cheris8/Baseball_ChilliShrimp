library(tidyverse)

batter = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/batter.csv")

batter = batter %>% group_by(year, month, T_ID, P_ID) %>% mutate(max_bat = max(BAT_ORDER_NO_1, BAT_ORDER_NO_2, BAT_ORDER_NO_3, BAT_ORDER_NO_4, BAT_ORDER_NO_5, BAT_ORDER_NO_6, BAT_ORDER_NO_7, BAT_ORDER_NO_8, BAT_ORDER_NO_9)) %>% ungroup() %>%
  mutate(BAT_ORDER = case_when(
    max_bat == BAT_ORDER_NO_1 ~ 1,
    max_bat == BAT_ORDER_NO_2 ~ 2,
    max_bat == BAT_ORDER_NO_3 ~ 3,
    max_bat == BAT_ORDER_NO_4 ~ 4,
    max_bat == BAT_ORDER_NO_5 ~ 5,
    max_bat == BAT_ORDER_NO_6 ~ 6,
    max_bat == BAT_ORDER_NO_7 ~ 7,
    max_bat == BAT_ORDER_NO_8 ~ 8,
    max_bat == BAT_ORDER_NO_9 ~ 9
  ), HOME = TB_SC_B, AWAY = TB_SC_T) %>% select(-c(BAT_ORDER_NO_1, BAT_ORDER_NO_2, BAT_ORDER_NO_3, BAT_ORDER_NO_4, BAT_ORDER_NO_5, BAT_ORDER_NO_6, BAT_ORDER_NO_7, BAT_ORDER_NO_8, BAT_ORDER_NO_9, TB_SC_B, TB_SC_T, max_bat)) 

write.csv(batter, "batter_tidy.csv", row.names = F)
