\d .zz
//=============================dzh数据读取=============================
dzhsym2sym:{[x]mktmap:("SF";"SC";"ZC";"DC")!("CFE";"SHF";"CZC";"DCE"); mkt:2#string[x];mkt2:mktmap mkt;:$[""~mkt2;`$(2_string[x]),".",mkt;`$(2_string[x]),".",mkt2];};  
sym2dzhsym:{[x]mktmap:("CFE";"SHF";"CZC";"DCE")!("SF";"SC";"ZC";"DC"); s:upper string x; mktlen:(reverse s)?".";mkt:(neg mktlen)#s;if[mkt in key mktmap;mkt:mktmap[mkt]];  :`$mkt,(neg mktlen+1)_s;}; 
/读取大智慧/分析家DAD文件,如 meta getdzhbar[300;`:d:/dzhcs5m.dad]
getdzhbar:{[mysize;dadfile] :select date:dt.date,time:dt.time-mysize*1000i,.zz.dzhsym2sym each sym,size:`int$mysize,open,high,low,close,volume,openint from 
  update sym:`$sym,dt:`datetime$1970.01.01T00:00:00+dt%86400 from {select from x where dt<>-1}
  update sym:{[x;y;z]:$[z=-1;y;x]}\[`;sym;dt] from 
  select sym:((reverse each`char$/:0x00 vs/: open),'(reverse each`char$/:0x00 vs/: high)),dt,open,high,low,close,volume,openint 
  from flip `dt`open`high`low`close`volume`openint!("ieeeeee ";8#4)1:(dadfile;16); };

\d .