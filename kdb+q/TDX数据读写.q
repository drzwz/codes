\d .zz
//=============================tdxͨ�������ݶ�д=============================
tdxmktmap:flip `mkt`tdxmkt`name!flip((`SH;`SH;`$"SH:�Ϻ�֤ȯ������");(`SZ;`SZ;`$"SZ:����֤ȯ������");(`01;`01;`$"01:��ʱ��");(`04;`04;`$"04:֣����Ȩ_����");(`05;`05;`$"05:������Ȩ_����");(`06;`06;`$"06:�Ϻ���Ȩ_����");(`07;`07;`$"07:�н�����Ȩ_����");(`08;`08;`$"08:�Ͻ���������Ȩ");(`10;`10;`$"10:��������");
 (`11;`11;`$"11:�������");(`12;`12;`$"12:����ָ��");(`13;`13;`$"13:���ʹ����");(`14;`14;`$"14:�׶ؽ���");(`15;`15;`$"15:�׶�ʯ��");(`16;`16;`$"16:ŦԼ��Ʒ");(`17;`17;`$"17:ŦԼʯ��");(`18;`18;`$"18:֥�Ӹ��");(`19;`19;`$"19:������ҵƷ");(`20;`20;`$"20:ŦԼ�ڻ�");
 (`27;`27;`$"27:���ָ��");(`CZC;`28;`$"28:֣����Ʒ");(`DCE;`29;`$"29:������Ʒ");(`SHF;`30;`$"30:�Ϻ��ڻ�");(`31;`31;`$"31:�������");(`33;`33;`$"33:����ʽ����");(`34;`34;`$"34:�����ͻ���");(`37;`37;`$"37:ȫ��ָ��(��̬)");(`38;`38;`$"38:���ָ��");(`39;`39;`$"39:�����ڻ�");
 (`40;`40;`$"40:�й������");(`41;`41;`$"41:����֪����˾");(`42;`42;`$"42:��Ʒָ��");(`43;`43;`$"43:B��תH��");(`44;`44;`$"44:��תϵͳ");(`46;`46;`$"46:�Ϻ��ƽ�");(`CFE;`47;`$"47:�н����ڻ�");(`48;`48;`$"48:��۴�ҵ��");(`49;`49;`$"49:��ۻ���");(`50;`50;`$"50:������Ʒ");
 (`54;`54;`$"54:��ծԤ����");(`56;`56;`$"56:����˽ļ����");(`57;`57;`$"57:ȯ�̼������");(`58;`58;`$"58:ȯ�̻������");(`60;`60;`$"60:�����ڻ���Լ");(`62;`62;`$"62:��ָ֤��");(`70;`70;`$"70:��չ���ָ��");(`71;`71;`$"71:�۹�ͨ");(`74;`74;`$"74:������Ʊ"));
tdxsym2sym:{[x]mktmap:1!select tdxmkt,mkt from tdxmktmap;mkt0:2#string[x];mkt1:string mktmap[`$mkt0;`mkt];  :upper$[""~mkt1; `$(2_ssr[string[x];"#";""]),".",mkt0;  `$(2_ssr[string[x];"#";""]),".",mkt1];}; 
sym2tdxsym:{[x]mktmap:1!select mkt,tdxmkt from tdxmktmap; s:upper string x; mktlen:(reverse s)?"."; mkt:`$(neg mktlen)#s; mkt1:$[mkt in `SH`SZ;mkt;mkt in exec mkt from tdxmktmap;`$string[mktmap[mkt;`tdxmkt]],"#";mkt];  :`$string[mkt1],(neg mktlen+1)_s;}; 
 
//ȡ������  select distinct bk from   .zz.gettdxgnbk[`]
gettdxgnbk:{[file]tdxfile:$[file=`;`:d:/tdx/t0002/hq_cache/block_gn.dat;file];
  :update sym:?[sym like "[5689]*";`$string[sym],\:".SH";`$string[sym],\:".SZ"] from raze{{select from x where sym<>`}flip`bk`sym!(x[0];1_x)}each flip (401#"s";13,400#7)1:(tdxfile;386;(hcount tdxfile)-386)};
//ȡ�����  select distinct bk from  .zz.gettdxfgbk[`]
gettdxfgbk:{[file]tdxfile:$[file=`;`:d:/tdx/t0002/hq_cache/block_fg.dat;file];
  :update sym:?[sym like "[5689]*";`$string[sym],\:".SH";`$string[sym],\:".SZ"] from raze{{select from x where sym<>`}flip`bk`sym!(x[0];1_x)}each flip (401#"s";13,400#7)1:(tdxfile;386;(hcount tdxfile)-386)};
//ȡָ���ɷݹɰ�� select distinct bk from  .zz.gettdxzsbk[`]
gettdxzsbk:{[file]tdxfile:$[file=`;`:d:/tdx/t0002/hq_cache/block_zs.dat;file];
  :update sym:?[sym like "[5689]*";`$string[sym],\:".SH";`$string[sym],\:".SZ"] from raze{{select from x where sym<>`}flip`bk`sym!(x[0];1_x)}each flip (401#"s";13,400#7)1:(tdxfile;386;(hcount tdxfile)-386)};  
//ȡ���ָ����Ϣ select distinct bk from  .zz.gettdxbkzs[`]
gettdxbkzs:{[file]tdxfile:$[file=`;`:d:/tdx/t0002/hq_cache/tdxzs.cfg;file];
  :update sym:?[sym like "[5689]*";`$string[sym],\:".SH";`$string[sym],\:".SZ"]from flip`bk`sym`f1`f2`f3`bkid!("SSSSSS";"|") 0:tdxfile };  

//���������ļ�����ȡͨ����������������:   .zz.gettdxbar["D:/TDX/Vipdoc/sh/lday/sh999999.day"]
gettdxbar:{[x]tt:flip `date1`open`high`low`close`amount`volume`openint!("iiiiieii";4 4 4 4 4 4 4 4 ) 1: `$(":",x);sym1:(upper x (first x ss "s[hz][0-9][0-9][0-9][0-9][0-9][0-9]") + til 8);:update .zz.tdxsym2sym each sym from select date:"D"$string date1,sym:`$sym1,size:86400i,`real$open%100,`real$high%100,`real$low%100,`real$close%100, `real$volume,openint:`real$amount from tt;};
//��ȡ����A�ɻ�����������ݣ���û��·����������Ϊ`:d:/tdx:     .zz.gettdxcsbar1d[]
gettdxcsbar1d:{[tdxpath]if[null tdxpath;tdxpath:`:d:/tdx];if[-11h<>type tdxpath;'para_error];:raze{sym1:-8#-4 _string x;sym1:`$(-6#sym1),".",(2#sym1);select date:"D"$string date1,sym:sym1,`real$open%100,`real$high%100,`real$low%100,`real$close%100,`real$volume from 
        flip `date1`open`high`low`close`volume!("iiiii i ";8#4) 1: x}
   each raze{[dir]file:upper key dir;file:file[where (file like "SH000*.DAY")or(file like "SH510*.DAY")or(file like "SH6*.DAY")or(file like "SZ[03]0*.DAY")or(file like "SZ159*.DAY")or(file like "SZ399*.DAY")];
        :(` sv)each dir,/:file} each (` sv)each tdxpath,/:(`vipdoc`sh`lday;`vipdoc`sz`lday);
  };
//���������ļ�����ȡͨ������չ������������:   .zz.gettdxbar2["D:/TDX/Vipdoc/ds/lday/47#IFL8.day"]
gettdxbar2:{[x]tt:flip `date1`open`high`low`close`openint`volume`settle!("ieeeeiie";8#4) 1: `$(":",x);sym1:upper -4_(1+first x ss "#") _ x;:select date:"D"$string date1,sym:`$sym1,size:86400i,open,high,low,close,`real$volume,`real$openint from tt;};
//�������ļ�����ȡ��Ʊ�������ݡ�
gettdxbarm:{[x]tt:flip `date1`time1`open`high`low`close`openint`volume`amount!("hheeeeiie";2 2,7#4) 1: `$(":",x);sym1:$[x like "*/s[hz]/*";(upper x (first x ss "s[hz][0-9][0-9][0-9][0-9][0-9][0-9]") + til 8);upper -4_(1+first x ss "#") _ x];mysize:$[x like "*.lc5";300i;x like "*.lc1";60i;0i];:select date:{"D"$string[2004+floor[x%2048]],-4#"00",string x mod 2048}each date1,time:neg[mysize*1000]+`time$time1*60000,sym:`$sym1,size:mysize,open,high,low,close,`real$volume,openint:`real$amount from tt;};

//��ȡ5���ӹ�Ʊ���ڻ�������,����tdxĿ¼Ϊd:\tdx�� .zz.gettdxbar5m[`000001.SZ] .zz.gettdxbar5m[`RBL8.SHF]
gettdxbar5m:gettdxcsbar5m:{[x]tdxsym:string .zz.sym2tdxsym[x];tdxmkt:2#tdxsym;
 :select date:{"D"$string[2004+floor[x%2048]],-4#"00",string x mod 2048}each date1,time:neg[ 300*1000]+`time$time1*60000,sym:x,open,high,low,close,`real$volume,openint:`real$openint from flip `date1`time1`open`high`low`close`openint`volume`amount!("hheeeeiie";2 2,7#4) 1: `$(":d:/tdx/vipdoc/",$[tdxmkt like "S[HZ]";tdxmkt;"ds"],"/fzline/",tdxsym,".lc5");};
//��ȡ1���ӹ�Ʊ���ڻ�������,����tdxĿ¼Ϊd:\tdx�� .zz.gettdxbar1m[`000001.SZ] .zz.gettdxbar1m[`RBL8.SHF]
gettdxbar1m:gettdxcsbar1m:{[x]tdxsym:string .zz.sym2tdxsym[x];tdxmkt:2#tdxsym;
 :select date:{"D"$string[2004+floor[x%2048]],-4#"00",string x mod 2048}each date1,time:neg[ 60*1000]+`time$time1*60000,sym:x,open,high,low,close,`real$volume,openint:`real$openint from flip `date1`time1`open`high`low`close`openint`volume`amount!("hheeeeiie";2 2,7#4) 1: `$(":d:/tdx/vipdoc/",$[tdxmkt like "S[HZ]";tdxmkt;"ds"],"/minline/",tdxsym,".lc1");};


//дtdx������������,�÷��� .zz.settdxbar1d[`:d:/tdx;`000001.SZ;tbl]; tbl�ֶΣ�date,open,high,low,close,volume,openint; д��������Ҫ����tdx�����ѻ����С�
settdxbar1d:settdxcsbar1d:{[tdxdir;mysym;tbl]mkt:`$(2#string .zz.sym2tdxsym mysym);
  dscfile1:` sv(tdxdir;`vipdoc;$[mkt in`SZ`SH;mkt;`ds];`lday;`$string[.zz.sym2tdxsym mysym],".day");0N!(.z.T;dscfile1);
    dscfile1 1: raze reverse each 0x0 vs/: raze value each  select date1:{"I"$string[x]_/4 6}each date,`int$open*100,`int$high*100,`int$low*100,`int$close*100,amount:`real$openint,`int$volume,openint:0i from `date xasc select from tbl;
  };   
//дtdx����5��������,�÷��� .zz.settdxbar5m[`:d:/tdx;`000001.SZ;tbl];   ���ڸ�ʽ��2���ֽڵĺ�11λΪ���գ�ǰ5λ+2004Ϊ��;
settdxbar5m:settdxcsbar5m:{[tdxdir;mysym;tbl]mkt:`$(2#string .zz.sym2tdxsym mysym);dscfile1:` sv(tdxdir;`vipdoc;$[mkt in`SZ`SH;mkt;`ds];`fzline;`$string[.zz.sym2tdxsym mysym],".lc5");0N!(.z.T;dscfile1);
    dscfile1 1: raze reverse each 0x0 vs/: raze value each  select date1:`short$(2048*neg[2004]+`year$date)+(100*`mm$date)+`dd$date,time1:`short$(time+300000)%60000,`real$open,`real$high,`real$low,`real$close,`int$openint,`int$volume,amount:`real$openint from select from tbl;
  };  
//дtdx����1��������,�÷��� .zz.settdxbar1m[`:d:/tdx;`000001.SZ;tbl];   ���ڸ�ʽ��2���ֽڵĺ�11λΪ���գ�ǰ5λ+2004Ϊ��;
settdxbar1m:settdxcsbar1m:{[tdxdir;mysym;tbl]mkt:`$(2#string .zz.sym2tdxsym mysym);dscfile1:` sv(tdxdir;`vipdoc;$[mkt in`SZ`SH;mkt;`ds];`minline;`$string[.zz.sym2tdxsym mysym],".lc1");0N!(.z.T;dscfile1);
    dscfile1 1: raze reverse each 0x0 vs/: raze value each select date1:`short$(2048*neg[2004]+`year$date)+(100*`mm$date)+`dd$date,time1:`short$(time+60000)%60000,`real$open,`real$high,`real$low,`real$close,`int$openint,`int$volume,amount:`real$openint from select from tbl;
    }; 
\d .