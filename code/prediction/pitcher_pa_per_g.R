# pitcher game merged

pitcher = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/pitcher_feature_selection.csv")

pitcher = pitcher %>% select(-X1)

games = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/games.csv")

pitcher_pa_per_g = pitcher %>% left_join(games, by = c('year', 'month', 'T_ID')) %>% select(year, month, P_ID, PA, VISIT, HOME) %>% mutate(PA_PER_G = PA/(VISIT+HOME)) %>% select(year, month, P_ID, PA_PER_G)

write.csv(pitcher_pa_per_g, "pitcher_pa_per_g.csv", row.names = F)
