\d .zz
//=============================tdx通达信数据读写=============================
tdxmktmap:flip `mkt`tdxmkt`name!flip((`SH;`SH;`$"SH:上海证券交易所");(`SZ;`SZ;`$"SZ:深圳证券交易所");(`01;`01;`$"01:临时股");(`04;`04;`$"04:郑州期权_仿真");(`05;`05;`$"05:大连期权_仿真");(`06;`06;`$"06:上海期权_仿真");(`07;`07;`$"07:中金所期权_仿真");(`08;`08;`$"08:上交所个股期权");(`10;`10;`$"10:基本汇率");
 (`11;`11;`$"11:交叉汇率");(`12;`12;`$"12:国际指数");(`13;`13;`$"13:国际贵金属");(`14;`14;`$"14:伦敦金属");(`15;`15;`$"15:伦敦石油");(`16;`16;`$"16:纽约商品");(`17;`17;`$"17:纽约石油");(`18;`18;`$"18:芝加哥谷");(`19;`19;`$"19:东京工业品");(`20;`20;`$"20:纽约期货");
 (`27;`27;`$"27:香港指数");(`CZC;`28;`$"28:郑州商品");(`DCE;`29;`$"29:大连商品");(`SHF;`30;`$"30:上海期货");(`31;`31;`$"31:香港主板");(`33;`33;`$"33:开放式基金");(`34;`34;`$"34:货币型基金");(`37;`37;`$"37:全球指数(静态)");(`38;`38;`$"38:宏观指标");(`39;`39;`$"39:马来期货");
 (`40;`40;`$"40:中国概念股");(`41;`41;`$"41:美股知名公司");(`42;`42;`$"42:商品指数");(`43;`43;`$"43:B股转H股");(`44;`44;`$"44:股转系统");(`46;`46;`$"46:上海黄金");(`CFE;`47;`$"47:中金所期货");(`48;`48;`$"48:香港创业板");(`49;`49;`$"49:香港基金");(`50;`50;`$"50:渤海商品");
 (`54;`54;`$"54:国债预发行");(`56;`56;`$"56:阳光私募基金");(`57;`57;`$"57:券商集合理财");(`58;`58;`$"58:券商货币理财");(`60;`60;`$"60:主力期货合约");(`62;`62;`$"62:中证指数");(`70;`70;`$"70:扩展板块指数");(`71;`71;`$"71:港股通");(`74;`74;`$"74:美国股票"));
tdxsym2sym:{[x]mktmap:1!select tdxmkt,mkt from tdxmktmap;mkt0:2#string[x];mkt1:string mktmap[`$mkt0;`mkt];  :upper$[""~mkt1; `$(2_ssr[string[x];"#";""]),".",mkt0;  `$(2_ssr[string[x];"#";""]),".",mkt1];}; 
sym2tdxsym:{[x]mktmap:1!select mkt,tdxmkt from tdxmktmap; s:upper string x; mktlen:(reverse s)?"."; mkt:`$(neg mktlen)#s; mkt1:$[mkt in `SH`SZ;mkt;mkt in exec mkt from tdxmktmap;`$string[mktmap[mkt;`tdxmkt]],"#";mkt];  :`$string[mkt1],(neg mktlen+1)_s;}; 
 
//取概念板块  select distinct bk from   .zz.gettdxgnbk[`]
gettdxgnbk:{[file]tdxfile:$[file=`;`:d:/tdx/t0002/hq_cache/block_gn.dat;file];
  :update sym:?[sym like "[5689]*";`$string[sym],\:".SH";`$string[sym],\:".SZ"] from raze{{select from x where sym<>`}flip`bk`sym!(x[0];1_x)}each flip (401#"s";13,400#7)1:(tdxfile;386;(hcount tdxfile)-386)};
//取风格板块  select distinct bk from  .zz.gettdxfgbk[`]
gettdxfgbk:{[file]tdxfile:$[file=`;`:d:/tdx/t0002/hq_cache/block_fg.dat;file];
  :update sym:?[sym like "[5689]*";`$string[sym],\:".SH";`$string[sym],\:".SZ"] from raze{{select from x where sym<>`}flip`bk`sym!(x[0];1_x)}each flip (401#"s";13,400#7)1:(tdxfile;386;(hcount tdxfile)-386)};
//取指数成份股板块 select distinct bk from  .zz.gettdxzsbk[`]
gettdxzsbk:{[file]tdxfile:$[file=`;`:d:/tdx/t0002/hq_cache/block_zs.dat;file];
  :update sym:?[sym like "[5689]*";`$string[sym],\:".SH";`$string[sym],\:".SZ"] from raze{{select from x where sym<>`}flip`bk`sym!(x[0];1_x)}each flip (401#"s";13,400#7)1:(tdxfile;386;(hcount tdxfile)-386)};  
//取板块指数信息 select distinct bk from  .zz.gettdxbkzs[`]
gettdxbkzs:{[file]tdxfile:$[file=`;`:d:/tdx/t0002/hq_cache/tdxzs.cfg;file];
  :update sym:?[sym like "[5689]*";`$string[sym],\:".SH";`$string[sym],\:".SZ"]from flip`bk`sym`f1`f2`f3`bkid!("SSSSSS";"|") 0:tdxfile };  

//从完整的文件名读取通达信日线行情数据:   .zz.gettdxbar["D:/TDX/Vipdoc/sh/lday/sh999999.day"]
gettdxbar:{[x]tt:flip `date1`open`high`low`close`amount`volume`openint!("iiiiieii";4 4 4 4 4 4 4 4 ) 1: `$(":",x);sym1:(upper x (first x ss "s[hz][0-9][0-9][0-9][0-9][0-9][0-9]") + til 8);:update .zz.tdxsym2sym each sym from select date:"D"$string date1,sym:`$sym1,size:86400i,`real$open%100,`real$high%100,`real$low%100,`real$close%100, `real$volume,openint:`real$amount from tt;};
//读取所有A股基金的日线数据，若没有路径参数，则为`:d:/tdx:     .zz.gettdxcsbar1d[]
gettdxcsbar1d:{[tdxpath]if[null tdxpath;tdxpath:`:d:/tdx];if[-11h<>type tdxpath;'para_error];:raze{sym1:-8#-4 _string x;sym1:`$(-6#sym1),".",(2#sym1);select date:"D"$string date1,sym:sym1,`real$open%100,`real$high%100,`real$low%100,`real$close%100,`real$volume from 
        flip `date1`open`high`low`close`volume!("iiiii i ";8#4) 1: x}
   each raze{[dir]file:upper key dir;file:file[where (file like "SH000*.DAY")or(file like "SH510*.DAY")or(file like "SH6*.DAY")or(file like "SZ[03]0*.DAY")or(file like "SZ159*.DAY")or(file like "SZ399*.DAY")];
        :(` sv)each dir,/:file} each (` sv)each tdxpath,/:(`vipdoc`sh`lday;`vipdoc`sz`lday);
  };
//从完整的文件名读取通达信扩展日线行情数据:   .zz.gettdxbar2["D:/TDX/Vipdoc/ds/lday/47#IFL8.day"]
gettdxbar2:{[x]tt:flip `date1`open`high`low`close`openint`volume`settle!("ieeeeiie";8#4) 1: `$(":",x);sym1:upper -4_(1+first x ss "#") _ x;:select date:"D"$string date1,sym:`$sym1,size:86400i,open,high,low,close,`real$volume,`real$openint from tt;};
//从完整文件名读取股票分钟数据。
gettdxbarm:{[x]tt:flip `date1`time1`open`high`low`close`openint`volume`amount!("hheeeeiie";2 2,7#4) 1: `$(":",x);sym1:$[x like "*/s[hz]/*";(upper x (first x ss "s[hz][0-9][0-9][0-9][0-9][0-9][0-9]") + til 8);upper -4_(1+first x ss "#") _ x];mysize:$[x like "*.lc5";300i;x like "*.lc1";60i;0i];:select date:{"D"$string[2004+floor[x%2048]],-4#"00",string x mod 2048}each date1,time:neg[mysize*1000]+`time$time1*60000,sym:`$sym1,size:mysize,open,high,low,close,`real$volume,openint:`real$amount from tt;};

//读取5分钟股票、期货等数据,假设tdx目录为d:\tdx， .zz.gettdxbar5m[`000001.SZ] .zz.gettdxbar5m[`RBL8.SHF]
gettdxbar5m:gettdxcsbar5m:{[x]tdxsym:string .zz.sym2tdxsym[x];tdxmkt:2#tdxsym;
 :select date:{"D"$string[2004+floor[x%2048]],-4#"00",string x mod 2048}each date1,time:neg[ 300*1000]+`time$time1*60000,sym:x,open,high,low,close,`real$volume,openint:`real$openint from flip `date1`time1`open`high`low`close`openint`volume`amount!("hheeeeiie";2 2,7#4) 1: `$(":d:/tdx/vipdoc/",$[tdxmkt like "S[HZ]";tdxmkt;"ds"],"/fzline/",tdxsym,".lc5");};
//读取1分钟股票、期货等数据,假设tdx目录为d:\tdx， .zz.gettdxbar1m[`000001.SZ] .zz.gettdxbar1m[`RBL8.SHF]
gettdxbar1m:gettdxcsbar1m:{[x]tdxsym:string .zz.sym2tdxsym[x];tdxmkt:2#tdxsym;
 :select date:{"D"$string[2004+floor[x%2048]],-4#"00",string x mod 2048}each date1,time:neg[ 60*1000]+`time$time1*60000,sym:x,open,high,low,close,`real$volume,openint:`real$openint from flip `date1`time1`open`high`low`close`openint`volume`amount!("hheeeeiie";2 2,7#4) 1: `$(":d:/tdx/vipdoc/",$[tdxmkt like "S[HZ]";tdxmkt;"ds"],"/minline/",tdxsym,".lc1");};


//写tdx本地日线数据,用法： .zz.settdxbar1d[`:d:/tdx;`000001.SZ;tbl]; tbl字段：date,open,high,low,close,volume,openint; 写入后可能需要重启tdx，并脱机运行。
settdxbar1d:settdxcsbar1d:{[tdxdir;mysym;tbl]mkt:`$(2#string .zz.sym2tdxsym mysym);
  dscfile1:` sv(tdxdir;`vipdoc;$[mkt in`SZ`SH;mkt;`ds];`lday;`$string[.zz.sym2tdxsym mysym],".day");0N!(.z.T;dscfile1);
    dscfile1 1: raze reverse each 0x0 vs/: raze value each  select date1:{"I"$string[x]_/4 6}each date,`int$open*100,`int$high*100,`int$low*100,`int$close*100,amount:`real$openint,`int$volume,openint:0i from `date xasc select from tbl;
  };   
//写tdx本地5分钟数据,用法： .zz.settdxbar5m[`:d:/tdx;`000001.SZ;tbl];   日期格式：2个字节的后11位为月日，前5位+2004为年;
settdxbar5m:settdxcsbar5m:{[tdxdir;mysym;tbl]mkt:`$(2#string .zz.sym2tdxsym mysym);dscfile1:` sv(tdxdir;`vipdoc;$[mkt in`SZ`SH;mkt;`ds];`fzline;`$string[.zz.sym2tdxsym mysym],".lc5");0N!(.z.T;dscfile1);
    dscfile1 1: raze reverse each 0x0 vs/: raze value each  select date1:`short$(2048*neg[2004]+`year$date)+(100*`mm$date)+`dd$date,time1:`short$(time+300000)%60000,`real$open,`real$high,`real$low,`real$close,`int$openint,`int$volume,amount:`real$openint from select from tbl;
  };  
//写tdx本地1分钟数据,用法： .zz.settdxbar1m[`:d:/tdx;`000001.SZ;tbl];   日期格式：2个字节的后11位为月日，前5位+2004为年;
settdxbar1m:settdxcsbar1m:{[tdxdir;mysym;tbl]mkt:`$(2#string .zz.sym2tdxsym mysym);dscfile1:` sv(tdxdir;`vipdoc;$[mkt in`SZ`SH;mkt;`ds];`minline;`$string[.zz.sym2tdxsym mysym],".lc1");0N!(.z.T;dscfile1);
    dscfile1 1: raze reverse each 0x0 vs/: raze value each select date1:`short$(2048*neg[2004]+`year$date)+(100*`mm$date)+`dd$date,time1:`short$(time+60000)%60000,`real$open,`real$high,`real$low,`real$close,`int$openint,`int$volume,amount:`real$openint from select from tbl;
    }; 
\d .