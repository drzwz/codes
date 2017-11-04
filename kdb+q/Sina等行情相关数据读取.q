\d .zz
//=============================从新浪读行情=============================
/从新浪读行情，返回taq表: .zz.getsinataq[`600036.SH]
getsinataq:{[fesym]:$[fesym like "*.S[HZ]";.zz.getsinacstaq fesym;
          (fesym like "*.CFE");.zz.getsinacfetaq fesym;
          (fesym like "*.SHF")|(fesym like "*.DCE")|(fesym like "*.CZC"); .zz.getsinacmtaq fesym;
          [txt:httpget["hq.sinajs.cn";"/list=",string lower sinasym:.zz.sym2dzhsym fesym]; ((1+txt? "\"")_txt)]
          ]};
getsinacstaq:{[fesym]txt:httpget["hq.sinajs.cn";"/list=",string lower sinasym:.zz.sym2dzhsym fesym]; txt:((1+txt? "\"")_txt);
    :select sym:fesym,date,time,prevclose,open,high,low,close,volume,openint,bid,bsize,ask,asize from flip ( `name`open`prevclose`close`high`low`bid0`ask0`volume`openint`bsize`bid`bsize2`bid2`bsize3`bid3`bsize4`bid4`bsize5`bid5`asize`ask`asize2`ask2`asize3`ask3`asize4`ask4`asize5`ask5`date`time)! enlist each("S",(29#"E"),"DT";",")0:(txt? "\"")#txt;};
getsinacfetaq:{[fesym] txt:httpget["hq.sinajs.cn";"/list=CFF_",-4_string fesym]; txt:((1+txt? "\"")_txt); 
    :select sym:fesym,date,time,prevclose:0Ne,`real$open,`real$high,`real$low,`real$close,volume:0e,openint:0e,bid:0e,bsize:0e,ask:0e,asize:0e from 
    flip (`open`high`low`close,(32#`uk),`date`time`uk)! enlist each((36#"E"),"DTE";",")0: (txt? "\"")#txt;};
getsinacmtaq:{[fesym] txt:httpget["hq.sinajs.cn";"/list=",-4_string fesym]; txt:((1+txt? "\"")_txt); 
    :select sym:fesym,date,time,prevclose,open,high,low,close,volume,openint,bid,bsize,ask,asize from 
    flip (`name`time`open`high`low`prevclose`bid`ask`close`settle`prevsettle`bsize`asize`openint`volume`exname`product`date)! enlist each("ST",(13#"E"),"SSD";",")0: (txt? "\"")#txt;};

/从新浪读行情，返回dict .zz.getsinataq2[`600036.SH]
getsinataq2:{[fesym]txt:httpget["hq.sinajs.cn";"/list=",string lower sinasym:.zz.sym2dzhsym fesym]; txt:((1+txt? "\"")_txt); 
    :`name`open`prevclose`close`high`low`bid0`ask0`volume`openint`bsize`bid`bsize2`bid2`bsize3`bid3`bsize4`bid4`bsize5`bid5`asize`ask`asize2`ask2`asize3`ask3`asize4`ask4`asize5`ask5`date`time! ("S",(29#"E"),"DT";",")0:(txt? "\"")#txt;};
//从新浪读分钟线: .zz.getsinabar[`600036.SH;5]  //参数：代码、周期（5、15、30、60）
getsinabar:{[fesym;bar_min]ht:.Q.hg`$"http://money.finance.sina.com.cn/quotes_service/api/jsonp_v2.php/var%20_sz000001_5_1473770168419=/CN_MarketData.getKLineData?symbol=",string[lower .zz.sym2dzhsym[fesym]],"&scale=",string[bar_min],"&ma=no&datalen=1023";if[0=count ht;:()];:select date:`date$dt,time:`time$dt,open,high,low,close,volume from flip`dt`open`high`low`close`volume!("ZEEEEE";",") 0: "},{" vs  ssr[;":";""]ssr[;"[a-z]";""] -3_ 3_last["=" vs ht];};

//从新浪读取期货合约代码
getsinafutsyms:{ht:.Q.hg`$"http://finance.sina.com.cn/iframe/futures_info_cff.js";
 :{update exsym:?[ex in`DCE`SHF;lower exsym;exsym],sym:(`$string[exsym],'".",/:string[ex]) from select ex,exsym,name from delete from x where (exsym in`NULL`SHF`DCE`CZC`CFE)or(name=`$"\272\317\324\274")or(name like "*\301\254\320\370")}{update ex:fills?[exsym in`SHF`DCE`CZC`CFE;exsym;`] from x} 
 flip`name`exsym!flip{$[x like "*new Array(*";{`$"," vs {ssr[x;"\"";""]} -2 _ (2+x ? "(")_ x} x;x like "*\311\317\306\332\313\371*";`SHF;x like "*\264\363\311\314\313\371*";`DCE;x like "*\326\243\311\314\313\371*";`CZC;x like "*\326\320\275\360\313\371*";`CFE;`NULL]}each  ";" vs ht};    

//从ifeng.com读取5、15、30、60分钟数据。
getifengbar:{[fesym;bar_min]ht:.Q.hg`$"http://api.finance.ifeng.com/akmin?scode=",string[lower .zz.sym2dzhsym[fesym]],"&type=",string[bar_min];if[0=count ht;:()];:select date:`date$"Z"$dt,time:`time$"Z"$dt,"E"$open,"E"$high,"E"$low,"E"$close,`real$volume from flip `dt`open`high`low`close`volume`chg`ret`ma5`ma10`ma20`vma5`vma10`vma20`hsl ! flip .j.k[ht][`record];};
/从腾讯读A股代码（只包括当日有交易的A股！！！）
.zz.getQQsyms:{{select sym:upper .zz.dzhsym2sym each `$code,`$code from flip enlist[`code]!enlist "," vs -3 _ raze(6+ss[x;"data:'"]) _ x}.Q.hg `$":http://stock.gtimg.cn/data/index.php?",x};
getQQcssyms:getQQasyms:{.zz.getQQsyms "appn=rank&t=ranka/code&p=1&o=1&l=6000&v=list_data"};
getQQbar5m:{[fesym]select date:{"D"$8#x}each dt,time:{("T"$8_x,"00")-00:05}each dt,sym:fesym,"E"$open,"E"$high,"E"$low,"E"$close,`real$100*"E"$volume from flip `dt`open`close`high`low`volume! flip { {raze value[x[`data]][`m5]} .j.k raze(6+ss[x;"today="]) _ x} .Q.hg`$":http://ifzq.gtimg.cn/appstock/app/kline/mkline?param=",string[lower[.zz.sym2dzhsym[fesym]]],",m5,,1000&_var=m5_today&r=",string[rand 1.0]};
getQQbar30m:{[fesym]select date:{"D"$8#x}each dt,time:{("T"$8_x,"00")-00:30}each dt,sym:fesym,"E"$open,"E"$high,"E"$low,"E"$close,`real$100*"E"$volume from flip `dt`open`close`high`low`volume! flip { {raze value[x[`data]][`m30]} .j.k raze(6+ss[x;"today="]) _ x} .Q.hg`$":http://ifzq.gtimg.cn/appstock/app/kline/mkline?param=",string[lower[.zz.sym2dzhsym[fesym]]],",m30,,1000&_var=m30_today&r=",string[rand 1.0]};
/从腾讯读行情 .zz.getQQbar[`600036.SH`000001.SZ]
getQQbar:{[fesym]txt:.zz.httpget["qt.gtimg.cn";"/r=",raze[string[1?1.0]],"&q=", "," sv {lower string .zz.sym2dzhsym x} each $[-11h=type fesym;enlist fesym;fesym]];  
    :raze{select sym:?[`500000<`$sym;`$sym,\:".SH";`$sym,\:".SZ"],"F"$close,volume:100*"F"$volume from flip enlist each `sym`close`volume!@["~" vs x;(2;3;6)]} each -1_";" vs txt;};
/从网上读证券代码列表和日期 from tushare's link    
getwebcssyms:{`sym xcols update sym:?[code like "6*";`$string[code],\:".SH";`$string[code],\:".SZ"] from ("SSSSFFFFFFFFFFFD";enlist ",") 0: .Q.hg`:http://218.244.146.57/static/all.csv};
getwebcsdates:{("DB";enlist",") 0: .Q.hg`:http://218.244.146.57/static/calAll.csv};  

//读取分级B价格，下折母基需要跌多少等
getfundb:{raze{select {`$x,$[x like "5*";".SH";".SZ"]}each fundb_base_fund_id,{`$x,$[x like "5*";".SH";".SZ"]}each funda_id,{`$x,$[x like "5*";".SH";".SZ"]}each fundb_id,`$status_cd,"F"$fundb_current_price,{"F"$ssr[x;"%";""]}each fundb_discount_rt,"F"$fundb_price_leverage_rt,{"F"$ssr[x;"%";""]}each fundb_lower_recalc_rt,"T"$last_time from 
 flip{(key x)!enlist each value x} x}each exec cell from  select from (update `$id from ((.j.k  first system "d:/fe/q/w32/curl.exe https://www.jisilu.cn/data/sfnew/fundb_list/ -k -s")`rows)) };
 
\d .