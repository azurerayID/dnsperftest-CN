#!/usr/bin/env bash

command -v bc > /dev/null || { echo "bc was not found. Please install bc."; exit 1; }
{ command -v drill > /dev/null && dig=drill; } || { command -v dig > /dev/null && dig=dig; } || { echo "dig was not found. Please install dnsutils."; exit 1; }



NAMESERVERS=`cat /etc/resolv.conf | grep ^nameserver | cut -d " " -f 2 | sed 's/\(.*\)/&#&/'`

PROVIDERS="
2a06:98c0:360d::
2a06:98c0:360c::
2a06:98c0:360a::
2a06:98c0:3609::
2a06:98c0:3608::
2a06:98c0:3607::
2a06:98c0:3606::
2a06:98c0:3605::
2a06:98c0:3604::
2a06:98c0:3603::
2a06:98c0:3602::
2a06:98c0:3601::
2a06:98c0:3600::
2a06:98c0:1401::
2a06:98c0:1400::
2a06:98c0:1001::
2a06:98c0:1000::
2803:f800:50::
2606:54c0:c000::
2606:54c0::
2606:54c0:8000::
2606:54c0:4000::
2606:4700:ff02::
2606:4700:ff01::
2606:4700:f5::
2606:4700:f4::
2606:4700:f2::
2606:4700:f1::
2606:4700:f0::
2606:4700:e6::
2606:4700:e4::
2606:4700:e2::
2606:4700:e0::
2606:4700:d1::
2606:4700:d0::
2606:4700:d0::
2606:4700:c0::
2606:4700:a9::
2606:4700:a8::
2606:4700:a1::
2606:4700:a0::
2606:4700::
2606:4700::
2606:4700:9ae0::
2606:4700:976b::
2606:4700:976a::
2606:4700:9769::
2606:4700:9768::
2606:4700:9767::
2606:4700:9766::
2606:4700:9765::
2606:4700:9764::
2606:4700:9763::
2606:4700:9762::
2606:4700:9761::
2606:4700:9760::
2606:4700:9760::
2606:4700:9640::
2606:4700:91bb::
2606:4700:91ba::
2606:4700:91b9::
2606:4700:91b8::
2606:4700:91b7::
2606:4700:91b6::
2606:4700:91b2::
2606:4700:91b1::
2606:4700:91b0::
2606:4700:91b0::
2606:4700:90db::
2606:4700:90da::
2606:4700:90d8::
2606:4700:90d7::
2606:4700:90d6::
2606:4700:90d5::
2606:4700:90d4::
2606:4700:90d3::
2606:4700:90d2::
2606:4700:90d1::
2606:4700:90d0::
2606:4700:90d0::
2606:4700:90c0::
2606:4700:90::
2606:4700:8de0::
2606:4700:8dd0::
2606:4700:8d90::
2606:4700:8d70::
2606:4700:8caf::
2606:4700:8cae::
2606:4700:8cad::
2606:4700:8cac::
2606:4700:8cab::
2606:4700:8caa::
2606:4700:8ca8::
2606:4700:8ca6::
2606:4700:8ca5::
2606:4700:8ca4::
2606:4700:8ca3::
2606:4700:8ca2::
2606:4700:8ca1::
2606:4700:8ca0::
2606:4700:8ca0::
2606:4700:85d0::
2606:4700:85c0::
2606:4700:83b2::
2606:4700:83b1::
2606:4700:83b0::
2606:4700:83b0::
2606:4700:8393::
2606:4700:8392::
2606:4700:8391::
2606:4700:8390::
2606:4700:8390::
2606:4700:81cf::
2606:4700:81ce::
2606:4700:81cd::
2606:4700:81cc::
2606:4700:81cb::
2606:4700:81ca::
2606:4700:81c9::
2606:4700:81c8::
2606:4700:81c7::
2606:4700:81c6::
2606:4700:81c5::
2606:4700:81c4::
2606:4700:81c0::
2606:4700:80f9::
2606:4700:80f8::
2606:4700:80f7::
2606:4700:80f6::
2606:4700:80f5::
2606:4700:80f4::
2606:4700:80f0::
2606:4700:80cf::
2606:4700:80ce::
2606:4700:80cd::
2606:4700:80cc::
2606:4700:80cb::
2606:4700:80ca::
2606:4700:80c9::
2606:4700:80c8::
2606:4700:80c7::
2606:4700:80c6::
2606:4700:80c5::
2606:4700:80c4::
2606:4700:80c0::
2606:4700:80::
2606:4700:804f::
2606:4700:804e::
2606:4700:804d::
2606:4700:804c::
2606:4700:804b::
2606:4700:804a::
2606:4700:8049::
2606:4700:8048::
2606:4700:8047::
2606:4700:8046::
2606:4700:8045::
2606:4700:8044::
2606:4700:8040::
2606:4700:70::
2606:4700:7000::
2606:4700:60::
2606:4700:5c::
2606:4700:5a::
2606:4700:56::
2606:4700:54::
2606:4700:52::
2606:4700:50::
2606:4700:4700::
2606:4700:440f::
2606:4700:440e::
2606:4700:440d::
2606:4700:440c::
2606:4700:440b::
2606:4700:440a::
2606:4700:4409::
2606:4700:4408::
2606:4700:4407::
2606:4700:4406::
2606:4700:4405::
2606:4700:4404::
2606:4700:4403::
2606:4700:4402::
2606:4700:4401::
2606:4700:4400::
2606:4700:42c8::
2606:4700:4018::
2606:4700:4010::
2606:4700:4008::
2606:4700:4000::
2606:4700:3131::
2606:4700:310c::
2606:4700:3108::
2606:4700:3056::
2606:4700:3055::
2606:4700:303c::
2606:4700:3039::
2606:4700:3038::
2606:4700:3037::
2606:4700:3036::
2606:4700:3035::
2606:4700:3034::
2606:4700:3033::
2606:4700:3032::
2606:4700:3031::
2606:4700:3030::
2606:4700:3030::
2606:4700:302c::
2606:4700:3029::
2606:4700:3028::
2606:4700:3027::
2606:4700:3026::
2606:4700:3025::
2606:4700:3024::
2606:4700:3023::
2606:4700:3022::
2606:4700:3021::
2606:4700:3020::
2606:4700:3020::
2606:4700:301c::
2606:4700:3019::
2606:4700:3018::
2606:4700:3017::
2606:4700:3016::
2606:4700:3015::
2606:4700:3014::
2606:4700:3013::
2606:4700:3012::
2606:4700:3011::
2606:4700:3010::
2606:4700:3010::
2606:4700:300c::
2606:4700:300b::
2606:4700:300a::
2606:4700:3009::
2606:4700:3008::
2606:4700:3007::
2606:4700:3006::
2606:4700:3005::
2606:4700:3004::
2606:4700:3003::
2606:4700:3002::
2606:4700:3001::
2606:4700:3000::
2606:4700:3000::
2606:4700:21::
2606:4700:20::
2606:4700:2001::
2606:4700:1::
2606:4700:130::
2606:4700:11::
2606:4700:1100::
2606:4700:10f::
2606:4700:10::
2606:4700:101::
2606:4700:100::
2405:b500:4000::
2405:8100:8005::
2400:cb00:f00e::
2400:cb00:ab92::
2400:cb00:ab91::
2400:cb00:ab90::
2400:cb00:aae1::
2400:cb00:aa91::
2400:cb00:aa90::
2400:cb00:aa23::
2400:cb00:aa20::
2400:cb00:a9f1::
2400:cb00:a9f0::
2400:cb00:a9a2::
2400:cb00:a9a1::
2400:cb00:a9a0::
2400:cb00:a982::
2400:cb00:a981::
2400:cb00:a980::
2400:cb00:a972::
2400:cb00:a971::
2400:cb00:a970::
2400:cb00:a941::
2400:cb00:a940::
2400:cb00:a8f1::
2400:cb00:a8f0::
2400:cb00:a881::
2400:cb00:a880::
2400:cb00:a875::
2400:cb00:a874::
2400:cb00:a873::
2400:cb00:a872::
2400:cb00:a871::
2400:cb00:a870::
2400:cb00:a840::
2400:cb00:a821::
2400:cb00:a820::
2400:cb00:a805::
2400:cb00:a804::
2400:cb00:a803::
2400:cb00:a802::
2400:cb00:a801::
2400:cb00:a800::
2400:cb00:a7d3::
2400:cb00:a7d2::
2400:cb00:a7d1::
2400:cb00:a7d0::
2400:cb00:a7b0::
2400:cb00:a774::
2400:cb00:a771::
2400:cb00:a744::
2400:cb00:a743::
2400:cb00:a742::
2400:cb00:a740::
2400:cb00:a727::
2400:cb00:a726::
2400:cb00:a725::
2400:cb00:a724::
2400:cb00:a723::
2400:cb00:a722::
2400:cb00:a721::
2400:cb00:a710::
2400:cb00:a6b2::
2400:cb00:a6b1::
2400:cb00:a6b0::
2400:cb00:a6a6::
2400:cb00:a6a4::
2400:cb00:a6a3::
2400:cb00:a6a2::
2400:cb00:a6a0::
2400:cb00:a644::
2400:cb00:a643::
2400:cb00:a642::
2400:cb00:a641::
2400:cb00:a640::
2400:cb00:a626::
2400:cb00:a625::
2400:cb00:a623::
2400:cb00:a622::
2400:cb00:a621::
2400:cb00:a620::
2400:cb00:a601::
2400:cb00:a600::
2400:cb00:a596::
2400:cb00:a595::
2400:cb00:a594::
2400:cb00:a593::
2400:cb00:a592::
2400:cb00:a590::
2400:cb00:a581::
2400:cb00:a571::
2400:cb00:a570::
2400:cb00:a550::
2400:cb00:a542::
2400:cb00:a541::
2400:cb00:a540::
2400:cb00:a4f2::
2400:cb00:a4f1::
2400:cb00:a4f0::
2400:cb00:a4e5::
2400:cb00:a4e4::
2400:cb00:a4e3::
2400:cb00:a4e2::
2400:cb00:a4e1::
2400:cb00:a4e0::
2400:cb00:a4c1::
2400:cb00:a4c0::
2400:cb00:a4b3::
2400:cb00:a4b2::
2400:cb00:a4b1::
2400:cb00:a4b0::
2400:cb00:a4a5::
2400:cb00:a4a4::
2400:cb00:a4a3::
2400:cb00:a4a2::
2400:cb00:a4a1::
2400:cb00:a4a0::
2400:cb00:a484::
2400:cb00:a483::
2400:cb00:a482::
2400:cb00:a481::
2400:cb00:a480::
2400:cb00:a465::
2400:cb00:a464::
2400:cb00:a463::
2400:cb00:a462::
2400:cb00:a461::
2400:cb00:a460::
2400:cb00:a434::
2400:cb00:a433::
2400:cb00:a432::
2400:cb00:a431::
2400:cb00:a430::
2400:cb00:a414::
2400:cb00:a413::
2400:cb00:a412::
2400:cb00:a411::
2400:cb00:a410::
2400:cb00:a343::
2400:cb00:a342::
2400:cb00:a341::
2400:cb00:a340::
2400:cb00:a325::
2400:cb00:a324::
2400:cb00:a323::
2400:cb00:a322::
2400:cb00:a321::
2400:cb00:a320::
2400:cb00:a316::
2400:cb00:a315::
2400:cb00:a314::
2400:cb00:a313::
2400:cb00:a312::
2400:cb00:a311::
2400:cb00:a310::
2400:cb00:a304::
2400:cb00:a302::
2400:cb00:a301::
2400:cb00:a300::
2400:cb00:a2f2::
2400:cb00:a2f1::
2400:cb00:a2f0::
2400:cb00:a2e1::
2400:cb00:a2e0::
2400:cb00:a2d1::
2400:cb00:a2d0::
2400:cb00:a2c2::
2400:cb00:a2c0::
2400:cb00:a2b1::
2400:cb00:a2b0::
2400:cb00:a261::
2400:cb00:a260::
2400:cb00:a1f4::
2400:cb00:a1f3::
2400:cb00:a1f2::
2400:cb00:a1f1::
2400:cb00:a1f0::
2400:cb00:a1c7::
2400:cb00:a1c6::
2400:cb00:a1c5::
2400:cb00:a1c4::
2400:cb00:a1c3::
2400:cb00:a1c2::
2400:cb00:a1c1::
2400:cb00:a1c0::
2400:cb00:a1b6::
2400:cb00:a1b5::
2400:cb00:a1b4::
2400:cb00:a1b3::
2400:cb00:a1b2::
2400:cb00:a1b1::
2400:cb00:a1b0::
2400:cb00:a1a2::
2400:cb00:a1a1::
2400:cb00:a1a0::
2400:cb00:a174::
2400:cb00:a173::
2400:cb00:a171::
2400:cb00:a170::
2400:cb00:a146::
2400:cb00:a144::
2400:cb00:a143::
2400:cb00:a142::
2400:cb00:a141::
2400:cb00:a140::
2400:cb00:a136::
2400:cb00:a135::
2400:cb00:a134::
2400:cb00:a133::
2400:cb00:a132::
2400:cb00:a131::
2400:cb00:a130::
2400:cb00:a0f7::
2400:cb00:a0f5::
2400:cb00:a0f4::
2400:cb00:a0f3::
2400:cb00:a0f2::
2400:cb00:a0f1::
2400:cb00:a0f0::
2400:cb00:98::
2400:cb00:97::
2400:cb00:96::
2400:cb00:95::
2400:cb00:94::
2400:cb00:90::
2400:cb00:89::
2400:cb00:88::
2400:cb00:87::
2400:cb00:86::
2400:cb00:85::
2400:cb00:84::
2400:cb00:83::
2400:cb00:81::
2400:cb00:80::
2400:cb00:79::
2400:cb00:78::
2400:cb00:77::
2400:cb00:76::
2400:cb00:75::
2400:cb00:74::
2400:cb00:73::
2400:cb00:72::
2400:cb00:71::
2400:cb00:70::
2400:cb00:69::
2400:cb00:68::
2400:cb00:67::
2400:cb00:66::
2400:cb00:65::
2400:cb00:64::
2400:cb00:63::
2400:cb00:61::
2400:cb00:60::
2400:cb00:59::
2400:cb00:57::
2400:cb00:56::
2400:cb00:569::
2400:cb00:55::
2400:cb00:54::
2400:cb00:53::
2400:cb00:52::
2400:cb00:51::
2400:cb00:50::
2400:cb00:4::
2400:cb00:49::
2400:cb00:498::
2400:cb00:493::
2400:cb00:492::
2400:cb00:491::
2400:cb00:490::
2400:cb00:48::
2400:cb00:489::
2400:cb00:488::
2400:cb00:487::
2400:cb00:482::
2400:cb00:480::
2400:cb00:47::
2400:cb00:479::
2400:cb00:474::
2400:cb00:472::
2400:cb00:471::
2400:cb00:470::
2400:cb00:46::
2400:cb00:464::
2400:cb00:463::
2400:cb00:462::
2400:cb00:460::
2400:cb00:45::
2400:cb00:458::
2400:cb00:455::
2400:cb00:454::
2400:cb00:453::
2400:cb00:452::
2400:cb00:451::
2400:cb00:450::
2400:cb00:44::
2400:cb00:448::
2400:cb00:447::
2400:cb00:446::
2400:cb00:445::
2400:cb00:443::
2400:cb00:441::
2400:cb00:440::
2400:cb00:43::
2400:cb00:439::
2400:cb00:437::
2400:cb00:435::
2400:cb00:433::
2400:cb00:432::
2400:cb00:431::
2400:cb00:430::
2400:cb00:429::
2400:cb00:427::
2400:cb00:425::
2400:cb00:424::
2400:cb00:423::
2400:cb00:422::
2400:cb00:41::
2400:cb00:417::
2400:cb00:416::
2400:cb00:415::
2400:cb00:414::
2400:cb00:413::
2400:cb00:412::
2400:cb00:411::
2400:cb00:410::
2400:cb00:40::
2400:cb00:409::
2400:cb00:408::
2400:cb00:406::
2400:cb00:405::
2400:cb00:404::
2400:cb00:403::
2400:cb00:39::
2400:cb00:399::
2400:cb00:398::
2400:cb00:397::
2400:cb00:393::
2400:cb00:392::
2400:cb00:391::
2400:cb00:390::
2400:cb00:38::
2400:cb00:388::
2400:cb00:386::
2400:cb00:385::
2400:cb00:384::
2400:cb00:382::
2400:cb00:381::
2400:cb00:380::
2400:cb00:377::
2400:cb00:376::
2400:cb00:374::
2400:cb00:373::
2400:cb00:370::
2400:cb00:36::
2400:cb00:369::
2400:cb00:368::
2400:cb00:367::
2400:cb00:366::
2400:cb00:365::
2400:cb00:363::
2400:cb00:362::
2400:cb00:360::
2400:cb00:35::
2400:cb00:359::
2400:cb00:358::
2400:cb00:357::
2400:cb00:356::
2400:cb00:354::
2400:cb00:353::
2400:cb00:352::
2400:cb00:351::
2400:cb00:350::
2400:cb00:34::
2400:cb00:349::
2400:cb00:348::
2400:cb00:347::
2400:cb00:346::
2400:cb00:344::
2400:cb00:343::
2400:cb00:342::
2400:cb00:341::
2400:cb00:340::
2400:cb00:339::
2400:cb00:338::
2400:cb00:337::
2400:cb00:336::
2400:cb00:331::
2400:cb00:326::
2400:cb00:31::
2400:cb00:308::
2400:cb00:306::
2400:cb00:305::
2400:cb00:304::
2400:cb00:303::
2400:cb00:302::
2400:cb00:301::
2400:cb00:300::
2400:cb00:29::
2400:cb00:299::
2400:cb00:298::
2400:cb00:292::
2400:cb00:291::
2400:cb00:28::
2400:cb00:285::
2400:cb00:284::
2400:cb00:283::
2400:cb00:282::
2400:cb00:27::
2400:cb00:279::
2400:cb00:275::
2400:cb00:274::
2400:cb00:270::
2400:cb00:26::
2400:cb00:269::
2400:cb00:268::
2400:cb00:267::
2400:cb00:266::
2400:cb00:261::
2400:cb00:260::
2400:cb00:258::
2400:cb00:257::
2400:cb00:256::
2400:cb00:255::
2400:cb00:254::
2400:cb00:253::
2400:cb00:251::
2400:cb00:250::
2400:cb00:249::
2400:cb00:248::
2400:cb00:247::
2400:cb00:246::
2400:cb00:245::
2400:cb00:243::
2400:cb00:242::
2400:cb00:23::
2400:cb00:239::
2400:cb00:238::
2400:cb00:237::
2400:cb00:236::
2400:cb00:235::
2400:cb00:234::
2400:cb00:233::
2400:cb00:232::
2400:cb00:231::
2400:cb00:230::
2400:cb00:22::
2400:cb00:229::
2400:cb00:228::
2400:cb00:227::
2400:cb00:226::
2400:cb00:225::
2400:cb00:224::
2400:cb00:223::
2400:cb00:222::
2400:cb00:221::
2400:cb00:220::
2400:cb00:21::
2400:cb00:219::
2400:cb00:218::
2400:cb00:217::
2400:cb00:216::
2400:cb00:215::
2400:cb00:214::
2400:cb00:213::
2400:cb00:212::
2400:cb00:211::
2400:cb00:210::
2400:cb00:20::
2400:cb00:209::
2400:cb00:208::
2400:cb00:207::
2400:cb00:206::
2400:cb00:205::
2400:cb00:204::
2400:cb00:2049::
2400:cb00:203::
2400:cb00:202::
2400:cb00:201::
2400:cb00:200::
2400:cb00:19::
2400:cb00:199::
2400:cb00:198::
2400:cb00:197::
2400:cb00:196::
2400:cb00:195::
2400:cb00:194::
2400:cb00:193::
2400:cb00:192::
2400:cb00:191::
2400:cb00:190::
2400:cb00:189::
2400:cb00:188::
2400:cb00:187::
2400:cb00:186::
2400:cb00:185::
2400:cb00:184::
2400:cb00:182::
2400:cb00:181::
2400:cb00:180::
2400:cb00:17::
2400:cb00:179::
2400:cb00:177::
2400:cb00:176::
2400:cb00:175::
2400:cb00:174::
2400:cb00:173::
2400:cb00:172::
2400:cb00:171::
2400:cb00:170::
2400:cb00:16::
2400:cb00:169::
2400:cb00:168::
2400:cb00:167::
2400:cb00:166::
2400:cb00:165::
2400:cb00:164::
2400:cb00:163::
2400:cb00:162::
2400:cb00:161::
2400:cb00:160::
2400:cb00:15::
2400:cb00:159::
2400:cb00:158::
2400:cb00:157::
2400:cb00:156::
2400:cb00:155::
2400:cb00:154::
2400:cb00:153::
2400:cb00:152::
2400:cb00:151::
2400:cb00:150::
2400:cb00:14::
2400:cb00:149::
2400:cb00:148::
2400:cb00:147::
2400:cb00:146::
2400:cb00:145::
2400:cb00:144::
2400:cb00:143::
2400:cb00:142::
2400:cb00:141::
2400:cb00:139::
2400:cb00:138::
2400:cb00:137::
2400:cb00:136::
2400:cb00:135::
2400:cb00:134::
2400:cb00:133::
2400:cb00:132::
2400:cb00:131::
2400:cb00:130::
2400:cb00:12::
2400:cb00:129::
2400:cb00:128::
2400:cb00:127::
2400:cb00:126::
2400:cb00:125::
2400:cb00:124::
2400:cb00:123::
2400:cb00:122::
2400:cb00:121::
2400:cb00:120::
2400:cb00:11::
2400:cb00:119::
2400:cb00:117::
2400:cb00:116::
2400:cb00:115::
2400:cb00:114::
2400:cb00:113::
2400:cb00:112::
2400:cb00:111::
2400:cb00:110::
2400:cb00:109::
2400:cb00:107::
2400:cb00:106::
2400:cb00:105::
2400:cb00:104::
2400:cb00:103::
2400:cb00:102::
2400:cb00:100::
"

# Domains to test. Duplicated domains are ok
DOMAINS2TEST="www.google.com amazon.com facebook.com www.youtube.com www.reddit.com  wikipedia.org twitter.com qq.com www.baidu.com whatsapp.com"


totaldomains=0
printf "%-18s" ""
for d in $DOMAINS2TEST; do
    totaldomains=$((totaldomains + 1))
    printf "%-8s" "test$totaldomains"
done
printf "%-8s" "Average"
echo ""


for p in $NAMESERVERS $PROVIDERS; do
    pip=${p%%#*}
    pname=${p##*#}
    ftime=0

    printf "%-18s" "$pname"
    for d in $DOMAINS2TEST; do
        ttime=`$dig +tries=1 +time=2 +stats @$pip $d |grep "Query time:" | cut -d : -f 2- | cut -d " " -f 2`
        if [ -z "$ttime" ]; then
	        #let's have time out be 0.3s = 300ms
	        ttime=300
        elif [ "x$ttime" = "x0" ]; then
	        ttime=1
	    fi

        printf "%-8s" "$ttime ms"
        ftime=$((ftime + ttime))
    done
    avg=`bc -lq <<< "scale=2; $ftime/$totaldomains"`

    echo "  $avg"
done


exit 0;