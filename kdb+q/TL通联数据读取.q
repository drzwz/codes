\d .zz
//=============================ͨ�����ݶ�ȡ=============================
tlexmap:("XSHG";"XSHE";"CCFX";"CCFX2";"XSGE";"XDCE";"XZCE")!("SH";"SZ";"CFE";"CFE";"SHF";"DCE";"CZC");
tlsym2sym:{idot:reverse[string[x]]?".";ex:.zz.tlexmap[neg[idot]#string x];$[""~ex;:x;`$(neg[idot] _ string x),ex]};     /  tlsym2sym `if1501.CCFX
gettltoken:{[]:@[get;(`$":",ssr[getenv[`qhome];"\\";"/"],"/../data/myfiles/tltoken");""]};  //gettltoken[]
gettljsondata:{[token;url]url:ssr[url;".csv?";".json?"];system ssr[getenv[`qhome];"\\";"/"],"/w32/curl.exe -k -s --header \"Authorization: Bearer ",token,"\" \"https://api.wmcloud.com:443/data",url,"\""};  //curl with ssl
gettlcsvdata:{[token;url]url:ssr[url;".json?";".csv?"];system ssr[getenv[`qhome];"\\";"/"],"/w32/curl.exe -k -s --header \"Authorization: Bearer ",token,"\" \"https://api.wmcloud.com:443/data",url,"\""};  //curl with ssl
gettldata:{[token;url;fieldtypes]r:gettlcsvdata[token;url];
    :$["{"~first first r;.j.k first r;
    "-"~first first r;`errid`errmsg`data!(@[":" vs first r;0;"J"$]),`;
    `errid`errmsg`data!(0;`Success;{(lower cols x) xcol x}(fieldtypes;enlist",") 0: r)];};
//1����ȡͨ�����ݣ�Ӧ�������ע��һ��ID���������ʹ�����ݡ�ͬʱҪ��q\w32\Ŀ¼��Ӧ��֧��https��curl.exe,
//���ص�ַ��http://winampplugins.co.uk/curl/curl_7_48_0_openssl_nghttp2_x86.7z  (���https://curl.haxx.se/download.html���ش���SSL�İ汾)
//2����gettldata������ȡ���ݣ��������
//  token��ע��https://app.wmcloud.com/open/api?lang=zh��ӡ����á�����ȫ���ġ���API Token����DataAPI Token
//  url: https://app.wmcloud.com/open/api?lang=zh ѡ�����������URL����������Ҫ�޸�URL��Ĳ���,URL�����������ҳ˵����
//  fieldtypes: �����ֶε����ͽ�����ע���ַ�����������Ӧ�뷵���ֶ�ƥ�䣡
//���ӣ�token:"xxxxxxxxxxxxxxxxxxxxx"
//gettlcsvdata[token;"/api/master/getSecID.csv?field=&assetClass1=&ticker=60003&partyID=&cnSpell="]   /ֱ��ȡcsv����
//r:gettldata[token;"/api/master/getSecID.csv?field=&assetClass=&ticker=600036&partyID=&cnSpell=";"SSSSSSSDSSS"]   /֤ȯ���뼰����������Ϣ
//r:gettldata[token;"/api/market/getMktEqud.json?field=&beginDate=&endDate=&secID=&ticker=&tradeDate=20150513";"SSSSD",16#"E"]    /�����Ʊ��������
//r:gettldata[token;"/api/market/getMktAdjf.json?field=secID,exDivDate,endDate,accumAdjFactor&secID=&ticker=000001,000002";"SSSS"] /�����Ʊ��Ȩ����
//r:gettldata[token;"/market/getTickRTSnapshot.json?securityID=000001.XSHG,000001.XSHE&field=lastPrice,shortNM,dataDate,dataTime";""]
//r:gettldata[token;"/api/equity/getEquIndustry.json?field=&industryVersionCD=010303&industry=&secID=&ticker=000001,600001&intoDate=";(10#"S"),"JSSSDDISSSS"]   /��Ʊ��ҵ����
//r:gettldata[token;"/api/future/getFutu.json?field=&secID=&ticker=CF507&contractObject=&exchangeCD=";"SDSSSSSSSFDIFSFSSFSFIIDDDSSDSDSDSSS"]   /�ڻ���Լ��Ϣ
//r:gettldata[token;"/api/macro/getChinaDataGDP.json?field=&indicID=M010000002&indicName=&beginDate=&endDate=";"SSZDFSSSZ"]  /GDP
//r:gettldata[token;"/api/subject/getSocialDataXQ.json?field=&ticker=600000&beginDate=20140101&endDate=20150101";"SZJFZZ"]  / ѩ���罻ͳ��
//r:gettldata[token;"/api/subject/getNewsInfo.json?field=&newsID=8832506";"JSSSSSZZ"]  / ������Ϣ  r[`data][`newssummary]
//update sym:tlsym2sym each secid from r`data 

//��ȡ�������� .zz.tlcsdates2hdb[""] ,��tokenΪ""����ӱ��ض�ȡ���������ļ������ڣ���ȡ�������ݡ�
tlcsdates2hdb:{[tltoken]0N!(.z.T;`tlcsdates2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];r:.zz.gettldata[token;"/api/master/getTradeCal.json?field=calendarDate,isOpen&exchangeCD=XSHG&beginDate=20100101&endDate=";"DB"];
  if[r[`errid]=0; (hsym`$.zz.hdbpathstr[],"/csdates/";17;2;6) set select date:calendardate from r[`data] where isopen];};
