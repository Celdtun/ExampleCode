function [y, multiplier] = Lowpass_4kP_4r1kS_44r1kFs_4D(x)

%LOWPASS_4KP_4R1KS_44R1KFS_4D Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 8.4 and the DSP System Toolbox 8.7.
% Generated on: 02-May-2015 12:44:03

%#codegen

% To generate C/C++ code from this function use the codegen command.
% Type 'help codegen' for more information.

persistent Hd;

multiplier = 4;

if isempty(Hd)
    
    decf = 4;                     % Decimation Factor
    
    Hd = dsp.FIRDecimator( ...
        'DecimationFactor', decf, ...
        'Numerator', [-4.11596914592149e-05 2.67434949187243e-05 ...
        4.8192402584324e-05 8.54458734563637e-05 0.000139312681922202 ...
        0.00021124997825762 0.000302666695460065 0.000414461072176348 ...
        0.000546756070774137 0.000698656649412181 0.000868132519751935 ...
        0.0010519068542358 0.0012454780134271 0.00144315915858588 ...
        0.00163826086587114 0.00182328961447739 0.00199028419889627 ...
        0.00213114830087226 0.00223809776329334 0.00230406657863705 ...
        0.00232318481600415 0.00229115900277648 0.00220566868088016 ...
        0.00206660353138205 0.00187627060166376 0.00163939955899645 ...
        0.00136309814645098 0.00105658676085128 0.000730887136333116 ...
        0.000398294769380549 7.18433599769144e-05 -0.000235402592617078 ...
        -0.000510978468770299 -0.000743751605684807 -0.000924482638471438 ...
        -0.00104643555555678 -0.00110573180623337 -0.00110170426947032 ...
        -0.001036894381286 -0.000917038221833549 -0.000750648132413086 ...
        -0.000548708869969013 -0.000323910525396196 -9.01971547853964e-05 ...
        0.000138493050335932 0.000348673495761335 0.00052812186081418 ...
        0.000666913613054859 0.000757644664311841 0.000796129245477748 ...
        0.000781467824721588 0.000716192371088653 0.000605970594287019 ...
        0.000459293133873666 0.000286820656249453 0.000100727539876241 ...
        -8.61728158515213e-05 -0.00026123323520466 -0.000412863232432374 ...
        -0.000531254749332751 -0.00060906579101855 -0.000641855757831758 ...
        -0.000628388762842019 -0.0005706495306199 -0.000473697763266549 ...
        -0.000345252142049814 -0.000195144083393402 -3.45734823954107e-05 ...
        0.000124680086616963 0.000271127455615085 0.000394367833976257 ...
        0.000485844396400325 0.00053942378661159 0.000551837279531522 ...
        0.000522873722462097 0.000455381554060764 0.000355008936171876 ...
        0.000229774813803042 8.94400524393019e-05 -5.52143639161192e-05 ...
        -0.000193214774442627 -0.000314208527099686 -0.000409254216054676 ...
        -0.000471461832036187 -0.000496503745772728 -0.000482912599097367 ...
        -0.000432199948644823 -0.000348717036817068 -0.000239221075838645 ...
        -0.000112493949575291 2.1485928957682e-05 0.000152242999734308 ...
        0.000269632993326565 0.000364627904399476 0.000430003012559261 ...
        0.00046089163830705 0.000455147826712985 0.000413506083707108 ...
        0.000339506635417803 0.000239211342562436 0.000120713839373873 ...
        -6.4973078250015e-06 -0.000132294020042512 -0.000246701544147919 ...
        -0.00034069075640859 -0.000406883305255836 -0.000440137506272456 ...
        -0.000437944219208693 -0.000400625624298871 -0.000331298116685986 ...
        -0.000235627251483542 -0.000121367870644517 2.25018683102555e-06 ...
        0.000125268177043389 0.000237788959446888 0.000330774789169911 ...
        0.000396762575699833 0.000430469323470274 0.00042921082574547 ...
        0.000393127879661065 0.000325166543483122 0.000230850578381436 ...
        0.000117829322338139 -4.7239543229318e-06 -0.00012686035465952 ...
        -0.000238650362615563 -0.000331002343865384 -0.000396380279488659 ...
        -0.000429432744761771 -0.000427413506350639 -0.000390453233356399 ...
        -0.000321495906324774 -0.000226110338894716 -0.000112045018758993 ...
        1.14280163953275e-05 0.000134224021129271 0.000246293439151504 ...
        0.000338423435467796 0.000403006054320931 0.000434653982489782 ...
        0.000430659116151058 0.000391217104692911 0.00031943232992963 ...
        0.000221070481876482 0.000104105972286537 -2.19272313316877e-05 ...
        -0.000146703162838936 -0.000259951241294175 -0.000352293199055359 ...
        -0.000416021878024835 -0.000445739328204799 -0.000438818145300167 ...
        -0.000395628832684182 -0.000319530512117751 -0.000216608793847684 ...
        -9.51968240045316e-05 3.47990831612866e-05 0.000162701246905796 ...
        0.000277938829358213 0.000370915460421023 0.000433808863556421 ...
        0.00046122308527871 0.000450654858352077 0.000402717431302157 ...
        0.000321115068057679 0.000212355545034231 8.52368523684597e-05 ...
        -4.98620685998361e-05 -0.000181822909890897 -0.000299706962230113 ...
        -0.000393656327821386 -0.000455716207548805 -0.000480501521800896 ...
        -0.000465672329501318 -0.000412153142458268 -0.000324058339567779 ...
        -0.00020841794399616 -7.45844069147009e-05 6.65019796858621e-05 ...
        0.000203210626271065 0.000324176057130504 0.00041924091136548 ...
        0.000480307108652558 0.000502024226810813 0.000482256511033113 ...
        0.000422287423611668 0.000326743637396996 0.000203241386008207 ...
        6.17834423673035e-05 -8.60493920416834e-05 -0.000228042714902266 ...
        -0.000352356951054017 -0.0004485102937615 -0.000508261419401853 ...
        -0.000526312235945323 -0.000500777026072954 -0.000433369242926064 ...
        -0.000329295207237422 -0.000196853154606382 -4.67770871376037e-05 ...
        0.000108632261070232 0.000256510687250187 0.000384495696725187 ...
        0.000481755078072717 0.000539902992490707 0.000553716963510888 ...
        0.000521607480066925 0.000445782935799104 0.000332108358148964 ...
        0.000189649154763224 2.99555566876828e-05 -0.000133873511072483 ...
        -0.000288258430259063 -0.000420269728756554 -0.000518701641501827 ...
        -0.000575025417244772 -0.000584116713907045 -0.000544735333331048 ...
        -0.000459644580204256 -0.000335439605385735 -0.000182039167767998 ...
        -1.18859413475004e-05 0.000161048858242141 0.000322419232300271 ...
        0.000458686917962713 0.000558258704893198 0.000612467305629491 ...
        0.000616325618235419 0.000568978504845467 0.000473819907619315 ...
        0.000338253883799706 0.000173124091683785 -8.15238458018582e-06 ...
        -0.000190670956381239 -0.000359264336611572 -0.000499759843495964 ...
        -0.000600169444659782 -0.000651709059515129 -0.00064956495957134 ...
        -0.000593336637159024 -0.000487119204563112 -0.000339210640856146 ...
        -0.000161468050356317 3.16400050376109e-05 0.000224207319320492 ...
        0.000400198211187655 0.000544780350847435 0.000645573193371193 ...
        0.00069370339396325 0.000684582828130057 0.0006183375070223 ...
        0.000499850998372393 0.00033841060676102 0.000146981937830751 ...
        -5.88278434036147e-05 -0.000262038234439491 -0.000445694947415914 ...
        -0.000594282144151068 -0.000695029036817131 -0.000739001691579097 ...
        -0.000721894102490263 -0.000644441878382331 -0.00051240453504376 ...
        -0.000336162629819889 -0.000129889233463045 8.95765352538748e-05 ...
        0.000304105890787083 0.00049577257709533 0.000648350244177012 ...
        0.000748680822308545 0.000787807452684866 0.000761766721813845 ...
        0.000671978599501982 0.000525188123084597 0.000332966974283401 ...
        0.000110803897428601 -0.000123138195265604 -0.000349505111162092 ...
        -0.000549348716943014 -0.000705711339380845 -0.000805060013722091 ...
        -0.000838454600836321 -0.000802345036568892 -0.0006989314900684 ...
        -0.000536047780480182 -0.000326575315098319 -8.74280304866125e-05 ...
        0.000161808557571409 0.000400477885950653 0.000608559950098941 ...
        0.000768348254292104 0.00086595211395871 0.000892499126382962 ...
        0.000844934181724108 0.000726342592716639 0.000545767969421793 ...
        0.000317527700438651 6.0082928602864e-05 -0.000205449382659948 ...
        -0.000457023721079283 -0.000673494774162608 -0.000836389224105893 ...
        -0.000931477626907987 -0.000950008273759938 -0.000889511875414284 ...
        -0.000754072517189878 -0.000554072672580615 -0.000305405909605907 ...
        -2.82123486492335e-05 0.000254740929383083 0.000519931553848956 ...
        0.000745028929371495 0.000910774144251526 0.00100261930202347 ...
        0.00101200100035486 0.000937124713395464 0.000783200891901757 ...
        0.000562093494551968 0.000291415894283667 -6.86993435679433e-06 ...
        -0.000308227148251317 -0.000587560618335282 -0.000821299617911534 ...
        -0.000989385033203868 -0.00107698269860434 -0.00107578801638876 ...
        -0.000984796772324716 -0.000810483248922959 -0.000566351390743119 ...
        -0.000271899655892682 4.89326633603077e-05 0.00036970310975385 ...
        0.000663642055906561 0.000905878217766256 0.00107554042319858 ...
        0.00115754539720766 0.00114393268092795 0.0010346156275155 ...
        0.000837492713168092 0.00056788904169178 0.000247373774195587 ...
        -9.79602022611165e-05 -0.000439611064457093 -0.000749017269377145 ...
        -0.000999937818629488 -0.00117067292950975 -0.00124592863350691 ...
        -0.00121818049089572 -0.00108840234147397 -0.000866090113087068 ...
        -0.000568589878699491 -0.000219746600428565 0.000151996232024908 ...
        0.00051590953485759 0.000841512331860985 0.00110111767803947 ...
        0.0012721805092403 0.00133924605233568 0.00129533415875999 ...
        0.00114263431192514 0.000892446617960892 0.000564360479514145 ...
        0.000184732327669331 -0.000215423736626471 -0.000602959445255502 ...
        -0.000945330899293132 -0.00121332122340284 -0.00138352562985908 ...
        -0.00144038287003123 -0.00137758293013578 -0.00119871931968069 ...
        -0.000917127759052069 -0.000554906417372087 -0.000141194997542389 ...
        0.000290161228182774 0.00070336849485341 0.00106364614494899 ...
        0.0013401423800016 0.00150856689855853 0.00155330878993673 ...
        0.00146886554020646 0.00126044237249536 0.000943675843697536 ...
        0.000543474035587424 9.20731137682739e-05 -0.000373549587701628 ...
        -0.000814690030657981 -0.00119412745457967 -0.0014792501302896 ...
        -0.00164484758099136 -0.00167531868841326 -0.00156612432172241 ...
        -0.0013243206619333 -0.000968148519628386 -0.000525675773520372 ...
        -3.25998202420677e-05 0.000470616597655532 0.000942052080873129 ...
        0.00134180406398772 0.00163535065413846 0.00179651559701447 ...
        0.00180978076775188 0.00167174629456481 0.00139160101507256 ...
        0.00099055123440759 0.0005002370588703 -3.97457109752405e-05 ...
        -0.000585026879649591 -0.00109009034916819 -0.00151205684742774 ...
        -0.00181430534795627 -0.001969631462205 -0.0019626696208098 ...
        -0.00179136742625523 -0.00146737244928734 -0.00101528369174869 ...
        -0.000470809342688161 0.000122031411186852 0.000714447134626793 ...
        0.00125686790235487 0.00170307136558267 0.0020140985283069 ...
        0.0021616288378483 0.0021305260010368 0.00192032567747729 ...
        0.00154552586253662 0.00103463640960949 0.000428038427395176 ...
        -0.000225178853089971 -0.000871164476548123 -0.00145571700295587 ...
        -0.00192880593762773 -0.00224882219470396 -0.00238620284597198 ...
        -0.00232611721767838 -0.00206997539745642 -0.00163560043892762 ...
        -0.00105605045146184 -0.00037713348321203 0.000346174861254542 ...
        0.00105415296650768 0.00168722673895407 0.00219094851109544 ...
        0.00252063817555118 0.00264530369175505 0.00255049079174004 ...
        0.00223981473785244 0.00173501092744189 0.00107448152458635 ...
        0.000310419482250588 -0.000495269380057416 -0.00127593937389923 ...
        -0.00196566917197628 -0.00250478090192238 -0.00284494807795345 ...
        -0.00295346776276935 -0.00281631607946208 -0.00243971577459099 ...
        -0.00185004723542493 -0.00109208259134316 -0.000225647048223702 ...
        0.000679042166978181 0.00154700710041844 0.00230465664089216 ...
        0.00288595938842839 0.00323812197840825 0.00332629700306924 ...
        0.0031369033011623 0.00267925235342275 0.00198531169824604 ...
        0.00110757576988082 0.000115178623493987 -0.000911467229613008 ...
        -0.00188710002315126 -0.00272859761415978 -0.00336196089625362 ...
        -0.0037287105929165 -0.00379115517023748 -0.00353607001688652 ...
        -0.00297643157127615 -0.00215102593076283 -0.00112190535195639 ...
        3.01583778731524e-05 0.00121188877480734 0.00232493083908328 ...
        0.00327389551446367 0.00397438594681463 0.00436033274688825 ...
        0.00439002270675506 0.00405027834905881 0.00335840066221225 ...
        0.00236164164776088 0.00113418827429797 -0.000228177195723416 ...
        -0.00161535970183564 -0.00291164657972095 -0.00400513421669404 ...
        -0.00479714433399787 -0.00521084726684442 -0.00519837043620503 ...
        -0.00474575036067509 -0.00387526396018956 -0.00264485148238224 ...
        -0.00114459196696144 0.000509591650339145 0.00218456885971257 ...
        0.00374036742066639 0.00504147541830891 0.005968207612741 ...
        0.00642720140640107 0.00636017679645329 0.00575016744942093 ...
        0.00462464161751213 0.00305512959929229 0.00115325577617779 ...
        -0.000936651688909357 -0.00304791308883617 -0.00500411344110971 ...
        -0.00663306293101575 -0.0077810536133835 -0.00832628542091775 ...
        -0.00819037540640653 -0.00734694768973292 -0.00582650071390113 ...
        -0.00371700856708382 -0.0011600028044247 0.00165776544390415 ...
        0.00451665163437503 0.00717967736923411 0.00941029074382851 ...
        0.0109910928587037 0.0117421662138763 0.0115376216980457 ...
        0.0103190508797136 0.00810475164411236 0.0049938532864677 ...
        0.00116481000333974 -0.0031318890569882 -0.00758652756211166 ...
        -0.0118478285291662 -0.0155444436579465 -0.0183089340515583 ...
        -0.0198026837286258 -0.0197400810460275 -0.017910293508533 ...
        -0.0141950881979774 -0.00858136618973833 -0.0011674148180153 ...
        0.00783773007153642 0.018121958193918 0.029284483355781 ...
        0.0408561912407093 0.052324759604441 0.0631630297151268 ...
        0.0728588839457735 0.080944739698118 0.0870248096246315 ...
        0.0907983637275801 0.092077514040416 0.0907983637275801 ...
        0.0870248096246315 0.080944739698118 0.0728588839457735 ...
        0.0631630297151268 0.052324759604441 0.0408561912407093 ...
        0.029284483355781 0.018121958193918 0.00783773007153642 ...
        -0.0011674148180153 -0.00858136618973833 -0.0141950881979774 ...
        -0.017910293508533 -0.0197400810460275 -0.0198026837286258 ...
        -0.0183089340515583 -0.0155444436579465 -0.0118478285291662 ...
        -0.00758652756211166 -0.0031318890569882 0.00116481000333974 ...
        0.0049938532864677 0.00810475164411236 0.0103190508797136 ...
        0.0115376216980457 0.0117421662138763 0.0109910928587037 ...
        0.00941029074382851 0.00717967736923411 0.00451665163437503 ...
        0.00165776544390415 -0.0011600028044247 -0.00371700856708382 ...
        -0.00582650071390113 -0.00734694768973292 -0.00819037540640653 ...
        -0.00832628542091775 -0.0077810536133835 -0.00663306293101575 ...
        -0.00500411344110971 -0.00304791308883617 -0.000936651688909357 ...
        0.00115325577617779 0.00305512959929229 0.00462464161751213 ...
        0.00575016744942093 0.00636017679645329 0.00642720140640107 ...
        0.005968207612741 0.00504147541830891 0.00374036742066639 ...
        0.00218456885971257 0.000509591650339145 -0.00114459196696144 ...
        -0.00264485148238224 -0.00387526396018956 -0.00474575036067509 ...
        -0.00519837043620503 -0.00521084726684442 -0.00479714433399787 ...
        -0.00400513421669404 -0.00291164657972095 -0.00161535970183564 ...
        -0.000228177195723416 0.00113418827429797 0.00236164164776088 ...
        0.00335840066221225 0.00405027834905881 0.00439002270675506 ...
        0.00436033274688825 0.00397438594681463 0.00327389551446367 ...
        0.00232493083908328 0.00121188877480734 3.01583778731524e-05 ...
        -0.00112190535195639 -0.00215102593076283 -0.00297643157127615 ...
        -0.00353607001688652 -0.00379115517023748 -0.0037287105929165 ...
        -0.00336196089625362 -0.00272859761415978 -0.00188710002315126 ...
        -0.000911467229613008 0.000115178623493987 0.00110757576988082 ...
        0.00198531169824604 0.00267925235342275 0.0031369033011623 ...
        0.00332629700306924 0.00323812197840825 0.00288595938842839 ...
        0.00230465664089216 0.00154700710041844 0.000679042166978181 ...
        -0.000225647048223702 -0.00109208259134316 -0.00185004723542493 ...
        -0.00243971577459099 -0.00281631607946208 -0.00295346776276935 ...
        -0.00284494807795345 -0.00250478090192238 -0.00196566917197628 ...
        -0.00127593937389923 -0.000495269380057416 0.000310419482250588 ...
        0.00107448152458635 0.00173501092744189 0.00223981473785244 ...
        0.00255049079174004 0.00264530369175505 0.00252063817555118 ...
        0.00219094851109544 0.00168722673895407 0.00105415296650768 ...
        0.000346174861254542 -0.00037713348321203 -0.00105605045146184 ...
        -0.00163560043892762 -0.00206997539745642 -0.00232611721767838 ...
        -0.00238620284597198 -0.00224882219470396 -0.00192880593762773 ...
        -0.00145571700295587 -0.000871164476548123 -0.000225178853089971 ...
        0.000428038427395176 0.00103463640960949 0.00154552586253662 ...
        0.00192032567747729 0.0021305260010368 0.0021616288378483 ...
        0.0020140985283069 0.00170307136558267 0.00125686790235487 ...
        0.000714447134626793 0.000122031411186852 -0.000470809342688161 ...
        -0.00101528369174869 -0.00146737244928734 -0.00179136742625523 ...
        -0.0019626696208098 -0.001969631462205 -0.00181430534795627 ...
        -0.00151205684742774 -0.00109009034916819 -0.000585026879649591 ...
        -3.97457109752405e-05 0.0005002370588703 0.00099055123440759 ...
        0.00139160101507256 0.00167174629456481 0.00180978076775188 ...
        0.00179651559701447 0.00163535065413846 0.00134180406398772 ...
        0.000942052080873129 0.000470616597655532 -3.25998202420677e-05 ...
        -0.000525675773520372 -0.000968148519628386 -0.0013243206619333 ...
        -0.00156612432172241 -0.00167531868841326 -0.00164484758099136 ...
        -0.0014792501302896 -0.00119412745457967 -0.000814690030657981 ...
        -0.000373549587701628 9.20731137682739e-05 0.000543474035587424 ...
        0.000943675843697536 0.00126044237249536 0.00146886554020646 ...
        0.00155330878993673 0.00150856689855853 0.0013401423800016 ...
        0.00106364614494899 0.00070336849485341 0.000290161228182774 ...
        -0.000141194997542389 -0.000554906417372087 -0.000917127759052069 ...
        -0.00119871931968069 -0.00137758293013578 -0.00144038287003123 ...
        -0.00138352562985908 -0.00121332122340284 -0.000945330899293132 ...
        -0.000602959445255502 -0.000215423736626471 0.000184732327669331 ...
        0.000564360479514145 0.000892446617960892 0.00114263431192514 ...
        0.00129533415875999 0.00133924605233568 0.0012721805092403 ...
        0.00110111767803947 0.000841512331860985 0.00051590953485759 ...
        0.000151996232024908 -0.000219746600428565 -0.000568589878699491 ...
        -0.000866090113087068 -0.00108840234147397 -0.00121818049089572 ...
        -0.00124592863350691 -0.00117067292950975 -0.000999937818629488 ...
        -0.000749017269377145 -0.000439611064457093 -9.79602022611165e-05 ...
        0.000247373774195587 0.00056788904169178 0.000837492713168092 ...
        0.0010346156275155 0.00114393268092795 0.00115754539720766 ...
        0.00107554042319858 0.000905878217766256 0.000663642055906561 ...
        0.00036970310975385 4.89326633603077e-05 -0.000271899655892682 ...
        -0.000566351390743119 -0.000810483248922959 -0.000984796772324716 ...
        -0.00107578801638876 -0.00107698269860434 -0.000989385033203868 ...
        -0.000821299617911534 -0.000587560618335282 -0.000308227148251317 ...
        -6.86993435679433e-06 0.000291415894283667 0.000562093494551968 ...
        0.000783200891901757 0.000937124713395464 0.00101200100035486 ...
        0.00100261930202347 0.000910774144251526 0.000745028929371495 ...
        0.000519931553848956 0.000254740929383083 -2.82123486492335e-05 ...
        -0.000305405909605907 -0.000554072672580615 -0.000754072517189878 ...
        -0.000889511875414284 -0.000950008273759938 -0.000931477626907987 ...
        -0.000836389224105893 -0.000673494774162608 -0.000457023721079283 ...
        -0.000205449382659948 6.0082928602864e-05 0.000317527700438651 ...
        0.000545767969421793 0.000726342592716639 0.000844934181724108 ...
        0.000892499126382962 0.00086595211395871 0.000768348254292104 ...
        0.000608559950098941 0.000400477885950653 0.000161808557571409 ...
        -8.74280304866125e-05 -0.000326575315098319 -0.000536047780480182 ...
        -0.0006989314900684 -0.000802345036568892 -0.000838454600836321 ...
        -0.000805060013722091 -0.000705711339380845 -0.000549348716943014 ...
        -0.000349505111162092 -0.000123138195265604 0.000110803897428601 ...
        0.000332966974283401 0.000525188123084597 0.000671978599501982 ...
        0.000761766721813845 0.000787807452684866 0.000748680822308545 ...
        0.000648350244177012 0.00049577257709533 0.000304105890787083 ...
        8.95765352538748e-05 -0.000129889233463045 -0.000336162629819889 ...
        -0.00051240453504376 -0.000644441878382331 -0.000721894102490263 ...
        -0.000739001691579097 -0.000695029036817131 -0.000594282144151068 ...
        -0.000445694947415914 -0.000262038234439491 -5.88278434036147e-05 ...
        0.000146981937830751 0.00033841060676102 0.000499850998372393 ...
        0.0006183375070223 0.000684582828130057 0.00069370339396325 ...
        0.000645573193371193 0.000544780350847435 0.000400198211187655 ...
        0.000224207319320492 3.16400050376109e-05 -0.000161468050356317 ...
        -0.000339210640856146 -0.000487119204563112 -0.000593336637159024 ...
        -0.00064956495957134 -0.000651709059515129 -0.000600169444659782 ...
        -0.000499759843495964 -0.000359264336611572 -0.000190670956381239 ...
        -8.15238458018582e-06 0.000173124091683785 0.000338253883799706 ...
        0.000473819907619315 0.000568978504845467 0.000616325618235419 ...
        0.000612467305629491 0.000558258704893198 0.000458686917962713 ...
        0.000322419232300271 0.000161048858242141 -1.18859413475004e-05 ...
        -0.000182039167767998 -0.000335439605385735 -0.000459644580204256 ...
        -0.000544735333331048 -0.000584116713907045 -0.000575025417244772 ...
        -0.000518701641501827 -0.000420269728756554 -0.000288258430259063 ...
        -0.000133873511072483 2.99555566876828e-05 0.000189649154763224 ...
        0.000332108358148964 0.000445782935799104 0.000521607480066925 ...
        0.000553716963510888 0.000539902992490707 0.000481755078072717 ...
        0.000384495696725187 0.000256510687250187 0.000108632261070232 ...
        -4.67770871376037e-05 -0.000196853154606382 -0.000329295207237422 ...
        -0.000433369242926064 -0.000500777026072954 -0.000526312235945323 ...
        -0.000508261419401853 -0.0004485102937615 -0.000352356951054017 ...
        -0.000228042714902266 -8.60493920416834e-05 6.17834423673035e-05 ...
        0.000203241386008207 0.000326743637396996 0.000422287423611668 ...
        0.000482256511033113 0.000502024226810813 0.000480307108652558 ...
        0.00041924091136548 0.000324176057130504 0.000203210626271065 ...
        6.65019796858621e-05 -7.45844069147009e-05 -0.00020841794399616 ...
        -0.000324058339567779 -0.000412153142458268 -0.000465672329501318 ...
        -0.000480501521800896 -0.000455716207548805 -0.000393656327821386 ...
        -0.000299706962230113 -0.000181822909890897 -4.98620685998361e-05 ...
        8.52368523684597e-05 0.000212355545034231 0.000321115068057679 ...
        0.000402717431302157 0.000450654858352077 0.00046122308527871 ...
        0.000433808863556421 0.000370915460421023 0.000277938829358213 ...
        0.000162701246905796 3.47990831612866e-05 -9.51968240045316e-05 ...
        -0.000216608793847684 -0.000319530512117751 -0.000395628832684182 ...
        -0.000438818145300167 -0.000445739328204799 -0.000416021878024835 ...
        -0.000352293199055359 -0.000259951241294175 -0.000146703162838936 ...
        -2.19272313316877e-05 0.000104105972286537 0.000221070481876482 ...
        0.00031943232992963 0.000391217104692911 0.000430659116151058 ...
        0.000434653982489782 0.000403006054320931 0.000338423435467796 ...
        0.000246293439151504 0.000134224021129271 1.14280163953275e-05 ...
        -0.000112045018758993 -0.000226110338894716 -0.000321495906324774 ...
        -0.000390453233356399 -0.000427413506350639 -0.000429432744761771 ...
        -0.000396380279488659 -0.000331002343865384 -0.000238650362615563 ...
        -0.00012686035465952 -4.7239543229318e-06 0.000117829322338139 ...
        0.000230850578381436 0.000325166543483122 0.000393127879661065 ...
        0.00042921082574547 0.000430469323470274 0.000396762575699833 ...
        0.000330774789169911 0.000237788959446888 0.000125268177043389 ...
        2.25018683102555e-06 -0.000121367870644517 -0.000235627251483542 ...
        -0.000331298116685986 -0.000400625624298871 -0.000437944219208693 ...
        -0.000440137506272456 -0.000406883305255836 -0.00034069075640859 ...
        -0.000246701544147919 -0.000132294020042512 -6.4973078250015e-06 ...
        0.000120713839373873 0.000239211342562436 0.000339506635417803 ...
        0.000413506083707108 0.000455147826712985 0.00046089163830705 ...
        0.000430003012559261 0.000364627904399476 0.000269632993326565 ...
        0.000152242999734308 2.1485928957682e-05 -0.000112493949575291 ...
        -0.000239221075838645 -0.000348717036817068 -0.000432199948644823 ...
        -0.000482912599097367 -0.000496503745772728 -0.000471461832036187 ...
        -0.000409254216054676 -0.000314208527099686 -0.000193214774442627 ...
        -5.52143639161192e-05 8.94400524393019e-05 0.000229774813803042 ...
        0.000355008936171876 0.000455381554060764 0.000522873722462097 ...
        0.000551837279531522 0.00053942378661159 0.000485844396400325 ...
        0.000394367833976257 0.000271127455615085 0.000124680086616963 ...
        -3.45734823954107e-05 -0.000195144083393402 -0.000345252142049814 ...
        -0.000473697763266549 -0.0005706495306199 -0.000628388762842019 ...
        -0.000641855757831758 -0.00060906579101855 -0.000531254749332751 ...
        -0.000412863232432374 -0.00026123323520466 -8.61728158515213e-05 ...
        0.000100727539876241 0.000286820656249453 0.000459293133873666 ...
        0.000605970594287019 0.000716192371088653 0.000781467824721588 ...
        0.000796129245477748 0.000757644664311841 0.000666913613054859 ...
        0.00052812186081418 0.000348673495761335 0.000138493050335932 ...
        -9.01971547853964e-05 -0.000323910525396196 -0.000548708869969013 ...
        -0.000750648132413086 -0.000917038221833549 -0.001036894381286 ...
        -0.00110170426947032 -0.00110573180623337 -0.00104643555555678 ...
        -0.000924482638471438 -0.000743751605684807 -0.000510978468770299 ...
        -0.000235402592617078 7.18433599769144e-05 0.000398294769380549 ...
        0.000730887136333116 0.00105658676085128 0.00136309814645098 ...
        0.00163939955899645 0.00187627060166376 0.00206660353138205 ...
        0.00220566868088016 0.00229115900277648 0.00232318481600415 ...
        0.00230406657863705 0.00223809776329334 0.00213114830087226 ...
        0.00199028419889627 0.00182328961447739 0.00163826086587114 ...
        0.00144315915858588 0.0012454780134271 0.0010519068542358 ...
        0.000868132519751935 0.000698656649412181 0.000546756070774137 ...
        0.000414461072176348 0.000302666695460065 0.00021124997825762 ...
        0.000139312681922202 8.54458734563637e-05 4.8192402584324e-05 ...
        2.67434949187243e-05 -4.11596914592149e-05]);
end

y = step(Hd,x);


% [EOF]