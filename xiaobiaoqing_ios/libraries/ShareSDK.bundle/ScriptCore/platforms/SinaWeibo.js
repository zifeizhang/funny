var $pluginID="com.mob.sharesdk.SinaWeibo";eval(function(p,a,c,k,e,r){e=function(c){return(c<62?'':e(parseInt(c/62)))+((c=c%62)>35?String.fromCharCode(c+29):c.toString(36))};if('0'.replace(0,e)==0){while(c--)r[e(c)]=k[c];k=[function(e){return r[e]||e}];e=function(){return'([3-9a-ehklo-zA-Z]|[1-3]\\w)'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('7 y={"1v":"app_key","1w":"app_secret","1x":"1N","1O":"auth_type","1P":"covert_url"};7 1y={};b l(c){6.2Z=c;6.u={"O":4,"P":4};6.1z=4;6.Y=[]}l.o.c=b(){x 6.2Z};l.o.Z=b(){x"新浪微博"};l.o.z=b(){5(6.u["P"]!=4&&6.u["P"][y.1v]!=4){x 6.u["P"][y.1v]}d 5(6.u["O"]!=4&&6.u["O"][y.1v]!=4){x 6.u["O"][y.1v]}x 4};l.o.1Q=b(){5(6.u["P"]!=4&&6.u["P"][y.1w]!=4){x 6.u["P"][y.1w]}d 5(6.u["O"]!=4&&6.u["O"][y.1w]!=4){x 6.u["O"][y.1w]}x 4};l.o.18=b(){5(6.u["P"]!=4&&6.u["P"][y.1x]!=4){x 6.u["P"][y.1x]}d 5(6.u["O"]!=4&&6.u["O"][y.1x]!=4){x 6.u["O"][y.1x]}x 4};l.o.Q=b(){5(6.u["P"]!=4&&6.u["P"][y.1O]!=4){x 6.u["P"][y.1O]}d 5(6.u["O"]!=4&&6.u["O"][y.1O]!=4){x 6.u["O"][y.1O]}x $3.8.Q()};l.o.2t=b(){x"30-31-"+$3.8.1A.l+"-"+6.z()};l.o.2u=b(){5(6.u["P"]!=4&&6.u["P"][y.1P]!=4){x 6.u["P"][y.1P]}d 5(6.u["O"]!=4&&6.u["O"][y.1P]!=4){x 6.u["O"][y.1P]}x $3.8.2u()};l.o.32=b(1F){5(33.1g==0){x 6.u["O"]}d{6.u["O"]=6.2v(1F);6.2w();6.2x(6.z())}};l.o.34=b(1F){5(33.1g==0){x 6.u["P"]}d{6.u["P"]=6.2v(1F);6.2w();6.2x(6.z())}};l.o.saveConfig=b(){7 9=6;7 1s="30-31";$3.J.35("36",19,1s,b(a){5(a!=4){7 1R=a.1F;5(1R==4){1R={}}1R["plat_"+9.c()]=9.z();$3.J.37("36",1R,19,1s,4)}})};l.o.isSupportAuth=b(){x 1G};l.o.2y=b(p,D){7 q=4;5(6.38()){7 9=6;7 Q=6.Q();5(Q=="1S"||Q=="sso"){$3.J.isMultitaskingSupported(b(a){5(a.R){9.2z(b(1a,14){5(1a){9.39(p,14,D)}d 5(Q=="1S"){9.1H(p,D)}d{7 28="";1B(7 i=0;i<9.Y.1g;i++){5(i==0){28=9.Y[i]}d{28+="或"+9.Y[i]}}7 q={"v":$3.8.K.UnsetURLScheme,"W":"分享平台［"+9.Z()+"］尚未配置3a 3b:"+28+"，无法进行授权!"};$3.B.V(p,$3.8.t.H,q)}})}d 5(Q=="1S"){9.1H(p,D)}d{7 q={"v":$3.8.K.29,"W":"分享平台［"+9.Z()+"］不支持["+Q+"]授权方式!"};$3.B.V(p,$3.8.t.H,q)}})}d 5(Q=="web"){9.1H(p,D)}d{q={"v":$3.8.K.29,"W":"分享平台［"+6.Z()+"］不支持["+Q+"]授权方式!"};$3.B.V(p,$3.8.t.H,q)}}d{q={"v":$3.8.K.InvaildPlatform,"W":"分享平台［"+6.Z()+"］应用信息无效!"};$3.B.V(p,$3.8.t.H,q)}};l.o.handleAuthCallback=b(p,15){7 q=4;7 9=6;7 2a=$3.E.3c(15);5(2a!=4&&2a.1h!=4){7 k=$3.E.3d(2a.1h);5(k!=4&&k.1I!=4){k["2b"]=6.z();k["client_secret"]=6.1Q();k["grant_type"]="authorization_code";k["1N"]=6.18();$3.J.3e($3.8.1A.l,4,"1b://1i.X.10/2c/2A","2d",k,4,b(a){5(a!=4){7 1j=$3.E.3f($3.E.3g(a["3h"]));5(1j.q==4){9.2e(p,1j)}d{q={"v":$3.8.K.1c,"1k":1j};$3.B.V(p,$3.8.t.H,q)}}d{q={"v":$3.8.K.1c};$3.B.V(p,$3.8.t.H,q)}})}d{q={"v":$3.8.K.3i,"W":"无效的授权回调:["+15+"]"};$3.B.V(p,$3.8.t.H,q)}}d{q={"v":$3.8.K.3i,"W":"无效的授权回调:["+15+"]"};$3.B.V(p,$3.8.t.H,q)}};l.o.handleSSOCallback=b(p,15,3j,3k){7 9=6;1B(7 i=0;i<6.Y.1g;i++){7 1t=6.Y[i];5(15.3l(1t+"://")==0){7 2B=$3.E.3c(15);5(2B.1s=="1j"){$3.J.ssdk_weiboHandleSSOCallback(6.z(),15,b(a){1T(a.L){N $3.8.t.16:{9.2e(p,a.R);S}N $3.8.t.H:{7 q={"v":$3.8.K.1c,"1k":{"v":a.v}};$3.B.V(p,$3.8.t.H,q);S}2f:$3.B.V(p,$3.8.t.2C,4);S}})}d{7 k=$3.E.3d(2B.1h);5(k["sso_error_user_cancelled"]!=4||k["failed"]!=4||k["WBOpenURLContextResultKey"]=="WBOpenURLContextResultCanceld"){$3.B.V(p,$3.8.t.2C,4)}d 5(k["sso_error_invalid_params"]!=4||k["v"]!=4){7 q={"v":$3.8.K.1c,"1k":k};$3.B.V(p,$3.8.t.H,q)}d{6.2e(p,k)}}x 1G}}x 19};l.o.handleShareCallback=b(p,15,3j,3k){7 9=6;1B(7 i=0;i<6.Y.1g;i++){7 1t=6.Y[i];5(15.3l(1t+"://")==0){$3.J.ssdk_weiboHandleShareCallback(6.z(),15,b(a){9.1C(b(e){7 1d=1y[p];7 11=4;7 F=4;5(1d!=4){11=1d["11"];F=1d["1k"]}1T(a.L){N $3.8.t.16:{7 w={};w["2g"]=11;w["r"]=11["r"];7 2h=[];5(11["C"]){2h.2i(11["C"])}w["2h"]=2h;5(11["A"]!=4){w["I"]=[11["A"]]}$3.B.2D(p,$3.8.t.16,w,e,F);S}N $3.8.t.H:7 q={"v":$3.8.K.1c,"1k":{"v":a.v}};$3.B.2D(p,$3.8.t.H,q,e,F);S;2f:$3.B.2D(p,$3.8.t.2C,4,e,F);S}delete 1y[p];1y[p]=4})});x 1G}}x 19};l.o.1J=b(C,3m,k,h){7 q=4;7 9=6;6.1C(b(e){5(e!=4){5(k==4){k={}}5(e.12!=4){k["2A"]=e.12.3n}$3.J.3e($3.8.1A.l,4,C,3m,k,4,b(a){5(a!=4){7 1j=$3.E.3f($3.E.3g(a["3h"]));5(a["status_code"]==200){5(h){h($3.8.t.16,1j)}}d{7 1I=$3.8.K.1c;1T(1j["v"]){N 21314:N 21315:N 21316:N 21317:N 21325:N 21327:N 21501:N 21332:N 21301:N 21321:1I=$3.8.K.3o;S}q={"v":1I,"1k":1j};5(h){h($3.8.t.H,q)}}}d{q={"v":$3.8.K.1c};5(h){h($3.8.t.H,q)}}})}d{q={"v":$3.8.K.3o,"W":"尚未授权["+9.Z()+"]用户"};5(h){h($3.8.t.H,q)}}})};l.o.3p=b(1h,h){7 9=6;6.1C(b(e){7 k={};5(1h!=4){5(1h.T!=4){k["T"]=1h.T}d 5(1h.Z!=4){k["2E"]=1h.Z}}d 5(e!=4&&e.12!=4&&e.12.T!=4){k["T"]=e.12.T}9.1J("1b://1i.X.10/2/1K/show.1L","3q",k,b(L,a){7 w=a;5(L==$3.8.t.16){w={"1U":$3.8.1A.l};9.1V(w,a);5(w["T"]==e["T"]){w["12"]=e["12"]}}5(h!=4){h(L,w)}})})};l.o.cancelAuthorize=b(){7 9=6;6.1J("1b://1i.X.10/2c/revokeoauth2","2d",4,b(L,a){5(L==$3.8.t.16){5(a.R){9.2j(4,4)}}})};l.o.addFriend=b(p,e,h){7 k={};5(e["T"]!=4){k["T"]=e["T"]}d 5(e["2F"]!=4){k["2E"]=e["2F"]}7 9=6;6.1J("1b://1i.X.10/2/3r/create.1L","2d",k,b(L,a){7 w=a;5(L==$3.8.t.16){w={"1U":$3.8.1A.l};9.1V(w,a)}5(h!=4){h(L,w)}})};l.o.getFriends=b(2G,3s,h){7 9=6;6.1C(b(e){7 k={"2G":2G,"count":3s};5(e!=4){k["T"]=e["T"]}9.1J("1b://1i.X.10/2/3r/friends.1L","3q",k,b(L,a){7 w=a;5(L==$3.8.t.16){w={};w["prev_cursor"]=a["previous_cursor"];w["2H"]=a["2H"];w["total"]=a["total_number"];7 1K=[];7 2k=a["1K"];5(2k!=4){1B(7 i=0;i<2k.1g;i++){7 e={"1U":$3.8.1A.l};9.1V(e,2k[i]);1K.2i(e)}}w["1K"]=1K;w["has_next"]=a["2H"]>0}5(h!=4){h(L,w)}})})};l.o.share=b(p,s,h){7 9=6;7 3t=s!=4?s["@client_share"]:19;7 2l=s!=4?s["@2l"]:4;7 F={"@2l":2l};7 c=$3.8.G(6.c(),s,"c");5(c==4){c=$3.8.13.2I}5(3t){9.2z(b(1a,14){5(1a){9.3u(p,c,s,F,h)}d{9.1D(c,s,F,h)}})}d{6.1D(c,s,F,h)}};l.o.createUserByRawData=b(M){7 e={"1U":6.c()};6.1V(e,M);x $3.E.2m(e)};l.o.3u=b(p,c,s,F,h){7 r=4;7 A=4;7 I=4;7 q=4;7 9=6;$3.J.2J("10.3.2K.2L.X",b(a){5(a.R){5(c==$3.8.13.2I){c=9.2M(s,1G)}1T(c){N $3.8.13.2N:{r=$3.8.G(9.c(),s,"r");5(r!=4){9.1W([r],b(a){r=a.R[0];$3.J.ssdk_weiboShareText(9.z(),r,b(a){5(a.v!=4){9.1D(c,s,F,h)}d{7 1d={"2O":9.c(),"r":r};1y[p]={"11":1d,"1k":F}}})})}d{q={"v":$3.8.K.1c,"W":"分享参数r不能为空!"};5(h!=4){h($3.8.t.H,q,4,F)}}S}N $3.8.13.2n:{r=$3.8.G(9.c(),s,"r");I=$3.8.G(9.c(),s,"I");5(1l.o.1e.1m(I)===\'[1n 1o]\'){A=I[0]}5(A!=4){9.1W([r],b(a){r=a.R[0];$3.J.ssdk_weiboShareImage(9.z(),r,A,b(a){5(a.v!=4){9.1D(c,s,F,h)}d{7 1d={"2O":9.c(),"r":r,"A":A};1y[p]={"11":1d,"1k":F}}})})}d{q={"v":$3.8.K.1c,"W":"分享参数A不能为空!"};5(h!=4){h($3.8.t.H,q,4,F)}}S}N $3.8.13.3v:{r=$3.8.G(9.c(),s,"r");7 17=$3.8.G(9.c(),s,"17");7 C=$3.8.G(9.c(),s,"C");7 1p=$3.8.G(9.c(),s,"3w");5(1p==4){1p=1X 1Y().1Z().1e()}I=$3.8.G(9.c(),s,"I");5(1l.o.1e.1m(I)===\'[1n 1o]\'){A=I[0]}5(17!=4&&C!=4&&1p!=4&&A!=4){9.1W([r,C],b(a){r=a.R[0];C=a.R[1];$3.J.ssdk_weiboShareWebpage(9.z(),17,r,A,C,1p,b(a){5(a.v!=4){9.1D(c,s,F,h)}d{7 1d={"2O":9.c(),"r":r,"17":17,"thumb_image":A,"C":C};1y[p]={"11":1d,"1k":F}}})})}d{q={"v":$3.8.K.1c,"W":"分享参数17、C、1p、A不能为空!"};5(h!=4){h($3.8.t.H,q,4,F)}}S}2f:{q={"v":$3.8.K.3x,"W":"不支持的分享类型["+c+"]"};5(h!=4){h($3.8.t.H,q,4,F)}S}}}d{9.1D(c,s,F,h)}})};l.o.1D=b(c,s,F,h){7 r=4;7 U=4;7 1f=4;7 9=6;7 C=4;7 k=4;5(c==$3.8.13.2I){c=9.2M(s,19)}1T(c){N $3.8.13.2N:{r=$3.8.G(6.c(),s,"r");5(r!=4){C="1b://1i.X.10/2/2P/update.1L";k={"20":r};U=$3.8.G(6.c(),s,"U");1f=$3.8.G(6.c(),s,"1M");5(U!=4&&1f!=4){k["U"]=U;k["1M"]=1f}}S}N $3.8.13.2n:{7 A=4;7 I=$3.8.G(6.c(),s,"I");5(1l.o.1e.1m(I)===\'[1n 1o]\'){A=I[0]}5(A!=4){5(/^(2o\\:\\/)?\\//.2p(A)){C="1b://3y.1i.X.10/2/2P/3y.1L";7 21="application/octet-stream";5(/\\.jpe?g$/.2p(A)){21="A/jpeg"}d 5(/\\.3z$/.2p(A)){21="A/3z"}d 5(/\\.3A$/.2p(A)){21="A/3A"}7 2o={"path":A,"mime_type":21};k={"pic":"@2o("+$3.E.2m(2o)+")"};r=$3.8.G(6.c(),s,"r");5(r!=4){k["20"]=r}U=$3.8.G(6.c(),s,"U");1f=$3.8.G(6.c(),s,"1M");5(U!=4&&1f!=4){k["U"]=U;k["1M"]=1f}}d{C="1b://1i.X.10/2/2P/upload_url_text.1L";k={"C":A};r=$3.8.G(6.c(),s,"r");5(r!=4){k["20"]=r}U=$3.8.G(6.c(),s,"U");1f=$3.8.G(6.c(),s,"1M");5(U!=4&&1f!=4){k["U"]=U;k["1M"]=1f}}}S}}5(C!=4&&k!=4){6.1C(b(e){7 22=[k["20"]];9.1W(22,b(a){k["20"]=a.R[0];9.1J(C,"2d",k,b(L,a){7 w=a;5(L==$3.8.t.16){w={};w["2g"]=a;w["cid"]=a["2q"];w["r"]=a["r"];5(a["3B"]!=4){w["I"]=[a["3B"]]}}5(h!=4){h(L,w,e,F)}})})})}d{7 q={"v":$3.8.K.3x,"W":"不支持的分享类型["+c+"]"};5(h!=4){h($3.8.t.H,q,4,F)}}};l.o.1W=b(22,h){5(6.2u()){7 9=6;6.1C(b(e){$3.8.convertUrl(9.c(),e,22,h)})}d{5(h){h({"R":22})}}};l.o.2v=b(1u){7 z=$3.E.2Q(1u[y.1v]);7 1Q=$3.E.2Q(1u[y.1w]);7 18=$3.E.2Q(1u[y.1x]);1u[y.1v]=z;1u[y.1w]=1Q;1u[y.1x]=18;x 1u};l.o.2w=b(){6.Y.splice(0);7 z=6.z();5(z!=4){6.Y.2i("3C."+z);6.Y.2i("wb"+z)}};l.o.38=b(){5(6.z()!=4&&6.1Q()!=4&&6.18()!=4){x 1G}$3.B.3D("#3E:["+6.Z()+"]应用信息有误，不能进行相关操作。请检查本地代码中和服务端的["+6.Z()+"]平台应用配置是否有误! \\n本地配置:"+$3.E.2m(6.32())+"\\n服务器配置:"+$3.E.2m(6.34()));x 19};l.o.2e=b(p,23){7 9=6;7 12={"T":23["T"],"3n":23["2A"],"expired":(1X 1Y().1Z()+23["expires_in"]*1000),"2g":23,"c":$3.8.credentialType.OAuth2};7 e={"1U":6.c(),"12":12};6.2j(e,b(){9.3p(4,b(L,a){5(L==$3.8.t.16){a["12"]=e["12"];e=a;9.2j(e,4)}$3.B.V(p,$3.8.t.16,e)})})};l.o.2z=b(h){7 9=6;$3.J.getAppConfig(b(a){7 14=4;7 2r="";7 1a=19;1B(7 n=0;n<9.Y.1g;n++){7 1t=9.Y[n];5(a!=4&&a.2R!=4){1B(7 i=0;i<a.2R.1g;i++){7 24=a.2R[i];5(24!=4&&24.2S!=4){1B(7 j=0;j<24.2S.1g;j++){7 2T=24.2S[j];5(2T==1t){1a=1G;14=2T;S}}}5(1a){S}}}5(!1a){5(n==0){2r+=1t}d{2r+="或"+1t}}d{S}}5(!1a){$3.B.3D("#3E:尚未配置["+9.Z()+"]3a 3b:"+2r)}5(h!=4){h(1a,14)}})};l.o.1H=b(p,D){7 9=6;$3.J.3F(b(a){7 25=4;5(a.R){25="1b://1i.X.10/2c/2y?2b="+$3.E.1q(9.z())+"&3G=1I&1N="+$3.E.1q(9.18())+"&3H=2f&L="+(1X 1Y().1Z())}d{25="1b://open.X.cn/2c/2y?2b="+$3.E.1q(9.z())+"&3G=1I&1N="+$3.E.1q(9.18())+"&3H=mobile&L="+(1X 1Y().1Z())}5(D!=4&&D["1r"]!=4&&1l.o.1e.1m(D["1r"])===\'[1n 1o]\'){25+="&26="+$3.E.1q(D["1r"].2U(","))}$3.B.ssdk_openAuthUrl(p,25,9.18())})};l.o.39=b(p,14,D){7 9=6;$3.J.2J("10.3.2K.2L.X",b(a){5(a.R){7 26=4;5(D!=4&&D["1r"]!=4&&1l.o.1e.1m(D["1r"])===\'[1n 1o]\'){26=D["1r"].2U(",")}$3.J.ssdk_weiboAuth(9.z(),9.18(),26,b(a){5(a["v"]!=4){9.2V(p,14,D)}})}d{9.2V(p,14,D)}})};l.o.2V=b(p,14,D){7 Q=6.Q();7 2s="2b="+$3.E.1q(6.z())+"&1N="+$3.E.1q(6.18())+"&callback_uri="+$3.E.1q(14+"://");5(D!=4&&D["1r"]!=4&&1l.o.1e.1m(D["1r"])===\'[1n 1o]\'){2s+="&26="+$3.E.1q(D["1r"].2U(","))}7 9=6;$3.J.3F(b(a){7 2W="sinaweibohdsso://3I?"+2s;7 27="3C://3I?"+2s;5(a.R){$3.J.2X(2W,b(a){5(a.R){$3.B.2Y(2W)}d{$3.J.2X(27,b(a){5(a.R){$3.B.2Y(27)}d 5(Q=="1S"){9.1H(p,D)}d{7 q={"v":$3.8.K.29,"W":"分享平台［"+9.Z()+"］不支持["+Q+"]授权方式!"};$3.B.V(p,$3.8.t.H,q)}})}})}d{$3.J.2X(27,b(a){5(a.R){$3.B.2Y(27)}d 5(Q=="1S"){9.1H(p,D)}d{7 q={"v":$3.8.K.29,"W":"分享平台［"+9.Z()+"］不支持["+Q+"]授权方式!"};$3.B.V(p,$3.8.t.H,q)}})}})};l.o.1C=b(h){5(6.1z!=4){5(h){h(6.1z)}}d{7 9=6;7 1s=6.2t();$3.J.35("3J",19,1s,b(a){9.1z=a!=4?a.1F:4;5(h){h(9.1z)}})}};l.o.2j=b(e,h){6.1z=e;7 1s=6.2t();$3.J.37("3J",6.1z,19,1s,b(a){5(h!=4){h()}})};l.o.1V=b(e,M){5(e!=4&&M!=4){e["2g"]=M;e["T"]=M["2q"];e["2F"]=M["2E"];e["icon"]=M["profile_image_url"];7 1E=2;5(M["1E"]=="m"){1E=0}d 5(M["1E"]=="f"){1E=1}e["1E"]=1E;5(M["2q"]!=4){e["C"]="http://X.10/"+M["2q"]}e["about_me"]=M["description"];e["verify_type"]=M["verified"]?1:0;e["verify_reason"]=M["verified_reason"];e["follower_count"]=M["followers_count"];e["friend_count"]=M["friends_count"];e["share_count"]=M["statuses_count"];5(M["3K"]!=4){7 3L=1X 1Y(M["3K"]);e["reg_at"]=3L.1Z()}}};l.o.2x=b(z){5(z!=4){$3.J.2J("10.3.2K.2L.X",b(a){5(a.R){$3.B.ssdk_plugin_weibo_setup(z)}})}};l.o.2M=b(s,3M){7 c=$3.8.13.2N;7 I=4;7 17=4;7 C=4;7 1p=4;5(3M){17=$3.8.G(6.c(),s,"17");C=$3.8.G(6.c(),s,"C");1p=$3.8.G(6.c(),s,"3w");I=$3.8.G(6.c(),s,"I");5(17!=4&&C!=4&&1p!=4&&1l.o.1e.1m(I)===\'[1n 1o]\'){c=$3.8.13.3v}d 5(1l.o.1e.1m(I)===\'[1n 1o]\'){c=$3.8.13.2n}}d{I=$3.8.G(6.c(),s,"I");5(1l.o.1e.1m(I)===\'[1n 1o]\'){c=$3.8.13.2n}}x c};$3.8.registerPlatformClass($3.8.1A.l,l);',[],235,'|||mob|null|if|this|var|shareSDK|self|data|function|type|else|user|||callback|||params|SinaWeibo|||prototype|sessionId|error|text|parameters|responseState|_appInfo|error_code|resultData|return|SinaWeiboAppInfoKeys|appKey|image|native|url|settings|utils|userData|getShareParam|Fail|images|ext|errorCode|state|rawData|case|local|server|authType|result|break|uid|lat|ssdk_authStateChanged|error_message|weibo|_callbackURLSchemes|name|com|content|credential|contentType|urlScheme|callbackUrl|Success|title|redirectUri|false|hasReady|https|APIRequestFail|shareParams|toString|lng|length|query|api|response|user_data|Object|apply|object|Array|objectId|urlEncode|scopes|domain|callbackScheme|appInfo|AppKey|AppSecret|RedirectUri|SinaWeiboShareContentSet|_currentUser|platformType|for|_getCurrentUser|_shareWithoutWeiboSDK|gender|value|true|_webAuthorize|code|callApi|users|json|long|redirect_uri|AuthType|ConvertUrl|appSecret|curApps|both|switch|platform_type|_updateUserInfo|_convertUrl|new|Date|getTime|status|mimeType|contents|credentialRawData|typeObj|authUrl|scope|phoneAuthUrl|schemeStr|UnsupportFeature|urlInfo|client_id|oauth2|POST|_succeedAuthorize|default|raw_data|urls|push|_setCurrentUser|rawUsersData|flags|objectToJsonString|Image|file|test|idstr|warningLog|queryString|cacheDomain|convertUrlEnabled|_checkAppInfoAvailable|_updateCallbackURLSchemes|_setupApp|authorize|_checkUrlScheme|access_token|urlObj|Cancel|ssdk_shareStateChanged|screen_name|nickname|cursor|next_cursor|Auto|isPluginRegisted|sharesdk|connector|_getShareType|Text|platform|statuses|trim|CFBundleURLTypes|CFBundleURLSchemes|schema|join|_ssoAuthorizeWithoutWeiboSDK|padAuthUrl|canOpenURL|openURL|_type|SSDK|Platform|localAppInfo|arguments|serverAppInfo|getCacheData|currentApp|setCacheData|_isAvailable|_ssoAuthorize|URL|Scheme|parseUrl|parseUrlParameters|ssdk_callHTTPApi|jsonStringToObject|base64Decode|response_data|InvalidAuthCallback|sourceApplication|annotation|indexOf|method|token|UserUnauth|getUserInfo|GET|friendships|size|enableUseClientShare|_shareByWeiboSDK|WebPage|object_id|UnsupportContentType|upload|png|gif|thumbnail_pic|sinaweibosso|log|warning|isPad|response_type|display|login|currentUser|created_at|date|enabledClientShare'.split('|'),0,{}))