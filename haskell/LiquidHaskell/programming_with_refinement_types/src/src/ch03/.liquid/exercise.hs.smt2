(set-option :auto-config false)
(set-option :model true)
(set-option :model.partial false)

(set-option :smt.mbqi false)
(define-sort Str () Int)
(declare-fun strLen (Str) Int)
(declare-fun subString (Str Int Int) Str)
(declare-fun concatString (Str Str) Str)
(define-sort Elt () Int)
(define-sort Set () (Array Elt Bool))
(define-fun smt_set_emp () Set ((as const Set) false))
(define-fun smt_set_mem ((x Elt) (s Set)) Bool (select s x))
(define-fun smt_set_add ((s Set) (x Elt)) Set (store s x true))
(define-fun smt_set_cup ((s1 Set) (s2 Set)) Set ((_ map or) s1 s2))
(define-fun smt_set_cap ((s1 Set) (s2 Set)) Set ((_ map and) s1 s2))
(define-fun smt_set_com ((s Set)) Set ((_ map not) s))
(define-fun smt_set_dif ((s1 Set) (s2 Set)) Set (smt_set_cap s1 (smt_set_com s2)))
(define-fun smt_set_sub ((s1 Set) (s2 Set)) Bool (= smt_set_emp (smt_set_dif s1 s2)))
(define-sort Map () (Array Elt Elt))
(define-fun smt_map_sel ((m Map) (k Elt)) Elt (select m k))
(define-fun smt_map_sto ((m Map) (k Elt) (v Elt)) Map (store m k v))
(define-fun bool_to_int ((b Bool)) Int (ite b 1 0))
(define-fun Z3_OP_MUL ((x Int) (y Int)) Int (* x y))
(define-fun Z3_OP_DIV ((x Int) (y Int)) Int (div x y))
(declare-fun runFun () Int)
(declare-fun cast_as_int () Int)
(declare-fun n$35$$35$aRy () Int)
(declare-fun VV$35$$35$1287 () Int)
(declare-fun addrLen () Int)
(declare-fun lit$36$$47$home$47$bm12$47$repo$47$guchi$47$til$47$haskell$47$LiquidHaskell$47$programming_with_refinement_types$47$src$45$dir$47$src$47$ch03$47$exercise.hs () Str)
(declare-fun papp5 () Int)
(declare-fun x_Tuple21 () Int)
(declare-fun lq_tmp$36$x$35$$35$821 () Int)
(declare-fun x_Tuple65 () Int)
(declare-fun lq_tmp$36$x$35$$35$426 () Int)
(declare-fun VV$35$$35$F$35$$35$1 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803654$35$$35$d2Ca () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803620$35$$35$d2BC () Str)
(declare-fun lq_anf$36$$35$$35$7205759403792803624$35$$35$d2BG () Str)
(declare-fun x_Tuple55 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 () Int)
(declare-fun x_Tuple33 () Int)
(declare-fun lit$36$divide$32$by$32$zero () Str)
(declare-fun GHC.Types.LT () Int)
(declare-fun x_Tuple77 () Int)
(declare-fun VV$35$$35$1240 () Int)
(declare-fun VV$35$$35$1143 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803649$35$$35$d2C5 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803628$35$$35$d2BK () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803635$35$$35$d2BR () Int)
(declare-fun papp3 () Int)
(declare-fun x_Tuple63 () Int)
(declare-fun x_Tuple41 () Int)
(declare-fun x$35$$35$a1hJ () Int)
(declare-fun VV$35$$35$1012 () Int)
(declare-fun VV$35$$35$1030 () Int)
(declare-fun GHC.Types.False () Bool)
(declare-fun lq_rnm$36$fldList$35$$35$188 () Int)
(declare-fun n$35$$35$a10s () Int)
(declare-fun GHC.Types.$58$ () Int)
(declare-fun lit$36$error () Str)
(declare-fun ds_d2Bi () Int)
(declare-fun lq_tmp$36$x$35$$35$471 () Int)
(declare-fun papp4 () Int)
(declare-fun GHC.Types.Module () Int)
(declare-fun lq_tmp$36$x$35$$35$651 () Int)
(declare-fun lq_tmp$36$x$35$$35$802 () Int)
(declare-fun x_Tuple64 () Int)
(declare-fun GHC.Tuple.$40$$41$ () Int)
(declare-fun GHC.Types.I$35$ () Int)
(declare-fun VV$35$$35$1037 () Int)
(declare-fun GHC.Stack.Types.SrcLoc () Int)
(declare-fun GHC.Num.$36$fNumInt () Int)
(declare-fun VV$35$$35$1114 () Bool)
(declare-fun VV$35$$35$1185 () Int)
(declare-fun total$35$$35$a10r () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803630$35$$35$d2BM () Int)
(declare-fun VV$35$$35$1265 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803632$35$$35$d2BO () Int)
(declare-fun autolen () Int)
(declare-fun x_Tuple52 () Int)
(declare-fun VV$35$$35$967 () Int)
(declare-fun head () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803638$35$$35$d2BU () Str)
(declare-fun lq_anf$36$$35$$35$7205759403792803626$35$$35$d2BI () Str)
(declare-fun lq_anf$36$$35$$35$7205759403792803643$35$$35$d2BZ () Bool)
(declare-fun msg$35$$35$aRi () Str)
(declare-fun papp2 () Int)
(declare-fun x_Tuple62 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803641$35$$35$d2BX () Int)
(declare-fun lit$36$Main () Str)
(declare-fun lit$36$yikes$44$$32$assertion$32$fails$33$ () Str)
(declare-fun GHC.Stack.Types.emptyCallStack () Int)
(declare-fun VV$35$$35$1236 () Int)
(declare-fun lit$36$main () Str)
(declare-fun lq_anf$36$$35$$35$7205759403792803633$35$$35$d2BP () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803637$35$$35$d2BT () Str)
(declare-fun fromJust () Int)
(declare-fun papp7 () Int)
(declare-fun VV$35$$35$F$35$$35$11 () Str)
(declare-fun VV$35$$35$F$35$$35$7 () Bool)
(declare-fun x_Tuple53 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803621$35$$35$d2BD () Str)
(declare-fun GHC.Types.True () Bool)
(declare-fun lq_anf$36$$35$$35$7205759403792803629$35$$35$d2BL () Int)
(declare-fun GHC.Types.$91$$93$ () Int)
(declare-fun fix$36$$36$dIP_a2lP () Int)
(declare-fun x_Tuple71 () Int)
(declare-fun GHC.Tuple.$40$$44$$41$ () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803623$35$$35$d2BF () Str)
(declare-fun VV$35$$35$1278 () Int)
(declare-fun VV$35$$35$1063 () Int)
(declare-fun fldList () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803651$35$$35$d2C7 () Str)
(declare-fun lq_tmp$36$x$35$$35$425 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803619$35$$35$d2BB () Str)
(declare-fun Data.Foldable.$36$fFoldable$91$$93$ () Int)
(declare-fun VV$35$$35$963 () Int)
(declare-fun GHC.Types.GT () Int)
(declare-fun VV$35$$35$1159 () Int)
(declare-fun GHC.Integer.Type.$36$fEqInteger () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803650$35$$35$d2C6 () Str)
(declare-fun x_Tuple74 () Int)
(declare-fun VV$35$$35$1261 () Int)
(declare-fun len () Int)
(declare-fun papp6 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803647$35$$35$d2C3 () Int)
(declare-fun VV$35$$35$F$35$$35$10 () Str)
(declare-fun x_Tuple22 () Int)
(declare-fun x_Tuple66 () Int)
(declare-fun x_Tuple44 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803645$35$$35$d2C1 () Int)
(declare-fun VV$35$$35$1021 () Int)
(declare-fun x_Tuple72 () Int)
(declare-fun VV$35$$35$1047 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803639$35$$35$d2BV () Int)
(declare-fun isJust () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803631$35$$35$d2BN () Int)
(declare-fun Main.yes () Int)
(declare-fun VV$35$$35$F$35$$35$4 () Int)
(declare-fun ds_d2Bv () Bool)
(declare-fun Main.$36$trModule () Int)
(declare-fun x_Tuple31 () Int)
(declare-fun x_Tuple75 () Int)
(declare-fun VV$35$$35$995 () Int)
(declare-fun lq_tmp$36$x$35$$35$525 () Int)
(declare-fun lq_tmp$36$x$35$$35$929 () Int)
(declare-fun VV$35$$35$1040 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803640$35$$35$d2BW () Int)
(declare-fun VV$35$$35$1059 () Int)
(declare-fun VV$35$$35$1163 () Int)
(declare-fun lq_tmp$36$x$35$$35$318 () Int)
(declare-fun GHC.Types.TrNameS () Int)
(declare-fun VV$35$$35$F$35$$35$3 () Str)
(declare-fun papp1 () Int)
(declare-fun ds_d2Bl () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803634$35$$35$d2BQ () Int)
(declare-fun x_Tuple61 () Int)
(declare-fun x_Tuple43 () Int)
(declare-fun lq_tmp$36$x$35$$35$632 () Int)
(declare-fun GHC.Num.$36$fNumInteger () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803653$35$$35$d2C9 () Int)
(declare-fun tail () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803636$35$$35$d2BS () Bool)
(declare-fun lq_tmp$36$x$35$$35$575 () Int)
(declare-fun VV$35$$35$1274 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8 () Int)
(declare-fun VV$35$$35$1147 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803622$35$$35$d2BE () Str)
(declare-fun ds_d2Bg () Int)
(declare-fun x_Tuple51 () Int)
(declare-fun VV$35$$35$1291 () Int)
(declare-fun x_Tuple73 () Int)
(declare-fun lq_tmp$36$x$35$$35$815 () Int)
(declare-fun GHC.Types.EQ () Int)
(declare-fun lq_tmp$36$x$35$$35$463 () Int)
(declare-fun lq_tmp$36$x$35$$35$427 () Int)
(declare-fun x_Tuple54 () Int)
(declare-fun VV$35$$35$1078 () Int)
(declare-fun x_Tuple32 () Int)
(declare-fun x_Tuple76 () Int)
(declare-fun VV$35$$35$1181 () Int)
(declare-fun VV$35$$35$999 () Int)
(declare-fun VV$35$$35$980 () Int)
(declare-fun VV$35$$35$1008 () Int)
(declare-fun lq_tmp$36$x$35$$35$897 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803642$35$$35$d2BY () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803625$35$$35$d2BH () Str)
(declare-fun GHC.Real.$36$fIntegralInt () Int)
(declare-fun snd () Int)
(declare-fun fst () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792803627$35$$35$d2BJ () Int)
(declare-fun x_Tuple42 () Int)
(declare-fun VV$35$$35$977 () Int)
(declare-fun apply$35$$35$13 (Int (_ BitVec 32)) Bool)
(declare-fun apply$35$$35$9 (Int Str) Bool)
(declare-fun apply$35$$35$6 (Int Bool) Str)
(declare-fun apply$35$$35$11 (Int Str) (_ BitVec 32))
(declare-fun apply$35$$35$15 (Int (_ BitVec 32)) (_ BitVec 32))
(declare-fun apply$35$$35$0 (Int Int) Int)
(declare-fun apply$35$$35$8 (Int Str) Int)
(declare-fun apply$35$$35$1 (Int Int) Bool)
(declare-fun apply$35$$35$7 (Int Bool) (_ BitVec 32))
(declare-fun apply$35$$35$14 (Int (_ BitVec 32)) Str)
(declare-fun apply$35$$35$10 (Int Str) Str)
(declare-fun apply$35$$35$5 (Int Bool) Bool)
(declare-fun apply$35$$35$2 (Int Int) Str)
(declare-fun apply$35$$35$12 (Int (_ BitVec 32)) Int)
(declare-fun apply$35$$35$3 (Int Int) (_ BitVec 32))
(declare-fun apply$35$$35$4 (Int Bool) Int)
(declare-fun smt_lambda$35$$35$13 ((_ BitVec 32) Bool) Int)
(declare-fun smt_lambda$35$$35$9 (Str Bool) Int)
(declare-fun smt_lambda$35$$35$6 (Bool Str) Int)
(declare-fun smt_lambda$35$$35$11 (Str (_ BitVec 32)) Int)
(declare-fun smt_lambda$35$$35$15 ((_ BitVec 32) (_ BitVec 32)) Int)
(declare-fun smt_lambda$35$$35$0 (Int Int) Int)
(declare-fun smt_lambda$35$$35$8 (Str Int) Int)
(declare-fun smt_lambda$35$$35$1 (Int Bool) Int)
(declare-fun smt_lambda$35$$35$7 (Bool (_ BitVec 32)) Int)
(declare-fun smt_lambda$35$$35$14 ((_ BitVec 32) Str) Int)
(declare-fun smt_lambda$35$$35$10 (Str Str) Int)
(declare-fun smt_lambda$35$$35$5 (Bool Bool) Int)
(declare-fun smt_lambda$35$$35$2 (Int Str) Int)
(declare-fun smt_lambda$35$$35$12 ((_ BitVec 32) Int) Int)
(declare-fun smt_lambda$35$$35$3 (Int (_ BitVec 32)) Int)
(declare-fun smt_lambda$35$$35$4 (Bool Int) Int)
(declare-fun lam_arg$35$$35$1$35$$35$0 () Int)
(declare-fun lam_arg$35$$35$2$35$$35$0 () Int)
(declare-fun lam_arg$35$$35$3$35$$35$0 () Int)
(declare-fun lam_arg$35$$35$4$35$$35$0 () Int)
(declare-fun lam_arg$35$$35$5$35$$35$0 () Int)
(declare-fun lam_arg$35$$35$6$35$$35$0 () Int)
(declare-fun lam_arg$35$$35$7$35$$35$0 () Int)
(declare-fun lam_arg$35$$35$1$35$$35$8 () Str)
(declare-fun lam_arg$35$$35$2$35$$35$8 () Str)
(declare-fun lam_arg$35$$35$3$35$$35$8 () Str)
(declare-fun lam_arg$35$$35$4$35$$35$8 () Str)
(declare-fun lam_arg$35$$35$5$35$$35$8 () Str)
(declare-fun lam_arg$35$$35$6$35$$35$8 () Str)
(declare-fun lam_arg$35$$35$7$35$$35$8 () Str)
(declare-fun lam_arg$35$$35$1$35$$35$12 () (_ BitVec 32))
(declare-fun lam_arg$35$$35$2$35$$35$12 () (_ BitVec 32))
(declare-fun lam_arg$35$$35$3$35$$35$12 () (_ BitVec 32))
(declare-fun lam_arg$35$$35$4$35$$35$12 () (_ BitVec 32))
(declare-fun lam_arg$35$$35$5$35$$35$12 () (_ BitVec 32))
(declare-fun lam_arg$35$$35$6$35$$35$12 () (_ BitVec 32))
(declare-fun lam_arg$35$$35$7$35$$35$12 () (_ BitVec 32))
(declare-fun lam_arg$35$$35$1$35$$35$4 () Bool)
(declare-fun lam_arg$35$$35$2$35$$35$4 () Bool)
(declare-fun lam_arg$35$$35$3$35$$35$4 () Bool)
(declare-fun lam_arg$35$$35$4$35$$35$4 () Bool)
(declare-fun lam_arg$35$$35$5$35$$35$4 () Bool)
(declare-fun lam_arg$35$$35$6$35$$35$4 () Bool)
(declare-fun lam_arg$35$$35$7$35$$35$4 () Bool)

