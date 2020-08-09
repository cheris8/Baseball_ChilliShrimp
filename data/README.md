# 데이터셋 설명

## Originial Dataset : 투수

|변수명|변수 설명|전처리 결과 (fitcher.csv 기준)|
|----|-------|--------|
|G_ID|게임키|삭제|
|GDAY_DS|일자|
|T_ID|팀코드|
|VS_T_ID|상대팀코드|
|HEADER_NO|더블헤더코드|
|TB_SC|초말|더미변수 2개 생성 후 삭제|
|P_ID|선수코드|
|START_CK|선발|	
|RELIEF_CK|구원|
|CG_CK|완투|
|QUIT_CK|종료|삭제|
|WLS|결과|더미변수 5개 생성 후 삭제|
|HOLD|홀드|
|INN2|이닝*3|
|BF|투구수|
|PA|타자|
|AB|타수|
|RBI|타점|
|RUN|득점|
|HIT|안타|
|H2|2루타|
|H3|3루타|
|HR|홈런|
|SB|도루|
|CS|도루실패|
|SH|희타|
|SF|희비(희생플라이)|
|BB|4구(볼넷)|
|IB|고4|
|HP|사구|
|KK|삼진|
|GD|병살타|
|WP|폭투
|BK|보크|
|ERR|실책
|R|실점|
|ER|자책점|
|P_WHIP_RT|득점권WHIP|삭제|
|P2_WHIP_RT|2점차이하WHIP|삭제|
|CB_WHIP_RT|345번타자WHIP|삭제|

## pitcher.csv

|변수명|변수 설명|
|----|-------|
|year|연| 
|month|월|
|T_ID|팀코드|
|P_ID|선수코드|
|START_CK|선발|	
|RELIEF_CK|구원|
|CG_CK|완투|
|QUIT_CK|종료|
|WLS|결과
|HOLD|홀드|
|INN2|이닝*3|
|BF|투구수|
|PA|타자|
|AB|타수|
|HOLD|홀드|
|INN2|이닝*3|
|BF|투구수|
|PA|타자|
|AB|타수|
|RBI|타점|
|RUN|득점|
|HIT|안타|
|H2|2루타|
|H3|3루타|
|HR|홈런|
|SB|도루|
|CS|도루실패|
|SH|희타|
|SF|희비(희생플라이)|
|BB|4구(볼넷)|
|IB|고4|
|HP|사구|
|KK|삼진|
|GD|병살타|
|WP|폭투
|BK|보크|
|ERR|실책
|R|실점|
|ER|자책점|
|VS_T_ID_XX|팀 XX와의 경기 횟수|
|TB_SC_B|초말=B인 경우 1을 갖는 더미변수|
|TB_SC_T|초말=T인 경우 1을 갖는 더미변수|
|WLS_X|결과=X인 경우 1을 갖는 더미변수 (5개)|

## Original Dataset - 타자

|변수명|변수 설명|전처리 결과 (batter.csv 기준)|
|----|-------|--------|
|G_ID|게임키|삭제|
|GDAY_DS|일자|year, month로 새롭게 변수 생성 후 삭제|
|T_ID|팀코드||
|VS_T_ID|상대팀코드|더미변수 10개 (VS_T_ID_XX) 생성 후 삭제|
|HEADER_NO|더블헤더코드|삭제|
|TB_SC|초말|더미변수 2개 (TB_SC_X) 생성 후 삭제|
|PA|타자|유지|
|AB|타수|유지|
|RBI|타점||
|RUN|득점||
|HIT|안타||
|H2|2루타||
|H3|3루타||
|HR|홈런||
|SB|도루||
|CS|도루실패||
|SH|희타||
|SF|희비(희생플라이)||
|BB|4구(볼넷)||
|IB|고4||
|HP|사구||
|KK|삼진||
|GD|병살타||
|ERR|실책||
|LOB|잔류||
|P_HRA_RT|득점권타율|삭제|
|P_AB_CN|득점권타수||
|P_HIT_CN|득점권안타||

## batter.csv

|변수명|변수 설명|
|----|-------|
|year|연| 
|month|월|
|T_ID|팀코드|
|P_ID|선수코드|
|PA|타자|
|AB|타수|
|RBI|타점|
|RUN|득점|
|HIT|안타|
|H2|2루타|
|H3|3루타|
|HR|홈런|
|SB|도루|
|CS|도루실패|
|SH|희타|
|SF|희비(희생플라이)|
|BB|4구(볼넷)|
|IB|고4|
|HP|사구|
|KK|삼진|
|GD|병살타|
|ERR|실책|
|LOB|잔류|
|P_AB_CN|득점권타수|
|P_HIT_CN|득점권안타|
|VS_T_ID_XX|팀 XX와의 경기 횟수|
|TB_SC_X|초말이 X인 경우 1을 갖는 더미변수|
|TB_SC_T|초말이 T인 경우 1을 갖는 더미변수|
|BAT_ORDER_NO_X|타순 X에 선 횟수|

## batter_tidy.csv

|변수명|변수 설명|
|----|-------|
|year|연| 
|month|월|
|T_ID|팀코드|
|P_ID|선수코드|
|PA|타자|
|AB|타수|
|RBI|타점|
|RUN|득점|
|HIT|안타|
|H2|2루타|
|H3|3루타|
|HR|홈런|
|SB|도루|
|CS|도루실패|
|SH|희타|
|SF|희비(희생플라이)|
|BB|4구(볼넷)|
|IB|고4|
|HP|사구|
|KK|삼진|
|GD|병살타|
|ERR|실책|
|LOB|잔류|
|P_AB_CN|득점권타수|
|P_HIT_CN|득점권안타|
|VS_T_ID_XX|팀 XX와의 경기 횟수|
|BAT_ORDER|가장 많이 선 타순|
|HOME|홈구장에서의 경기 횟수|
|AWAY|원정구장에서의 경기 횟수|
