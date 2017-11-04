\d .zz
//=============================飞狐数据读取=============================
fhsym2sym:{[x]mktmap:("ZJ";"SQ";"ZZ";"DL")!("CFE";"SHF";"CZC";"DCE"); mkt:2#string[x];mkt2:mktmap mkt;:$[""~mkt2;`$(2_string[x]),".",mkt;`$(2_string[x]),".",mkt2];};  
sym2fhsym:{[x]mktmap:("CFE";"SHF";"CZC";"DCE")!("ZJ";"SQ";"ZZ";"DL"); s:upper string x; mktlen:(reverse s)?".";mkt:(neg mktlen)#s;if[mkt in key mktmap;mkt:mktmap[mkt]];  :`$mkt,(neg mktlen+1)_s;}; 
/读取飞狐安装文件,如 meta     .zz.getfhbar[86400;`:d:/fhcfd.qda]              .zz.getfhbar[60;`:d:/fhcf1m.qm1]
getfhbar:{[mysize;file]
  t:();
  header:`flag`flag2`seccount!("iii";3#4)1:(file;0;12);
  off:12;
  do[first header[`seccount];
    secheader:("ssi";(12;12;4)) 1: (file;off;28);off+:28; //头部
    mysym:first secheader[0];  
    secdata:update time:time-mysize*1000 from update sym:mysym,fhsym:first secheader[0],name:first secheader[1],date:`date$(1970.01.01+date%86400),time:`time$(1970.01.01+date%86400) from flip `date`open`high`low`close`volume`openint`dealcount!("ieeeeeei";8#4) 1: (file;off;32*first secheader[2]); //数据
    t,:secdata; off+:32*first secheader[2]; 
    ];
  :select date,time,.zz.fhsym2sym each sym,size:`int$mysize,open,high,low,close,volume:?[sym like "S[HZ]*";`real$volume*100;volume],openint,dealcount,name from t;};
\d .