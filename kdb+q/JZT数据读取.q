\d .zz
//=============================jzt���ݶ�д=============================
/jzt����ת���� .zz.jztsym2sym[`ZJIF01]  .zz.jztsym2sym[`SZ000001]   .zz.sym2jztsym[`IF01.CFE]  .zz.sym2jztsym[`000001.SZ]
jztsym2sym:{[x]mktmap:("ZJ";"SQ";"ZQ";"DQ";"WH")!("CFE";"SHF";"CZC";"DCE";"FX"); mkt:2#string[x];mkt2:mktmap mkt;:$[""~mkt2;`$(2_string[x]),".",mkt;`$(2_string[x]),".",mkt2];};  
sym2jztsym:{[x]mktmap:("CFE";"SHF";"CZC";"DCE";"FX")!("ZJ";"SQ";"ZQ";"DQ";"WH"); s:upper string x; mktlen:(reverse s)?".";mkt:(neg mktlen)#s;if[mkt in key mktmap;mkt:mktmap[mkt]];  :`$mkt,(neg mktlen+1)_s;};  
/��ȡJZT DAD���� , �÷�  .zz.getjztbar[  `$":d:/test.DAD"]   getjztbar[  `$":d:/FE/data/jzt5s.DAD"]; 
getjztbar:{[x]if[not (-11h=type key x);:()]; jztbar:();  filelen:hcount x;  pos:53j;
  flag:first first(enlist "x";enlist(1)) 1:(x;pos;1); pos+:1;  mysize:$[flag=0x04;86400i;flag=0x9D;300i;flag=0x9C;60i;flag=0xA1;5i;flag=0x9E;999999i;999999i];
  while[filelen - pos;  sec:`sym`num!("si";(12;4)) 1:(x;pos;16); mysym:first sec[`sym];recnum:first sec[`num];
  pos+:16; jztbar,: update sym:mysym,dt:`datetime$dt-36526 from flip `dt`open`high`low`close`openint`volume`amount`ups`dns`deals`openvolume`openamount!("feeeeeeehhhee";(8,(7#4),(3#2),(2#4)))1:(x;pos;50*recnum) ;
  pos+:50*recnum];
  $[mysize=86400i; :select date:`date$dt,time:00:00:00.000,sym:.zz.jztsym2sym each sym,size:mysize,open,high,low,close,volume:?[sym like "S[HZ]*";`real$volume*100;volume],openint:?[sym like "S[HZ]*";amount;openint] from jztbar ;
    mysize in (300i;60i;5i);:select date:`date$dt,time:(-1000i*mysize)+`time$dt,sym:.zz.jztsym2sym each sym,size:mysize,open,high,low,close,volume:?[sym like "S[HZ]*";`real$volume*100;volume],openint:?[sym like "S[HZ]*";amount;openint] from jztbar;
    :select date:`date$dt,time:`time$dt,sym:.zz.jztsym2sym each sym,size:mysize,open,high,low,close,volume:?[sym like "S[HZ]*";`real$volume*100;volume],openint:?[sym like "S[HZ]*";amount;openint] from jztbar];
   };
/����JZT DAD�ļ�: 2017.10�޸�Ϊֻ֧��wind��ʽ֤ȯ���� symΪwind��ʽ;size-����ֻ��Ϊ5/60/300/86400/999999;srctbl���뺬��date/time/sym/size/open/high/low/close/volume/openint�ֶ���time��bar����ʼʱ�䲻�ǽ���ʱ�䣺 setjztbar[60i;`:d:/test.dad;bar]
setjztbar:{[size;dadfile;srctbl]  bt:{reverse  0x0 vs x}; mysize:`int$size; if[not mysize in (5i;60i;300i;86400i;999999i);:`size_wrong];
   dadfile 1: 0x64000000;  h:hopen dadfile; h 49#"���������߽���ϵͳ 2013 (V2.98)",49#"\000"; //�ļ�ͷ.   ���ļ��Ѵ��ڣ��򸲸�
   h $[mysize=5i;0xA1;mysize=60i;0x9C;mysize=300i;0x9D;mysize=86400;0x04;0x9E];  // ��������0xA1/0x9C/0x9D/0x04/0x9E
   symlist:exec distinct sym from srctbl where size=mysize;   sc:count symlist; isc:0;
   do[sc;s:symlist[isc];s_num:`int$count mybar:`date`time xasc update dt:`float$((`datetime$date+time+?[mysize<86400;mysize*1000i;0i]) - 1899.12.30T00:00:00.000),ups:`short$count i,dns:`short$count i,deals:`short$count i,amount:openint,openint,openvolume:0e,openamount:0e from select from srctbl where sym=s,size=mysize;
   h (`byte$12#((1+string[s] ? ".") _ string[s]),((string[s] ? ".") # string[s]),12#"\000"),(bt s_num),raze raze exec   (( bt each dt),' (bt each open),' (bt each high),' (bt each  low) ,' (bt each close),' (bt each openint),' (bt each volume),' (bt each amount),' (bt each ups),' (bt each dns),' (bt each deals),'(bt each openvolume),'(bt each openamount)  ) from mybar;
   isc+:1];   hclose h;};
/����jzt������ļ�,srctbl��sym/name�ֶΣ�����name����nameȡsym:     setjztsyms[`FE;`:d:/fe.snt;bar]
setjztsyms:{[mkt;sntfile;srctbl]
    $[`name in cols srctbl;
    sntfile 1: "Stock Name Table\n",(string mkt),"\n",raze exec ((string sym),'("\011"),'(string name),'"\n")  from select distinct sym,name from srctbl; 
    sntfile 1: "Stock Name Table\n",(string mkt),"\n",raze exec ((string sym),'("\011"),'(string sym),'"\n") from select distinct sym from srctbl];  };
/��ȡJZT��Ȩ�ļ�*.PWR    getjztcq `:d:/jzt/temp/power.pwr    getjztcq `:d:/jzt/temp/gppower.pwr
getjztcq:{[x]if[not (-11h=type key x);:()]; jztdata:();  filelen:hcount x;  pos:53j;
  flag:first first(enlist "x";enlist(1)) 1:(x;pos;1); pos+:1;  
  while[filelen - pos;  sec:`sym`num!("sh";(12;2)) 1:(x;pos;14); mysym:first sec[`sym];recnum:first sec[`num];
  pos+:14; jztdata,: update sym:mysym,dt:`datetime$dt-36526 from flip `dt`sg`pg`f1`pgjg`fh`f2!("ffffeee";(8,8,8,8,4,4,4))1:(x;pos;44*recnum) ;
  pos+:44*recnum];
  :select date:`date$dt,sym:.zz.jztsym2sym each sym,sg,pg,pgjg,fh from jztdata;
   };
/��ȡJZT��Ȩ�ļ�*.TXT
getjztcscq:{[x]:select .zz.jztsym2sym each sym,date,fh%10,sgbl%10,pgbl%10,pgjg from `sym`date`sgbl`pgbl`pgjg`fh xcol ("SDFFFF";enlist "\t") 0: x}; 
/��ȡJZT�����ļ�
getjztcscw:{: update .zz.jztsym2sym each sym from (`sym`date,`$"f",/:string 1+til 56) xcol t: ("SD",56#"F";enlist "\t") 0: x;}; 
/����Ȩ����ת��Ϊ�͹ɱ���������Ϊ�ı��ļ����ɹ�JZT���룺 setjztcq[`:d:/fe/data/jztcq.txt;`cfcq]
setjztcq:{[dstfile;srctbl]dstfile 0: (enlist "֤ȯ����\tʱ��\t���(10��)\t���(10��)\t��ɼ�\t����(10��)"), 1_"\t" 0:{select sym:.zz.sym2jztsym each sym,date:{`$ssr[string x;".";""]} each date,sg,0f,0f,0f from x where sg<>0}ungroup select date,sg:10*-1+1^af%prev af by sym from `sym`date xasc select from srctbl;};  /srctbl�ֶΣ�`sym`date`af��
\d .