//��ȡ������ҵ .zz.tlcsswhy2hdb[""]
tlcsswhy2hdb:{[tltoken]0N!(.z.T;`tlcsswhy2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];r:.zz.gettldata[token;"/api/equity/getEquIndustry.json?field=secID,industryName1,industryName2,industryName3&industryVersionCD=010303&industry=&secID=&ticker=&intoDate=",string[.z.D]_/4 6;"SSSS"];
  if[0=r`errid;(hsym`$.zz.hdbpathstr[],"/csswhy/";17;2;6) set .Q.en[.zz.hdbpath[]] select sym:.zz.tlsym2sym each secid,industry1:string industryname1,industry2:string industryname2,industry3:string industryname3 from r[`data]];};
//��ȡָ���ɷ� .zz.tlcsidxsyms2hdb[""]
tlcsidxsyms2hdb:{[tltoken]0N!(.z.T;`tlcsidxsyms2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];r:.zz.gettldata[token;"/api/idx/getIdxCons.json?field=secID,consID&secID=&ticker=000016,000300,000905,000906,000852,399001,399005,399006&intoDate=&isNew=1";"SS"];
  if[0=r`errid;(hsym`$.zz.hdbpathstr[],"/csidxsyms/";17;2;6) set .Q.en[.zz.hdbpath[]] select idx:{$[x like "0*.ZICN";`$(6#string[x]),".SH";x like "3*.ZICN";`$(6#string[x]),".SZ";x]} each secid,sym:.zz.tlsym2sym each consid from r[`data]];};
//��ȡ��Ȩ���� .zz.tlcsaf2hdb[""]
tlcsaf2hdb:{[tltoken]0N!(.z.T;`tlcsaf2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];r:.zz.gettldata[token;"/api/master/getSecTypeRel.json?field=secID,secShortName&typeID=101001001001&secID=&ticker=";"SS"];  //ȫ��A��
  asharescodes:$[r[`errid]=0;r`data;([]secid:`$();secshortname:`$())];
  mycodes:0N 50#exec secid from asharescodes;MYAF:();
  cc:0;do[count mycodes;mycode:"," sv string mycodes[cc];
    r:.zz.gettldata[token;"/api/market/getMktAdjf.json?field=secID,exDivDate,accumAdjFactor,endDate&secID=",mycode,"&ticker=";"SDFD"]; /�����Ʊ��Ȩ����
    if[r[`errid]=0;MYAF ,: `sym`date xasc ungroup select date:(first[date],enddate),af:(1f,af) by sym from `sym`date xdesc select sym:.zz.tlsym2sym each secid,date:exdivdate,af:accumadjfactor,enddate from r`data]; cc+:1];
    if[98h=type MYAF;(hsym`$.zz.hdbpathstr[],"/csaf2/";17;2;6) set .Q.en[.zz.hdbpath[]]MYAF];       /date��ʾ��date���� ǰ ��Ȩ����ΪΪaf,ע����ǰ��Ȩ
    /delete MYAF from `.;
    };
//��ȡ����Ȩ���� .zz.tlcsaffund2hdb[""]
tlcsaffund2hdb:{[tltoken]0N!(.z.T;`tlcsaffund2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];
 r:.zz.gettldata[token;"/api/master/getTradeCal.json?field=calendarDate,isOpen&exchangeCD=XSHG&beginDate=20140101&endDate=";"DB"];
 mydates:{select from x where (not date in .zz.gethdbdates`csaf_fund)&date<=.z.D}update datestr:{ssr[string x;".";""]}each date from select date:calendardate from r[`data] where isopen;
  do[count[mydates]+ii:0;0N!(.z.T;`tlcsaffund2hdb;mydates[ii;`date]);
    r:.zz.gettldata[token;"/api/market/getMktFundd.json?field=secID,tradeDate,accumAdjFactor&beginDate=&endDate=&secID=&ticker=&tradeDate=",mydates[ii;`datestr];"SDF"];
    if[(r[`errid]=0)&(type[r[`data]]=98h);.[hsym`$.zz.hdbpathstr[],"/csaf_fund/";();,; .Q.en[.zz.hdbpath[]] select date:tradedate,sym:.zz.tlsym2sym each secid,af:accumadjfactor from r`data];.zz.sethdbdates[`csaf_fund;mydates[ii;`date]] ];
    ii+:1];
    };
//CFE&SHF �ڻ���Լ������Ϣ  .zz.tlcfsyms2hdb[""]
tlcfsyms2hdb:{[tltoken]0N!(.z.T;`tlcfsyms2hdb);token:$[tltoken~"";.zz.gettltoken[];tltoken];r:.zz.gettldata[token;"/api/future/getFutu.json?field=secID,listDate,lastTradeDate&secID=&ticker=&contractObject=&exchangeCD=CCFX,XSGE";"SDD"];
  if[r[`errid]=0; (hsym`$.zz.hdbpathstr[],"/cfsymslist/";17;3;0) set .Q.en[.zz.hdbpath[]] select sym:.zz.tlsym2sym each secid,listdate,lastdate:lasttradedate from r`data];};
\d .
