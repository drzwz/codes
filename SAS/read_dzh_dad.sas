%macro ReadFromDzhData(DzhDadFile,DzhDataSet);
 data DzhDadHead;
 	infile "&DzhDadFile" recfm=f lrecl=16 firstobs=1  obs=1;
 	input Flag ib4. RandNum ib4. Num ib4. Zero ib4.;
	if Flag ne 872159628 then 
	do;
		put 'Invalid DAD File!';
		abort;
	end;
 run;
 data &DzhDataSet;
 	retain sym name;
 	infile "&DzhDadFile" recfm=f lrecl=16 firstobs=2 STOPOVER N=2;
	input #1 dt ib4. @;
	if dt=-1 then
	do;
		input sym $8. uk1 ib4.  / uk2 ib4. name $8. uk3 ib4.;
	end;
	else
	do;
		input  open float4. high float4. low float4. 
             / close float4. volume float4. openint float4. uk4 ib4.;
	end;
	format sym $10.  name $10. ;
	sym=trim(sym);
	if dt=-1 then delete;
	dt=dt/86400 + mdy(1,1,1970);
	roundoffunit=0.001;
	format dt yymmdd10.;
	*dt=dhms(dt,0,0,0);  /*dt value×ª»»Îªdatetime value*/
	open=round(open,roundoffunit);
    high=round(high,roundoffunit);
    low=round(low,roundoffunit);
    close=round(close,roundoffunit);
	volume=volume*100;
	keep sym dt open high low close volume openint;
 run;
%mend;

%ReadFromDzhData(d:\test.dad,t);