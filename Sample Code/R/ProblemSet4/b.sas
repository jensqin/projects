libname lib './';

data medicare;
set lib.medicare;
totpay = LINE_SRVC_CNT * AVERAGE_MEDICARE_PAYMENT_AMT;

data lib.mdc_ttp;
set medicare;

run;