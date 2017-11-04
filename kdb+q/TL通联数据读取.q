\d .zz
//=============================通联数据读取=============================
tlexmap:("XSHG";"XSHE";"CCFX";"CCFX2";"XSGE";"XDCE";"XZCE")!("SH";"SZ";"CFE";"CFE";"SHF";"DCE";"CZC");
tlsym2sym:{idot:reverse[string[x]]?".";ex:.zz.tlexmap[neg[idot]#string x];$[""~ex;:x;`$(neg[idot] _ string x),ex]};     /  tlsym2sym `if1501.CCFX
gettltoken:{[]:@[get;(`$":",ssr[getenv[`qhome];"\\";"/"],"/../data/myfiles/tltoken");""]};  //gettltoken[]
gettljsondata:{[token;url]url:ssr[url;".csv?";".json?"];system ssr[getenv[`qhome];"\\";"/"],"/w32/curl.exe -k -s --header \"Authorization: Bearer ",token,"\" \"https://api.wmcloud.com:443/data",url,"\""};  //curl with ssl
gettlcsvdata:{[token;url]url:ssr[url;".json?";".csv?"];system ssr[getenv[`qhome];"\\";"/"],"/w32/curl.exe -k -s --header \"Authorization: Bearer ",token,"\" \"https://api.wmcloud.com:443/data",url,"\""};  //curl with ssl
gettldata:{[token;url;fieldtypes]r:gettlcsvdata[token;url];
    :$["{"~first first r;.j.k first r;
    "-"~first first r;`errid`errmsg`data!(@[":" vs first r;0;"J"$]),`;
    `errid`errmsg`data!(0;`Success;{(lower cols x) xcol x}(fieldtypes;enlist",") 0: r)];};
//1、读取通联数据，应事先免费注册一个ID并申请免费使用数据。同时要求q\w32\目录下应有支持https的curl.exe,
//下载地址：http://winampplugins.co.uk/curl/curl_7_48_0_openssl_nghttp2_x86.7z  (或从https://curl.haxx.se/download.html下载带有SSL的版本)
//2、用gettldata函数读取数据，其参数：
//  token：注册https://app.wmcloud.com/open/api?lang=zh后从“设置”“安全中心”的API Token复制DataAPI Token
//  url: https://app.wmcloud.com/open/api?lang=zh 选数据项，复制其URL，并根据需要修改URL里的参数,URL参数含义见网页说明。
//  fieldtypes: 返回字段的类型解析，注意字符个数和类型应与返回字段匹配！
//例子：token:"xxxxxxxxxxxxxxxxxxxxx"
//gettlcsvdata[token;"/api/master/getSecID.csv?field=&assetClass1=&ticker=60003&partyID=&cnSpell="]   /直接取csv数据
//r:gettldata[token;"/api/master/getSecID.csv?field=&assetClass=&ticker=600036&partyID=&cnSpell=";"SSSSSSSDSSS"]   /证券编码及基本上市信息
//r:gettldata[token;"/api/market/getMktEqud.json?field=&beginDate=&endDate=&secID=&ticker=&tradeDate=20150513";"SSSSD",16#"E"]    /沪深股票日线行情
//r:gettldata[token;"/api/market/getMktAdjf.json?field=secID,exDivDate,endDate,accumAdjFactor&secID=&ticker=000001,000002";"SSSS"] /沪深股票复权因子
//r:gettldata[token;"/market/getTickRTSnapshot.json?securityID=000001.XSHG,000001.XSHE&field=lastPrice,shortNM,dataDate,dataTime";""]
//r:gettldata[token;"/api/equity/getEquIndustry.json?field=&industryVersionCD=010303&industry=&secID=&ticker=000001,600001&intoDate=";(10#"S"),"JSSSDDISSSS"]   /股票行业分类
//r:gettldata[token;"/api/future/getFutu.json?field=&secID=&ticker=CF507&contractObject=&exchangeCD=";"SDSSSSSSSFDIFSFSSFSFIIDDDSSDSDSDSSS"]   /期货合约信息
//r:gettldata[token;"/api/macro/getChinaDataGDP.json?field=&indicID=M010000002&indicName=&beginDate=&endDate=";"SSZDFSSSZ"]  /GDP
//r:gettldata[token;"/api/subject/getSocialDataXQ.json?field=&ticker=600000&beginDate=20140101&endDate=20150101";"SZJFZZ"]  / 雪球社交统计
//r:gettldata[token;"/api/subject/getNewsInfo.json?field=&newsID=8832506";"JSSSSSZZ"]  / 新闻信息  r[`data][`newssummary]
//update sym:tlsym2sym each secid from r`data 

//读取交易日期 .zz.tlcsdates2hdb[""] ,若token为""，则从本地读取，若本地文件不存在，则取不到数据。
tlcsdates2hdb:{[tltoken]0N!(.z.T;`tlcsdates2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];r:.zz.gettldata[token;"/api/master/getTradeCal.json?field=calendarDate,isOpen&exchangeCD=XSHG&beginDate=20100101&endDate=";"DB"];
  if[r[`errid]=0; (hsym`$.zz.hdbpathstr[],"/csdates/";17;2;6) set select date:calendardate from r[`data] where isopen];};
