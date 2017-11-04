options nosource nonumber nodate nonotes nomprint error=10;
/* ============================BeginningOfHeader===============================
/ ����: QL2FinData
/ ����: ��Ǯ������������(*.DAY)/ȨϢ����/�ɱ��䶯(*.wgt)����FinData�߼����е�cnhq/cncq/cngb�����ݼ���
/ �汾: 2.0
/ ����: 2006-8-8
/ ��ע: 
/ ����ģ��: Base SAS
/ ���Ի���: SAS 9.1.3
/ �÷�:
/     ��������Ǯ���콢/���.
/ �޸�:
/      
/------------------------------------------------------------------------------- 
/ ����:�����밴��״("AS IS")�ṩ��û���κ���ȷ�������ĵ������û��Լ���е�ʹ�ñ������ 
/ ���ա������û�ʹ�û��Ʊ������Ȩ�ޣ����Խ��������κ���;��ֻҪ�����и����а�
/ ������˵������������ 
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
	%if %sysfunc(exist(&FinDataDataSet))=0 %then  %do; /*Ŀ�����ݼ�������*/
		proc sql;
			create table &FinDataDataSet (dm char(8) format=$8. label='����',
			rq num   format=YYMMDD10. informat=YYMMDD10.     label='����',kp num  label='����',zg num  label='���',
			zd num  label='���',sp num  label='����',sl num  label='�ɽ�����',
			je num  label='�ɽ����');
		quit;
	%end; 
%end;
%else %if &DataType = cq %then %do;
	%if %sysfunc(exist(&FinDataDataSet))=0 %then  %do; /*Ŀ�����ݼ�������*/
	proc sql;
		create table &FinDataDataSet (dm char(8) format=$8. label='����',
		rq num   format=YYMMDD10. informat=YYMMDD10. label='����',fh num  label='�ֺ�',sgbl num  label='�͹ɱ���',pgbl num  label='��ɱ���',
		pgjg num  label='��ɼ۸�');
	quit;
	%end;
%end;
%else %if &DataType = gb %then %do;
	%if %sysfunc(exist(&FinDataDataSet))=0 %then  %do; /*Ŀ�����ݼ�������*/
	proc sql;
		create table &FinDataDataSet (dm char(8) format=$8. label='����',
		rq num  format=YYMMDD10. informat=YYMMDD10.  label='����',zgb num  label='�ܹɱ�',
		ltg num  label='��ͨA��',hg num  label='H��',bg num  label='B��');
	quit;
	%end;
%end;

    /*��DataDirĿ¼�µ��ļ����������ݼ�filelist*/
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
	/*��ȡ֤ȯ�����������������,׷������ʱ���ø�����ֻ׷�Ӹ��µ�����*/
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
		
/*�����ݼ�filelist��ÿ���ļ�����Ӧ�ļ������ݵ�����ʱ���ݼ�WindDayTmp,��׷�ӵ�ָ�����ݼ���*/
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
  /*����������*/
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
		sl=round(sl*100,1);/*�ɽ�����λΪ��*/
		je=round(je*1000,0.01);/*�ɽ��λΪԪ*/
		rq=mdy(int(mod(rq,10000)/100),mod(rq,100),int((rq/10000)));/* yyyymmdd to sas date*/
		attrib rq format=yymmdd10. informat=yymmdd10. ;
		if rq <= &maxrq then delete; /*ֻ׷��������*/
	run;
  %end;
  /*��ȨϢ����*/
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
	data qlTmp;  /*��������rq<=&maxrq�ֿ�����Ϊ���������¼�����*/
		set qlTmp;
		if (sgbl eq 0 and pgbl eq 0 and pgjg eq 0 and fh eq 0) then delete;
	run;
  %end;
  /*���ɱ��䶯����*/
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
			bg=ltg;ltg=0;/* ����Ǽ���A������B��,B�ɴ���ֻ����B����ͨ������*/
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


*��������;
%QL2FinData(hq,D:\qlqj\QLDATA\history\shase\day,FinData);     /*  ��������,*.day    */
%QL2FinData(hq,D:\qlqj\QLDATA\history\sznse\day,FinData);     /*  ��������,*.day    */
%QL2FinData(cq,D:\qlqj\QLDATA\history\shase\weight,FinData);  /*  ����ȨϢ,*.wgt    */
%QL2FinData(cq,D:\qlqj\QLDATA\history\sznse\weight,FinData);  /*  ����ȨϢ,*.wgt    */
%QL2FinData(gb,D:\qlqj\QLDATA\history\shase\weight,FinData);  /*  ���йɱ��䶯,*.wgt   */
%QL2FinData(gb,D:\qlqj\QLDATA\history\sznse\weight,FinData);  /*  ���йɱ��䶯,*.wgt   */
