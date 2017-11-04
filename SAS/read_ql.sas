options nosource nonumber nodate nonotes nomprint error=10;
/* ============================BeginningOfHeader===============================
/ 名称: QL2FinData
/ 功能: 将钱龙行情日数据(*.DAY)/权息数据/股本变动(*.wgt)导入FinData逻辑库中的cnhq/cncq/cngb等数据集。
/ 版本: 2.0
/ 日期: 2006-8-8
/ 备注: 
/ 所需模块: Base SAS
/ 测试环境: SAS 9.1.3
/ 用法:
/     仅适用于钱龙旗舰/金典.
/ 修改:
/      
/------------------------------------------------------------------------------- 
/ 声明:本代码按现状("AS IS")提供，没有任何明确或隐含的担保，用户自己须承担使用本代码的 
/ 风险。授予用户使用或复制本代码的权限，可以将其用于任何用途，只要在所有副本中包
/ 含以上说明及本声明。 
/===============================EndingOFHeader=================================*/
%macro QL2FinData(DataType,DataDir,FinDataLib);
%let DataType=%lowcase(&DataType);
%if %sysfunc(substr(&DataDir,%length(&DataDir),1)) ^= \ %then %let DataDir =&DataDir.\;
%let DataDir=%upcase(&DataDir);
%if %index(&DataDir,\SHASE)>0 %then %do;
	%let market=SH;%let FinDataDataSet=&FinDataLib..cn&DataType;
%end;
%else %if %index(&DataDir,\SZNSE)>0 %then  %do;
	%let market=SZ;%let FinDataDataSet=&FinDataLib..cn&DataType; 
%end;
%else %if %index(&DataDir,\HKSE)>0 %then  %do;
	%let market=HK;%let FinDataDataSet=&FinDataLib..hk&DataType; 
%end;

%if &DataType = hq %then %do;
	%if %sysfunc(exist(&FinDataDataSet))=0 %then  %do; /*目标数据集不存在*/
		proc sql;
			create table &FinDataDataSet (dm char(8) format=$8. label='代码',
			rq num   format=YYMMDD10. informat=YYMMDD10.     label='日期',kp num  label='开盘',zg num  label='最高',
			zd num  label='最低',sp num  label='收盘',sl num  label='成交数量',
			je num  label='成交金额');
		quit;
	%end; 
%end;
%else %if &DataType = cq %then %do;
	%if %sysfunc(exist(&FinDataDataSet))=0 %then  %do; /*目标数据集不存在*/
	proc sql;
		create table &FinDataDataSet (dm char(8) format=$8. label='代码',
		rq num   format=YYMMDD10. informat=YYMMDD10. label='日期',fh num  label='分红',sgbl num  label='送股比例',pgbl num  label='配股比例',
		pgjg num  label='配股价格');
	quit;
	%end;
%end;
%else %if &DataType = gb %then %do;
	%if %sysfunc(exist(&FinDataDataSet))=0 %then  %do; /*目标数据集不存在*/
	proc sql;
		create table &FinDataDataSet (dm char(8) format=$8. label='代码',
		rq num  format=YYMMDD10. informat=YYMMDD10.  label='日期',zgb num  label='总股本',
		ltg num  label='流通A股',hg num  label='H股',bg num  label='B股');
	quit;
	%end;
%end;

    /*将DataDir目录下的文件名导入数据集filelist*/
	filename files pipe "dir ""&DataDir""  /b ";
	data filelist;
		format file_name $30. dm $8. targetdataset $30. tds $40.  maxrq yymmdd10.;
		infile files;
		input @1 file_name;
		file_name=upcase(trim(file_name));
		if length(file_name)<8 then delete;
		dm="&market"||substr(file_name,1,index(file_name,'.')-1);
		targetdataset="&FinDataDataSet";
		tds="&FinDataDataSet";
		maxrq=.;
	run;
	/*获取证券代码的最新数据日期,追加数据时利用该日期只追加更新的数据*/
	proc sql noprint;
		create table tmpTargetDS as 
		select distinct ('select dm,max(rq) format=yymmdd10. as maxrq from '|| tds || ' group by dm') as sql,tds
			from filelist;
	quit;
	data tmpTargetDS;
		set tmpTargetDS;
		if exist(tds)=1;
	run;
	proc sql noprint;
		select sql into :sqlexe separated by ' union  '  from tmpTargetDS;
		%if &SQLOBS >0 %then %do;
			create table tmpMaxDate as &sqlexe ;
			update filelist as f set maxrq = (select maxrq from tmpMaxDate as t where f.dm=t.dm);
			drop table tmpMaxDate;
		%end;
		drop table tmpTargetDS;
	quit;
		
/*将数据集filelist中每个文件名对应文件的数据导入临时数据集WindDayTmp,并追加到指定数据集中*/
%let dsid=%sysfunc(open(filelist));
%if (&dsid=0) %then %do;
	%put MSG=%sysfunc(sysmsg());
	%abort abend;