//读取申万行业 .zz.tlcsswhy2hdb[""]
tlcsswhy2hdb:{[tltoken]0N!(.z.T;`tlcsswhy2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];r:.zz.gettldata[token;"/api/equity/getEquIndustry.json?field=secID,industryName1,industryName2,industryName3&industryVersionCD=010303&industry=&secID=&ticker=&intoDate=",string[.z.D]_/4 6;"SSSS"];
  if[0=r`errid;(hsym`$.zz.hdbpathstr[],"/csswhy/";17;2;6) set .Q.en[.zz.hdbpath[]] select sym:.zz.tlsym2sym each secid,industry1:string industryname1,industry2:string industryname2,industry3:string industryname3 from r[`data]];};
//读取指数成份 .zz.tlcsidxsyms2hdb[""]
tlcsidxsyms2hdb:{[tltoken]0N!(.z.T;`tlcsidxsyms2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];r:.zz.gettldata[token;"/api/idx/getIdxCons.json?field=secID,consID&secID=&ticker=000016,000300,000905,000906,000852,399001,399005,399006&intoDate=&isNew=1";"SS"];
  if[0=r`errid;(hsym`$.zz.hdbpathstr[],"/csidxsyms/";17;2;6) set .Q.en[.zz.hdbpath[]] select idx:{$[x like "0*.ZICN";`$(6#string[x]),".SH";x like "3*.ZICN";`$(6#string[x]),".SZ";x]} each secid,sym:.zz.tlsym2sym each consid from r[`data]];};
//读取复权因子 .zz.tlcsaf2hdb[""]
tlcsaf2hdb:{[tltoken]0N!(.z.T;`tlcsaf2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];r:.zz.gettldata[token;"/api/master/getSecTypeRel.json?field=secID,secShortName&typeID=101001001001&secID=&ticker=";"SS"];  //全部A股
  asharescodes:$[r[`errid]=0;r`data;([]secid:`$();secshortname:`$())];
  mycodes:0N 50#exec secid from asharescodes;MYAF:();
  cc:0;do[count mycodes;mycode:"," sv string mycodes[cc];
    r:.zz.gettldata[token;"/api/market/getMktAdjf.json?field=secID,exDivDate,accumAdjFactor,endDate&secID=",mycode,"&ticker=";"SDFD"]; /沪深股票复权因子
    if[r[`errid]=0;MYAF ,: `sym`date xasc ungroup select date:(first[date],enddate),af:(1f,af) by sym from `sym`date xdesc select sym:.zz.tlsym2sym each secid,date:exdivdate,af:accumadjfactor,enddate from r`data]; cc+:1];
    if[98h=type MYAF;(hsym`$.zz.hdbpathstr[],"/csaf2/";17;2;6) set .Q.en[.zz.hdbpath[]]MYAF];       /date表示自date日起 前 复权因子为为af,注意是前复权
    /delete MYAF from `.;
    };
//读取基金复权因子 .zz.tlcsaffund2hdb[""]
tlcsaffund2hdb:{[tltoken]0N!(.z.T;`tlcsaffund2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];
 r:.zz.gettldata[token;"/api/master/getTradeCal.json?field=calendarDate,isOpen&exchangeCD=XSHG&beginDate=20140101&endDate=";"DB"];
 mydates:{select from x where (not date in .zz.gethdbdates`csaf_fund)&date<=.z.D}update datestr:{ssr[string x;".";""]}each date from select date:calendardate from r[`data] where isopen;
  do[count[mydates]+ii:0;0N!(.z.T;`tlcsaffund2hdb;mydates[ii;`date]);
    r:.zz.gettldata[token;"/api/market/getMktFundd.json?field=secID,tradeDate,accumAdjFactor&beginDate=&endDate=&secID=&ticker=&tradeDate=",mydates[ii;`datestr];"SDF"];
    if[(r[`errid]=0)&(type[r[`data]]=98h);.[hsym`$.zz.hdbpathstr[],"/csaf_fund/";();,; .Q.en[.zz.hdbpath[]] select date:tradedate,sym:.zz.tlsym2sym each secid,af:accumadjfactor from r`data];.zz.sethdbdates[`csaf_fund;mydates[ii;`date]] ];
    ii+:1];
    };
//CFE&SHF 期货合约基本信息  .zz.tlcfsyms2hdb[""]
tlcfsyms2hdb:{[tltoken]0N!(.z.T;`tlcfsyms2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];r:.zz.gettldata[token;"/api/future/getFutu.json?field=secID,listDate,lastTradeDate&secID=&ticker=&contractObject=&exchangeCD=CCFX,XSGE";"SDD"];
  if[r[`errid]=0; (hsym`$.zz.hdbpathstr[],"/cfsymslist/";17;3;0) set .Q.en[.zz.hdbpath[]] select sym:.zz.tlsym2sym each secid,listdate,lastdate:lasttradedate from r`data];};
\d .
