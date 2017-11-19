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
(declare-fun VV$35$$35$325 () Int)
(declare-fun runFun () Int)
(declare-fun cast_as_int () Int)
(declare-fun VV$35$$35$378 () Int)
(declare-fun lq_karg$36$VV$35$$35$272$35$$35$k_$35$$35$273 () Int)
(declare-fun addrLen () Int)
(declare-fun papp5 () Int)
(declare-fun x_Tuple21 () Int)
(declare-fun VV$35$$35$297 () Int)
(declare-fun lq_tmp$36$x$35$$35$210 () Int)
(declare-fun x_Tuple65 () Int)
(declare-fun VV$35$$35$F$35$$35$1 () Int)
(declare-fun x_Tuple55 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792799848$35$$35$d1CM () Int)
(declare-fun VV$35$$35$348 () Int)
(declare-fun x_Tuple33 () Int)
(declare-fun GHC.Types.LT () Int)
(declare-fun x_Tuple77 () Int)
(declare-fun lq_karg$36$lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO$35$$35$k_$35$$35$204 () Bool)
(declare-fun lq_tmp$36$x$35$$35$270 () Int)
(declare-fun papp3 () Int)
(declare-fun lq_karg$36$lo$35$$35$aw4$35$$35$k_$35$$35$204 () Int)
(declare-fun x_Tuple63 () Int)
(declare-fun x_Tuple41 () Int)
(declare-fun hi$35$$35$aw5 () Int)
(declare-fun GHC.Types.False () Bool)
(declare-fun lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP () Int)
(declare-fun lq_karg$36$VV$35$$35$203$35$$35$k_$35$$35$204 () Int)
(declare-fun GHC.Types.$58$ () Int)
(declare-fun GHC.Prim.void$35$ () Int)
(declare-fun papp4 () Int)
(declare-fun GHC.Types.Module () Int)
(declare-fun x_Tuple64 () Int)
(declare-fun GHC.Types.I$35$ () Int)
(declare-fun GHC.Num.$36$fNumInt () Int)
(declare-fun autolen () Int)
(declare-fun VV$35$$35$F$35$$35$6 () Int)
(declare-fun x_Tuple52 () Int)
(declare-fun head () Int)
(declare-fun VV$35$$35$329 () Int)
(declare-fun papp2 () Int)
(declare-fun x_Tuple62 () Int)
(declare-fun lit$36$Main () Str)
(declare-fun lit$36$main () Str)
(declare-fun lq_karg$36$lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN$35$$35$k_$35$$35$204 () Bool)
(declare-fun fromJust () Int)
(declare-fun VV$35$$35$F$35$$35$8 () Int)
(declare-fun papp7 () Int)
(declare-fun lq_karg$36$lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP$35$$35$k_$35$$35$273 () Int)
(declare-fun lq_karg$36$hi$35$$35$aw5$35$$35$k_$35$$35$204 () Int)
(declare-fun VV$35$$35$F$35$$35$7 () Int)
(declare-fun x_Tuple53 () Int)
(declare-fun GHC.Types.True () Bool)
(declare-fun GHC.Types.$91$$93$ () Int)
(declare-fun lq_karg$36$lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR$35$$35$k_$35$$35$273 () Int)
(declare-fun x_Tuple71 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO () Bool)
(declare-fun VV$35$$35$F$35$$35$2 () Int)
(declare-fun lq_karg$36$ds_d1CI$35$$35$k_$35$$35$204 () Int)
(declare-fun GHC.Types.GT () Int)
(declare-fun GHC.Classes.$36$fOrdInt () Int)
(declare-fun x_Tuple74 () Int)
(declare-fun VV$35$$35$352 () Int)
(declare-fun len () Int)
(declare-fun papp6 () Int)
(declare-fun x_Tuple22 () Int)
(declare-fun x_Tuple66 () Int)
(declare-fun x_Tuple44 () Int)
(declare-fun lq_karg$36$lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO$35$$35$k_$35$$35$273 () Bool)
(declare-fun VV$35$$35$421 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792799846$35$$35$d1CK () Int)
(declare-fun x_Tuple72 () Int)
(declare-fun isJust () Int)
(declare-fun VV$35$$35$309 () Int)
(declare-fun lq_karg$36$lo$35$$35$aw4$35$$35$k_$35$$35$273 () Int)
(declare-fun VV$35$$35$332 () Int)
(declare-fun VV$35$$35$368 () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN () Bool)
(declare-fun Main.$36$trModule () Int)
(declare-fun x_Tuple31 () Int)
(declare-fun x_Tuple75 () Int)
(declare-fun GHC.Types.TrNameS () Int)
(declare-fun papp1 () Int)
(declare-fun x_Tuple61 () Int)
(declare-fun x_Tuple43 () Int)
(declare-fun tail () Int)
(declare-fun lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ () Int)
(declare-fun lq_tmp$36$x$35$$35$279 () Int)
(declare-fun lq_karg$36$lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ$35$$35$k_$35$$35$273 () Int)
(declare-fun VV$35$$35$F$35$$35$5 () Int)
(declare-fun x_Tuple51 () Int)
(declare-fun lq_tmp$36$x$35$$35$163 () Int)
(declare-fun VV$35$$35$399 () Int)
(declare-fun x_Tuple73 () Int)
(declare-fun VV$35$$35$355 () Int)
(declare-fun GHC.Types.EQ () Int)
(declare-fun lq_tmp$36$x$35$$35$292 () Int)
(declare-fun x_Tuple54 () Int)
(declare-fun lq_karg$36$lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN$35$$35$k_$35$$35$273 () Bool)
(declare-fun x_Tuple32 () Int)
(declare-fun x_Tuple76 () Int)
(declare-fun lo$35$$35$aw4 () Int)
(declare-fun snd () Int)
(declare-fun fst () Int)
(declare-fun x_Tuple42 () Int)
(declare-fun lq_karg$36$hi$35$$35$aw5$35$$35$k_$35$$35$273 () Int)
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
(assert (distinct lit$36$main lit$36$Main))
(assert (distinct GHC.Types.True GHC.Types.False))
(assert (distinct GHC.Types.EQ GHC.Types.GT GHC.Types.LT))
(assert (= (strLen lit$36$Main) 4))
(assert (= (strLen lit$36$main) 4))
(push 1)
(assert (and (or  (exists ((lq_karg$36$VV$35$$35$272$35$$35$k_$35$$35$273 Int) (lq_karg$36$lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP$35$$35$k_$35$$35$273 Int) (lq_karg$36$lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR$35$$35$k_$35$$35$273 Int) (lq_karg$36$lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO$35$$35$k_$35$$35$273 Bool) (lq_karg$36$lo$35$$35$aw4$35$$35$k_$35$$35$273 Int) (lq_karg$36$lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ$35$$35$k_$35$$35$273 Int) (lq_karg$36$lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN$35$$35$k_$35$$35$273 Bool) (lq_karg$36$hi$35$$35$aw5$35$$35$k_$35$$35$273 Int)) (and (and (= lq_karg$36$VV$35$$35$272$35$$35$k_$35$$35$273 VV$35$$35$F$35$$35$1) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO) (= lq_karg$36$lo$35$$35$aw4$35$$35$k_$35$$35$273 lo$35$$35$aw4) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN) (= lq_karg$36$hi$35$$35$aw5$35$$35$k_$35$$35$273 hi$35$$35$aw5)) (exists ((VV$35$$35$F$35$$35$5 Int)) (and (= VV$35$$35$F$35$$35$5 lo$35$$35$aw4) (and (= lq_karg$36$VV$35$$35$272$35$$35$k_$35$$35$273 VV$35$$35$F$35$$35$5) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO) (= lq_karg$36$lo$35$$35$aw4$35$$35$k_$35$$35$273 lo$35$$35$aw4) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN) (= lq_karg$36$hi$35$$35$aw5$35$$35$k_$35$$35$273 hi$35$$35$aw5)))))) (exists ((lq_karg$36$VV$35$$35$272$35$$35$k_$35$$35$273 Int) (lq_karg$36$lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP$35$$35$k_$35$$35$273 Int) (lq_karg$36$lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR$35$$35$k_$35$$35$273 Int) (lq_karg$36$lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO$35$$35$k_$35$$35$273 Bool) (lq_karg$36$lo$35$$35$aw4$35$$35$k_$35$$35$273 Int) (lq_karg$36$lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ$35$$35$k_$35$$35$273 Int) (lq_karg$36$lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN$35$$35$k_$35$$35$273 Bool) (lq_karg$36$hi$35$$35$aw5$35$$35$k_$35$$35$273 Int)) (and (and (= lq_karg$36$VV$35$$35$272$35$$35$k_$35$$35$273 VV$35$$35$F$35$$35$1) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO) (= lq_karg$36$lo$35$$35$aw4$35$$35$k_$35$$35$273 lo$35$$35$aw4) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN) (= lq_karg$36$hi$35$$35$aw5$35$$35$k_$35$$35$273 hi$35$$35$aw5)) (exists ((VV$35$$35$F$35$$35$2 Int) (VV$35$$35$368 Int)) (and (and (and (<= lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ VV$35$$35$F$35$$35$2) (< VV$35$$35$F$35$$35$2 hi$35$$35$aw5)) (and (>= (apply$35$$35$0 (as len Int) VV$35$$35$368) 0) (= VV$35$$35$368 lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR) (>= (apply$35$$35$0 (as len Int) VV$35$$35$368) 0))) (and (= lq_karg$36$VV$35$$35$272$35$$35$k_$35$$35$273 VV$35$$35$F$35$$35$2) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO) (= lq_karg$36$lo$35$$35$aw4$35$$35$k_$35$$35$273 lo$35$$35$aw4) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ) (= lq_karg$36$lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN$35$$35$k_$35$$35$273 lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN) (= lq_karg$36$hi$35$$35$aw5$35$$35$k_$35$$35$273 hi$35$$35$aw5))))))) GHC.Types.True (= lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP 1) (= lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ (+ lo$35$$35$aw4 lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP)) (>= (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR) 0) (and (= (apply$35$$35$0 (as len Int) VV$35$$35$355) (+ 1 (apply$35$$35$0 (as len Int) lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR))) (= (apply$35$$35$0 (as tail Int) VV$35$$35$355) lq_anf$36$$35$$35$7205759403792799853$35$$35$d1CR) (= (apply$35$$35$0 (as head Int) VV$35$$35$355) lo$35$$35$aw4) (>= (apply$35$$35$0 (as len Int) VV$35$$35$355) 0)) (<= lo$35$$35$aw4 hi$35$$35$aw5) (= lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN (<= lo$35$$35$aw4 hi$35$$35$aw5)) (and (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO (<= lo$35$$35$aw4 hi$35$$35$aw5)) (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN)) (not GHC.Types.False) GHC.Types.True (not GHC.Types.False) (and (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO (<= lo$35$$35$aw4 hi$35$$35$aw5)) (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN)) (and (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO (<= lo$35$$35$aw4 hi$35$$35$aw5)) (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN) lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO)))
(push 1)
(assert (not (and (<= lo$35$$35$aw4 VV$35$$35$F$35$$35$1) (< VV$35$$35$F$35$$35$1 hi$35$$35$aw5))))
(check-sat)
; SMT Says: Sat
(pop 1)
(pop 1)
(push 1)
(assert (and GHC.Types.True (= lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP 1) (= lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ (+ lo$35$$35$aw4 lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP)) (and (<= lo$35$$35$aw4 VV$35$$35$F$35$$35$6) (= VV$35$$35$F$35$$35$6 hi$35$$35$aw5)) (<= lo$35$$35$aw4 hi$35$$35$aw5) (= lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN (<= lo$35$$35$aw4 hi$35$$35$aw5)) (and (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO (<= lo$35$$35$aw4 hi$35$$35$aw5)) (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN)) (not GHC.Types.False) GHC.Types.True (not GHC.Types.False) (and (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO (<= lo$35$$35$aw4 hi$35$$35$aw5)) (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN)) (and (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO (<= lo$35$$35$aw4 hi$35$$35$aw5)) (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN) lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO)))
(push 1)
(assert (not (<= lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ VV$35$$35$F$35$$35$6)))
(check-sat)
; SMT Says: Sat
(pop 1)
(pop 1)
(push 1)
(assert (and GHC.Types.True (= lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP 1) (= lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ (+ lo$35$$35$aw4 lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP)) (<= lo$35$$35$aw4 hi$35$$35$aw5) (and (= VV$35$$35$F$35$$35$7 (+ lo$35$$35$aw4 lq_anf$36$$35$$35$7205759403792799851$35$$35$d1CP)) (= VV$35$$35$F$35$$35$7 lq_anf$36$$35$$35$7205759403792799852$35$$35$d1CQ)) (= lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN (<= lo$35$$35$aw4 hi$35$$35$aw5)) (and (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO (<= lo$35$$35$aw4 hi$35$$35$aw5)) (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN)) (not GHC.Types.False) GHC.Types.True (not GHC.Types.False) (and (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO (<= lo$35$$35$aw4 hi$35$$35$aw5)) (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN)) (and (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO (<= lo$35$$35$aw4 hi$35$$35$aw5)) (= lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799849$35$$35$d1CN) lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO lq_anf$36$$35$$35$7205759403792799850$35$$35$d1CO)))
(push 1)
(assert (not (and (< VV$35$$35$F$35$$35$7 lo$35$$35$aw4) (>= VV$35$$35$F$35$$35$7 0))))
(check-sat)
; SMT Says: Sat
(pop 1)
(pop 1)
(push 1)
(assert false)
(push 1)
(assert (not (and (<= lo$35$$35$aw4 VV$35$$35$F$35$$35$8) (< VV$35$$35$F$35$$35$8 hi$35$$35$aw5))))
(check-sat)
; SMT Says: Unsat
(pop 1)
(pop 1)
(exit)