(assert (distinct lit$36$main lit$36$yikes$44$$32$assertion$32$fails$33$ lit$36$Main lit$36$error lit$36$divide$32$by$32$zero lit$36$$47$home$47$bm12$47$repo$47$guchi$47$til$47$haskell$47$LiquidHaskell$47$programming_with_refinement_types$47$src$45$dir$47$src$47$ch03$47$exercise.hs))
(assert (distinct GHC.Types.True GHC.Types.False))
(assert (distinct GHC.Types.EQ GHC.Types.GT GHC.Types.LT))
(assert (= (strLen lit$36$$47$home$47$bm12$47$repo$47$guchi$47$til$47$haskell$47$LiquidHaskell$47$programming_with_refinement_types$47$src$45$dir$47$src$47$ch03$47$exercise.hs) 110))
(assert (= (strLen lit$36$divide$32$by$32$zero) 14))
(assert (= (strLen lit$36$error) 5))
(assert (= (strLen lit$36$Main) 4))
(assert (= (strLen lit$36$yikes$44$$32$assertion$32$fails$33$) 23))
(assert (= (strLen lit$36$main) 4))
(push 1)
(assert (and (not GHC.Types.False) (and (>= n$35$$35$a10s 0) (= n$35$$35$a10s (apply$35$$35$0 (as len Int) ds_d2Bl))) GHC.Types.True (not GHC.Types.False) GHC.Types.True (>= (apply$35$$35$0 (as len Int) ds_d2Bl) 0) (and (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) 0) (= lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8 ds_d2Bl) (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) 0)) (and (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) 0) (= lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8 ds_d2Bl) (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) 0) (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) 0)) (and (>= VV$35$$35$F$35$$35$1 0) (= VV$35$$35$F$35$$35$1 (apply$35$$35$0 (as len Int) ds_d2Bl)) (= VV$35$$35$F$35$$35$1 n$35$$35$a10s)) (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803654$35$$35$d2Ca) 0) (and (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) 0) (= lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8 ds_d2Bl) (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) 0) (= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) (+ 1 (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803654$35$$35$d2Ca))) (= (apply$35$$35$0 (as tail Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) lq_anf$36$$35$$35$7205759403792803654$35$$35$d2Ca) (= (apply$35$$35$0 (as head Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) lq_anf$36$$35$$35$7205759403792803653$35$$35$d2C9) (= lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8 (apply$35$$35$0 (apply$35$$35$0 (as GHC.Types.$58$ Int) lq_anf$36$$35$$35$7205759403792803653$35$$35$d2C9) lq_anf$36$$35$$35$7205759403792803654$35$$35$d2Ca)) (= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) (+ 1 (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803654$35$$35$d2Ca))) (= (apply$35$$35$0 (as tail Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) lq_anf$36$$35$$35$7205759403792803654$35$$35$d2Ca) (= (apply$35$$35$0 (as head Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) lq_anf$36$$35$$35$7205759403792803653$35$$35$d2C9) (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803652$35$$35$d2C8) 0))))
(push 1)
(assert (not (not (= VV$35$$35$F$35$$35$1 0))))
(check-sat)
; SMT Says: Unsat
(pop 1)
(pop 1)
(push 1)
(assert (and (not GHC.Types.False) (and (not (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 0)) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bg)) GHC.Types.True (not GHC.Types.False) (and (not (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 0)) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bg) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bi) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bi) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bi)) (= lq_anf$36$$35$$35$7205759403792803649$35$$35$d2C5 ds_d2Bi) GHC.Types.True (and (= lq_anf$36$$35$$35$7205759403792803649$35$$35$d2C5 ds_d2Bi) (= lq_anf$36$$35$$35$7205759403792803649$35$$35$d2C5 0)) (= lq_anf$36$$35$$35$7205759403792803650$35$$35$d2C6 lit$36$divide$32$by$32$zero) (and (= lq_anf$36$$35$$35$7205759403792803651$35$$35$d2C7 lq_anf$36$$35$$35$7205759403792803650$35$$35$d2C6) (= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803651$35$$35$d2C7) (strLen lq_anf$36$$35$$35$7205759403792803650$35$$35$d2C6)) (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803651$35$$35$d2C7) 0)) (and (= VV$35$$35$F$35$$35$3 lq_anf$36$$35$$35$7205759403792803650$35$$35$d2C6) (= (apply$35$$35$0 (as len Int) VV$35$$35$F$35$$35$3) (strLen lq_anf$36$$35$$35$7205759403792803650$35$$35$d2C6)) (>= (apply$35$$35$0 (as len Int) VV$35$$35$F$35$$35$3) 0) (= VV$35$$35$F$35$$35$3 lq_anf$36$$35$$35$7205759403792803651$35$$35$d2C7) (>= (apply$35$$35$0 (as len Int) VV$35$$35$F$35$$35$3) 0)) (not (= ds_d2Bg 0)) (and (not (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 0)) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bg))))
(push 1)
(assert (not false))
(check-sat)
; SMT Says: Unsat
(pop 1)
(pop 1)
(push 1)
(assert (and (not GHC.Types.False) (and (not (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 0)) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bg)) GHC.Types.True (not GHC.Types.False) (and (not (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 0)) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bg) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bi) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bi) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bi)) (= lq_anf$36$$35$$35$7205759403792803649$35$$35$d2C5 ds_d2Bi) GHC.Types.True (and (= lq_anf$36$$35$$35$7205759403792803649$35$$35$d2C5 ds_d2Bi) (not (= lq_anf$36$$35$$35$7205759403792803649$35$$35$d2C5 0))) (not (= ds_d2Bg 0)) (and (not (= VV$35$$35$F$35$$35$4 0)) (= VV$35$$35$F$35$$35$4 ds_d2Bg)) (and (not (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 0)) (= lq_anf$36$$35$$35$7205759403792803648$35$$35$d2C4 ds_d2Bg))))
(push 1)
(assert (not (not (= VV$35$$35$F$35$$35$4 0))))
(check-sat)
; SMT Says: Unsat
(pop 1)
(pop 1)
(push 1)
(assert (and (not GHC.Types.False) GHC.Types.True (not GHC.Types.False) (= lq_anf$36$$35$$35$7205759403792803639$35$$35$d2BV 1) (= lq_anf$36$$35$$35$7205759403792803640$35$$35$d2BW 1) GHC.Types.True (= lq_anf$36$$35$$35$7205759403792803641$35$$35$d2BX (+ lq_anf$36$$35$$35$7205759403792803639$35$$35$d2BV lq_anf$36$$35$$35$7205759403792803640$35$$35$d2BW)) (= lq_anf$36$$35$$35$7205759403792803642$35$$35$d2BY 2) (= lq_anf$36$$35$$35$7205759403792803643$35$$35$d2BZ (= lq_anf$36$$35$$35$7205759403792803641$35$$35$d2BX lq_anf$36$$35$$35$7205759403792803642$35$$35$d2BY)) (and (= VV$35$$35$F$35$$35$7 (= lq_anf$36$$35$$35$7205759403792803641$35$$35$d2BX lq_anf$36$$35$$35$7205759403792803642$35$$35$d2BY)) (= VV$35$$35$F$35$$35$7 lq_anf$36$$35$$35$7205759403792803643$35$$35$d2BZ))))
(push 1)
(assert (not VV$35$$35$F$35$$35$7))
(check-sat)
; SMT Says: Unsat
(pop 1)
(pop 1)
(push 1)
(assert (and (not GHC.Types.False) (and (= VV$35$$35$F$35$$35$10 lq_anf$36$$35$$35$7205759403792803637$35$$35$d2BT) (= (apply$35$$35$0 (as len Int) VV$35$$35$F$35$$35$10) (strLen lq_anf$36$$35$$35$7205759403792803637$35$$35$d2BT)) (>= (apply$35$$35$0 (as len Int) VV$35$$35$F$35$$35$10) 0) (= VV$35$$35$F$35$$35$10 lq_anf$36$$35$$35$7205759403792803638$35$$35$d2BU) (>= (apply$35$$35$0 (as len Int) VV$35$$35$F$35$$35$10) 0)) GHC.Types.True (not GHC.Types.False) GHC.Types.True ds_d2Bv (and lq_anf$36$$35$$35$7205759403792803636$35$$35$d2BS (= lq_anf$36$$35$$35$7205759403792803636$35$$35$d2BS ds_d2Bv)) (and lq_anf$36$$35$$35$7205759403792803636$35$$35$d2BS (= lq_anf$36$$35$$35$7205759403792803636$35$$35$d2BS ds_d2Bv)) (and lq_anf$36$$35$$35$7205759403792803636$35$$35$d2BS (= lq_anf$36$$35$$35$7205759403792803636$35$$35$d2BS ds_d2Bv) (not lq_anf$36$$35$$35$7205759403792803636$35$$35$d2BS) (not lq_anf$36$$35$$35$7205759403792803636$35$$35$d2BS) (not lq_anf$36$$35$$35$7205759403792803636$35$$35$d2BS)) (= lq_anf$36$$35$$35$7205759403792803637$35$$35$d2BT lit$36$yikes$44$$32$assertion$32$fails$33$) (and (= lq_anf$36$$35$$35$7205759403792803638$35$$35$d2BU lq_anf$36$$35$$35$7205759403792803637$35$$35$d2BT) (= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803638$35$$35$d2BU) (strLen lq_anf$36$$35$$35$7205759403792803637$35$$35$d2BT)) (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792803638$35$$35$d2BU) 0))))
(push 1)
(assert (not false))
(check-sat)
; SMT Says: Unsat
(pop 1)
(pop 1)
(push 1)
(assert false)
(push 1)
(assert (not false))
(check-sat)
; SMT Says: Unsat
(pop 1)
(pop 1)
(exit)
