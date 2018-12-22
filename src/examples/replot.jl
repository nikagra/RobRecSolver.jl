using LaTeXStrings
import PyPlot
using Plots

pyplot()

Plots.scalefontsizes(1.5)

suffix = randstring(4)

# Assignment
data = [
0.1 1.9075748280876315 1.4747811674960392 1.1464459697029081;
0.2 1.8075377562197432 1.4863873721097443 1.1324598084209505;
0.3 1.7884410994042040 1.4297743840730375 1.1083722972025432;
0.4 1.7592733089234140 1.3930658110595278 1.1038913454375836;
0.5 1.6761820568063950 1.3863960141022980 1.0964091071721103;
0.6 1.7705066123052355 1.3638177854773679 1.0758815990502242;
0.7 1.6051096323514806 1.3294825988774295 1.0681224135184944;
0.8 1.5991563598875540 1.2705422765831762 1.0554859953458415;
0.9 1.6585976251857233 1.2441582022466133 1.0377232015881120;
]
RobRecSolver.drawAndSavePlot("as-plot-ratios-rec-all-$suffix.pdf", data[:, 1], data[:, 2:4], "α", "average ratio ρ(c₀)", [L"m=10" L"m=25" L"m=100"])

data = [
0.1 21.489366732;
0.2 19.814200436399997;
0.3 20.7098415837;
0.4 19.004395868800003;
0.5 15.371485744000001;
0.6 12.3328632597;
0.7 12.2725272898;
0.8 9.4259031217;
0.9 8.53626359;
]
RobRecSolver.drawAndSavePlot("as-plot-times-rec-100-$suffix.pdf", data[:, 1], data[:, 2], "α", "average time (s)", L"m=100")

n = 10
data = [
0.1 1.6831293763141062 1.9075748280876315 1.173557753692561 1.065932607074318;
0.2 1.4664545197665700 1.7861501271151685 1.2483116152985971 1.0607063703413697;
0.3 1.5036938179412327 1.7290235321463918 1.3340636790208489 1.084593137914198;
0.4 1.4283962572944024 1.6321350464763171 1.3015234116951702 1.0806669133101443;
0.5 1.3220037623791830 1.4772075926307986 1.257286379457149 1.0573694220975576;
0.6 1.2719211840260787 1.4340259589199096 1.3083015380521374 1.06536368745664;
0.7 1.1800186072040333 1.3239283128416650 1.287377626838893 1.04946166235476;
0.8 1.0482230964007475 1.1481068139484343 1.1660369013470004 1.007459317868496;
0.9 1.0071125108568322 1.0910456997806783 1.1053928436207934 1.0000804123124618;
]
RobRecSolver.drawAndSavePlot("as-plot-ratios-adv_rec_sel-$n-$suffix.pdf", data[:, 1], data[:, 2:5], "α", "average ratio ρₖ", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}" L"\rho_{Lag}"])

data = [
0.1 612.74906727150000 5.7898088248 315.6177820155;
0.2 552.08633878860000 12.283925948 298.79297613119996;
0.3 552.52967829610010 86.5952288503 434.4127461145;
0.4 519.21884969310010 55.765483325000005 382.6025441251;
0.5 384.96813978040007 29.369344033700003 286.40872043930005;
0.6 341.90439000170000 20.485862688099996 254.85686698910004;
0.7 452.76971847200000 38.931166520000005 249.0464063599;
0.8 145.75050851250000 22.7216124339 153.62977241560003;
0.9 44.461099163500000 21.0509928252 144.01397277810003;
]
RobRecSolver.drawAndSavePlot("as-plot-times-adv_rec_sel-$n-$suffix.pdf", data[:, 1], data[:, 2:4], "α", "average time (s)", [L"\rho_{Adv}" L"\rho_{Sel}" L"\rho_{Lag}"])

n = 25
data = [
0.1 1.37664370315857 1.4747811674960392 1.0872910293162728 1.0015195522086358;
0.2 1.4863873721097443 1.4863873721097443 1.2288126971859685 1.0038622336091294;
0.3 1.4189653306433594 1.4297743840730375 1.285686945720881 1.0006658552137813;
0.4 1.3822356392934763 1.4053481958203533 1.3361632121835036 1.0021866223956395;
0.5 1.3658372424458887 1.4109169762158875 1.3708878067694603 1.016737005140556;
0.6 1.4094936635002326 1.4094936635002326 1.5039592616378747 1.0515282195816977;
0.7 1.3221801457755231 1.3449804512050694 1.4620426575704843 1.027864942958177;
0.8 1.1990629081547945 1.2683536958733348 1.4493445694010578 1.0324414579060446;
0.9 1.0972067420396134 1.2179482191836333 1.426841395597629 1.0153848016868947;
]
solvedProblems = [8, 6, 6, 5, 5, 6, 5, 7, 8]
annotations = collect(zip(data[:, 1], data[:, 5] + 0.02, map(i -> "($(string(i)))", solvedProblems)))
RobRecSolver.drawAndSavePlot("as-plot-ratios-adv_rec_sel-$n-$suffix.pdf", data[:, 1], data[:, 2:5], "α", "average ratio ρₖ", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}" L"\rho_{Lag}"], annotations = annotations)

