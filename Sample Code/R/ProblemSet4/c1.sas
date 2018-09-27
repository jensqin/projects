libname lib './';

proc sql;

create table sumcost as
select sum(totpay) as s, sum(LINE_SRVC_CNT) as n
from lib.mdc_ttp
group by HCPCS_CODE;

create table avgcost as
select s/n as avg, n
from sumcost
where n>100000
order by avg desc;

quit;

data lib.avgcost;
set avgcost;

run;