%end;
%let i=0;
%do %while (%sysfunc(fetch(&dsid))=0);
  %let i=%eval(&i+1);
  %let DataFile =%sysfunc(trim(  %sysfunc(getvarC(&dsid,%sysfunc(varnum(&dsid,file_name))))  ));
  %let dm =%sysfunc(trim(  %sysfunc(getvarC(&dsid,%sysfunc(varnum(&dsid,dm))))  ));
  %let targetdataset =%sysfunc(trim(  %sysfunc(getvarC(&dsid,%sysfunc(varnum(&dsid,targetdataset))))  ));
  %let maxrq =%sysfunc(trim(  %sysfunc(getvarN(&dsid,%sysfunc(varnum(&dsid,maxrq))))  ));
  /*读行情数据*/
  %if &dataType=hq %then %do;
	data qlTmp(drop=roundoffunit);
		infile "&DataDir.&DataFile" recfm=f lrecl=40 STOPOVER;
		format dm $8.;
		dm="&dm";
		input rq ib4. kp ib4. zg ib4. zd ib4. sp ib4. je ib4. sl ib4.;
		if (rq eq . or 19000000>rq or rq>20500000) then delete;
		if dm in:('SH50','SH51','SZ184','SZ15','SZ16','SH58','SZ03') and rq>mdy(3,3,2003) then roundoffunit=0.001;
			else roundoffunit=0.01;
		kp=round(kp/1000,roundoffunit);
		zg=round(zg/1000,roundoffunit);
		zd=round(zd/1000,roundoffunit);
		sp=round(sp/1000,roundoffunit);
		sl=round(sl*100,1);/*成交量单位为股*/
		je=round(je*1000,0.01);/*成交额单位为元*/
		rq=mdy(int(mod(rq,10000)/100),mod(rq,100),int((rq/10000)));/* yyyymmdd to sas date*/
		attrib rq format=yymmdd10. informat=yymmdd10. ;
		if rq <= &maxrq then delete; /*只追加新数据*/
	run;
  %end;
  /*读权息数据*/
  %else %if &DataType=cq %then %do;
	data qlTmp;
		format dm $8. rq yymmdd10. fh sgbl pgbl pgjg;
		infile "&DataDir.&DataFile" recfm=f lrecl=36 STOPOVER;
		input rq0 ib4.  sgbl ib4. pgbl ib4.  pgjg ib4. fh ib4.;/*  zzs ib4.  zgb ib4.  ltg ib4. bz $4.;*/
		if (rq0 = .) then delete;
		dm="&dm";
		dt=put(rq0,binary32.0);
		y=input(dt,binary12.);
		m=input(substr(dt,13,4),binary4.);
		d=input(substr(dt,17,5),binary5.);
		rq=mdy(m,d,y);
		sgbl=sgbl/100000;
		pgbl=pgbl/100000;
		pgjg=pgjg/1000;
		fh=fh/10000;
		if rq<=&maxrq then delete;
		keep dm rq sgbl pgbl pgjg fh;
	run;
	data qlTmp;  /*本条件与rq<=&maxrq分开是因为遇到个别记录会出错*/
		set qlTmp;
		if (sgbl eq 0 and pgbl eq 0 and pgjg eq 0 and fh eq 0) then delete;
	run;
  %end;
  /*读股本变动数据*/
  %else %if &DataType=gb %then %do;
	data qlTmp;
		format dm $8. rq yymmdd10.;
		infile "&DataDir.&DataFile" recfm=f lrecl=36 STOPOVER;
		input rq0 ib4.  sgbl ib4. pgbl ib4.  pgjg ib4. fh ib4. zzs ib4.  zgb ib4.  ltg ib4. bz $4.;
		if (rq0 = .) then delete;
		dm="&dm";
		dt=put(rq0,binary32.0);
		y=input(dt,binary12.);
		m=input(substr(dt,13,4),binary4.);
		d=input(substr(dt,17,5),binary5.);
		rq=mdy(m,d,y);
		zgb=zgb*10000;
		ltg=ltg*10000;
		hg=0;bg=0;
		if dm in:('SH900','SZ200') then do;
			bg=ltg;ltg=0;/* 如果是既有A股又有B股,B股代码只保留B股流通股数量*/
		end;
		if (zgb eq 0 and ltg eq 0) or rq<=&maxrq then delete;
		keep dm rq zgb ltg hg bg;
	run;
  %end;
    proc append base=&FinDataDataSet data=qlTmp;
	run; 
    %put  &i. . %sysfunc(putn(%sysfunc(time()),time.)), &DataFile.   => &FinDataDataSet &dm , %sysfunc(putn(&maxrq,yymmdd10.));
%end;
%let rc=%sysfunc(close(&dsid));
proc sql noprint;
	drop table filelist;drop table qlTmp;
quit;
%mend;


*调用例子;
%QL2FinData(hq,D:\qlqj\QLDATA\history\shase\day,FinData);     /*  沪市行情,*.day    */
%QL2FinData(hq,D:\qlqj\QLDATA\history\sznse\day,FinData);     /*  深市行情,*.day    */
%QL2FinData(cq,D:\qlqj\QLDATA\history\shase\weight,FinData);  /*  沪市权息,*.wgt    */
%QL2FinData(cq,D:\qlqj\QLDATA\history\sznse\weight,FinData);  /*  深市权息,*.wgt    */
%QL2FinData(gb,D:\qlqj\QLDATA\history\shase\weight,FinData);  /*  沪市股本变动,*.wgt   */
%QL2FinData(gb,D:\qlqj\QLDATA\history\sznse\weight,FinData);  /*  深市股本变动,*.wgt   */