data = [
0.1 714.34192512860000 113.73340726129997 715.4252842413
0.2 1140.8434791009000 539.9750888258 1257.1354688683
0.3 1036.0827555179999 434.52840892610004 1438.9276898477
0.4 1257.1031513980001 656.6449440259 1598.8063246314
0.5 1284.2268418832002 680.5100740454001 1589.754969974
0.6 1468.8170537005000 867.486028753 2329.5989568883997
0.7 1267.3685427592002 666.41650177 1701.4592718757
0.8 1336.0279507764000 733.9539979626 1609.3311992156
0.9 1345.8436845277997 759.9526494120998 1349.0492507661
]
RobRecSolver.drawAndSavePlot("as-plot-times-adv_rec_sel-$n-$suffix.pdf", data[:, 1], data[:, 2:4], "α", "average time (s)", [L"\rho_{Adv}" L"\rho_{Sel}" L"\rho_{Lag}"])

# Knapsack
data = [
0.1 1.8972427316705456 1.9623222233371689 1.9805435083024563;
0.2 1.9225776947440890 1.9448113026221825 1.9876249931467510;
0.3 1.9014115338766469 1.9619173214795058 1.9754833472475766;
0.4 1.9056161452969030 1.9320572591324616 1.9573564447781167;
0.5 1.9643496039198851 1.9143840615992658 1.9572998511093278;
0.6 1.9551347049418761 1.8943985953724045 1.9591006127217407;
0.7 1.9003254082162815 1.9201963663561188 1.9569359094957082;
0.8 1.8923002897952794 1.9884962738707820 1.9938890357976498;
0.9 1.8792247810213432 1.9425139231406323 1.9705100572086707;
]
RobRecSolver.drawAndSavePlot("kn-plot-ratios-rec-all-$suffix.pdf", data[:, 1], data[:, 2:4], "α", "average ratio ρ(c₀)", [L"n=100" L"n=400" L"n=1000"])

data = [
0.1 111.1271761563;
0.2 92.14324673979999;
0.3 114.93570344839995;
0.4 68.86856813489999;
0.5 12.811871194799997;
0.6 88.8279751295;
0.7 1.4956321173;
0.8 1.1725746297000001;
0.9 0.8845123612999999;
]
RobRecSolver.drawAndSavePlot("kn-plot-times-rec-1000-$suffix.pdf", data[:, 1], data[:, 2], "α", "average time (s)", L"n=1000")

n = 100
data = [
0.1 1.5785032872517593 1.8148313515117773 1.0489811068846486;
0.2 1.5432815356206786 1.731571458979199 1.1232981003419726;
0.3 1.4773099058792603 1.588400684168335 1.195059954149759;
0.4 1.4013034443892785 1.503428795210882 1.3500969740766966;
0.5 1.3741244096096674 1.4080268074490871 1.5878143954515203;
0.6 1.279022759334623 1.3790644016017393 1.8374718337300742;
0.7 1.3516281152328333 1.3598998793370245 2.3023464956346857;
0.8 1.250633163307791 1.3446321868306612 3.064315357082676;
0.9 1.2990434988796935 1.353890674361943 4.371314038791393;
]
RobRecSolver.drawAndSavePlot("kn-plot-ratios-adv_rec_sel-$n-$suffix.pdf", data[:, 1], data[:, 2:4], "α", "average ratio ρₖ", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}"])

data = [
0.1 683.85515438490000 306.8665300548;
0.2 764.80120547760000 381.1336656994;
0.3 1003.1979958209998 505.311276721;
0.4 1411.8153223881000 972.2210394219001;
0.5 1822.0840759751002 1221.9886499052;
0.6 1763.8984710777000 1178.8880315897;
0.7 1839.7934117224002 1231.0226173796;
0.8 1818.9329570541995 1224.1067296154;
0.9 1829.1931046857000 1238.0020372643999;
]
RobRecSolver.drawAndSavePlot("kn-plot-times-adv_rec_sel-$n-$suffix.pdf", data[:, 1], data[:, 2:3], "α", "average time (s)", [L"\rho_{Adv}" L"\rho_{Sel}"])

n = 400
data = [
0.1 1.865296817918822 1.8679689413142575 1.192078138968744;
0.2 1.7445426254734886 1.7445426254734886 1.2528996183862102;
0.3 1.6522356758850278 1.6522356758850278 1.3149635716557424;
0.4 1.5417832451465012 1.5417832451465012 1.4561565502332532;
0.5 1.4805959005205558 1.5131111556510108 1.7008137812512039;
0.6 1.4595516325073512 1.4855563069551578 2.0793397772331597;
0.7 1.4829827610175115 1.4829827610175115 2.627016900697827;
0.8 1.4301994538212197 1.4996475378544116 3.4503110632613954;
0.9 1.4361156830610948 1.495774249766058 4.661676666357309;
]
RobRecSolver.drawAndSavePlot("kn-plot-ratios-adv_rec_sel-$n-$suffix.pdf", data[:, 1], data[:, 2:4], "α", "average ratio ρₖ", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}"])

data = [
0.1 1228.2218923059000 1204.9994106759;
0.2 1847.9697222029997 1819.1867703137002;
0.3 1966.5007362255000 1742.9089848593;
0.4 1860.3432545785004 1681.5050053505001;
0.5 1845.9325369751998 1296.8175331355;
0.6 1851.6036595614000 1266.8297030956999;
0.7 1857.5861747499002 1251.7750855817;
0.8 1840.1696963624004 1240.6232776475;
0.9 1841.4670438353000 1249.7413379723998;
]
RobRecSolver.drawAndSavePlot("kn-plot-times-adv_rec_sel-$n-$suffix.pdf", data[:, 1], data[:, 2:3], "α", "average time (s)", [L"\rho_{Adv}" L"\rho_{Sel}"])