;;; Compiled by f2cl version 2.0 beta 2002-05-06
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;           (:coerce-assigns :as-needed) (:array-type ':simple-array)
;;;           (:array-slicing nil) (:declare-common nil)
;;;           (:float-format double-float))

(in-package "SLATEC")


(let ((nam20 0)
      (nath0 0)
      (nam21 0)
      (nath1 0)
      (nam22 0)
      (nath2 0)
      (xsml 0.0)
      (am20cs (make-array 57 :element-type 'double-float))
      (ath0cs (make-array 53 :element-type 'double-float))
      (am21cs (make-array 60 :element-type 'double-float))
      (ath1cs (make-array 58 :element-type 'double-float))
      (am22cs (make-array 74 :element-type 'double-float))
      (ath2cs (make-array 72 :element-type 'double-float))
      (pi4 0.7853981633974483)
      (first nil))
  (declare (type f2cl-lib:logical first)
           (type (simple-array double-float (72)) ath2cs)
           (type (simple-array double-float (74)) am22cs)
           (type (simple-array double-float (58)) ath1cs)
           (type (simple-array double-float (60)) am21cs)
           (type (simple-array double-float (53)) ath0cs)
           (type (simple-array double-float (57)) am20cs)
           (type double-float pi4 xsml)
           (type f2cl-lib:integer4 nath2 nam22 nath1 nam21 nath0 nam20))
  (f2cl-lib:fset (f2cl-lib:fref am20cs (1) ((1 57))) 0.010871674908656186)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (2) ((1 57))) 3.6948922898266356e-4)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (3) ((1 57))) 4.406801004846896e-6)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (4) ((1 57))) 1.4368676236191116e-7)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (5) ((1 57))) 8.242755523900783e-9)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (6) ((1 57))) 6.844267588936616e-10)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (7) ((1 57))) 7.395666972827394e-11)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (8) ((1 57))) 9.74595633696825e-12)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (9) ((1 57))) 1.5007688582940576e-12)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (10) ((1 57))) 2.621479102215276e-13)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (11) ((1 57))) 5.083541113764873e-14)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (12) ((1 57))) 1.0768475335881145e-14)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (13) ((1 57))) 2.4609128661843344e-15)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (14) ((1 57))) 6.007863803586564e-16)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (15) ((1 57))) 1.554491561023881e-16)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (16) ((1 57))) 4.235351250355766e-17)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (17) ((1 57))) 1.2086216628929984e-17)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (18) ((1 57))) 3.5960965121465827e-18)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (19) ((1 57))) 1.1113421838639566e-18)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (20) ((1 57))) 3.5555953243236665e-19)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (21) ((1 57))) 1.1743302160013933e-19)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (22) ((1 57))) 3.993974546610776e-20)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (23) ((1 57))) 1.3957667152891634e-20)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (24) ((1 57))) 5.00240055309236e-21)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (25) ((1 57))) 1.8355276095813264e-21)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (26) ((1 57))) 6.884909981792027e-22)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (27) ((1 57))) 2.63631035611417e-22)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (28) ((1 57))) 1.0292489023733835e-22)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (29) ((1 57))) 4.0924696667159494e-23)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (30) ((1 57))) 1.6555857340673466e-23)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (31) ((1 57))) 6.807974670630332e-24)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (32) ((1 57))) 2.8432655993407985e-24)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (33) ((1 57))) 1.2050739834896525e-24)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (34) ((1 57))) 5.179612432875051e-25)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (35) ((1 57))) 2.256226134275628e-25)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (36) ((1 57))) 9.954188011477453e-26)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (37) ((1 57))) 4.4455169639734243e-26)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (38) ((1 57))) 2.0086519546150114e-26)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (39) ((1 57))) 9.177863441517752e-27)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (40) ((1 57))) 4.2387295810558934e-27)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (41) ((1 57))) 1.9778927200784616e-27)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (42) ((1 57))) 9.321163512846207e-28)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (43) ((1 57))) 4.434821332499182e-28)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (44) ((1 57))) 2.1294567236557393e-28)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (45) ((1 57))) 1.0315856965107599e-28)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (46) ((1 57))) 5.040237730225912e-29)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (47) ((1 57))) 2.4830130457015592e-29)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (48) ((1 57))) 1.2330178312856219e-29)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (49) ((1 57))) 6.170334499205217e-30)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (50) ((1 57))) 3.110926174159188e-30)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (51) ((1 57))) 1.5798308520170615e-30)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (52) ((1 57))) 8.079319875382837e-31)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (53) ((1 57))) 4.1599739413866754e-31)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (54) ((1 57))) 2.156109340977169e-31)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (55) ((1 57))) 1.124688572658692e-31)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (56) ((1 57))) 5.903315606328382e-32)
  (f2cl-lib:fset (f2cl-lib:fref am20cs (57) ((1 57))) 3.1173566769292854e-32)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (1) ((1 53))) -0.08172601764161636)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (2) ((1 53))) -8.004012824788274e-4)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (3) ((1 53))) -3.1865252687821133e-6)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (4) ((1 53))) -6.68838826647751e-8)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (5) ((1 53))) -2.9317592849945645e-9)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (6) ((1 53))) -2.011263760883622e-10)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (7) ((1 53))) -1.8775226780559734e-11)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (8) ((1 53))) -2.199637137704601e-12)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (9) ((1 53))) -3.0716166825922725e-13)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (10) ((1 53))) -4.936140553673418e-14)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (11) ((1 53))) -8.902833722583661e-15)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (12) ((1 53))) -1.7689877646152727e-15)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (13) ((1 53))) -3.8178686890322777e-16)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (14) ((1 53))) -8.851159014819947e-17)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (15) ((1 53))) -2.1848181814143658e-17)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (16) ((1 53))) -5.700849046986453e-18)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (17) ((1 53))) -1.5631211221778757e-18)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (18) ((1 53))) -4.481437996768995e-19)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (19) ((1 53))) -1.337794883736188e-19)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (20) ((1 53))) -4.143340036874114e-20)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (21) ((1 53))) -1.3272633857188051e-20)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (22) ((1 53))) -4.3857285891284403e-21)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (23) ((1 53))) -1.491360695952818e-21)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (24) ((1 53))) -5.20810473863071e-22)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (25) ((1 53))) -1.8643822223904988e-22)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (26) ((1 53))) -6.83026375116797e-23)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (27) ((1 53))) -2.5571170580293295e-23)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (28) ((1 53))) -9.770158640254301e-24)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (29) ((1 53))) -3.805161433416679e-24)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (30) ((1 53))) -1.509022750737054e-24)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (31) ((1 53))) -6.087551341242424e-25)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (32) ((1 53))) -2.4958795138097112e-25)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (33) ((1 53))) -1.0391576545819207e-25)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (34) ((1 53))) -4.3902359139768465e-26)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (35) ((1 53))) -1.8807906784479905e-26)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (36) ((1 53))) -8.165070764199465e-27)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (37) ((1 53))) -3.589944503749751e-27)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (38) ((1 53))) -1.5976581266321332e-27)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (39) ((1 53))) -7.193250175703824e-28)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (40) ((1 53))) -3.274943012727857e-28)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (41) ((1 53))) -1.5070424457836906e-28)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (42) ((1 53))) -7.006624198319905e-29)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (43) ((1 53))) -3.289907402983718e-29)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (44) ((1 53))) -1.5595180843651466e-29)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (45) ((1 53))) -7.460690508208254e-30)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (46) ((1 53))) -3.6008770348246616e-30)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (47) ((1 53))) -1.752851437473772e-30)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (48) ((1 53))) -8.603275775188512e-31)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (49) ((1 53))) -4.256432603226946e-31)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (50) ((1 53))) -2.1221618650442628e-31)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (51) ((1 53))) -1.0659961567048792e-31)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (52) ((1 53))) -5.39356860881695e-32)
  (f2cl-lib:fset (f2cl-lib:fref ath0cs (53) ((1 53))) -2.748174851043955e-32)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (1) ((1 60))) 0.005927902667213096)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (2) ((1 60))) 0.002005694053931652)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (3) ((1 60))) 9.110818502622758e-5)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (4) ((1 60))) 8.498943063720471e-6)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (5) ((1 60))) 1.132979089769131e-6)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (6) ((1 60))) 1.8751794610066647e-7)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (7) ((1 60))) 3.593065190182458e-8)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (8) ((1 60))) 7.657577140716839e-9)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (9) ((1 60))) 1.769999671680392e-9)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (10) ((1 60))) 4.3625955565459895e-10)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (11) ((1 60))) 1.1329164133785323e-10)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (12) ((1 60))) 3.0725769098241923e-11)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (13) ((1 60))) 8.644824164822009e-12)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (14) ((1 60))) 2.510152500609244e-12)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (15) ((1 60))) 7.491024967644404e-13)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (16) ((1 60))) 2.2899692848799408e-13)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (17) ((1 60))) 7.151136589279877e-14)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (18) ((1 60))) 2.2760792495956683e-14)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (19) ((1 60))) 7.369421427608865e-15)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (20) ((1 60))) 2.4232867526782748e-15)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (21) ((1 60))) 8.0815377454824e-16)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (22) ((1 60))) 2.7300807980435615e-16)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (23) ((1 60))) 9.332360708913853e-17)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (24) ((1 60))) 3.225080996810846e-17)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (25) ((1 60))) 1.1258193234644454e-17)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (26) ((1 60))) 3.9669946398693895e-18)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (27) ((1 60))) 1.410065679443195e-18)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (28) ((1 60))) 5.053020865378514e-19)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (29) ((1 60))) 1.8246152321594516e-19)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (30) ((1 60))) 6.635845682621304e-20)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (31) ((1 60))) 2.429637316312762e-20)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (32) ((1 60))) 8.952389151236877e-21)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (33) ((1 60))) 3.318452893500508e-21)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (34) ((1 60))) 1.237061961886583e-21)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (35) ((1 60))) 4.636366770123908e-22)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (36) ((1 60))) 1.7465313594776447e-22)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (37) ((1 60))) 6.611168102349911e-23)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (38) ((1 60))) 2.514099189940725e-23)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (39) ((1 60))) 9.602749955717325e-24)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (40) ((1 60))) 3.6832495228929635e-24)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (41) ((1 60))) 1.4184313826915912e-24)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (42) ((1 60))) 5.483426742769357e-25)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (43) ((1 60))) 2.1276105462311876e-25)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (44) ((1 60))) 8.284437008494184e-26)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (45) ((1 60))) 3.2367056392612703e-26)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (46) ((1 60))) 1.2686888296328608e-26)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (47) ((1 60))) 4.9884381899212166e-27)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (48) ((1 60))) 1.967345844676494e-27)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (49) ((1 60))) 7.781359710203269e-28)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (50) ((1 60))) 3.0863394149891116e-28)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (51) ((1 60))) 1.2274464704545314e-28)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (52) ((1 60))) 4.894312791342922e-29)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (53) ((1 60))) 1.956468798029098e-29)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (54) ((1 60))) 7.839889529224262e-30)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (55) ((1 60))) 3.1489691400248415e-30)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (56) ((1 60))) 1.267697631372507e-30)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (57) ((1 60))) 5.114706919069001e-31)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (58) ((1 60))) 2.0680170979553877e-31)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (59) ((1 60))) 8.37891344768519e-32)
  (f2cl-lib:fset (f2cl-lib:fref am21cs (60) ((1 60))) 3.4016899197148986e-32)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (1) ((1 58))) -0.06972849916208884)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (2) ((1 58))) -0.005108722790650046)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (3) ((1 58))) -8.644335996989756e-5)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (4) ((1 58))) -5.604720044235264e-6)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (5) ((1 58))) -6.045735125623898e-7)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (6) ((1 58))) -8.639802632488335e-8)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (7) ((1 58))) -1.4808094843099268e-8)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (8) ((1 58))) -2.885809334577236e-9)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (9) ((1 58))) -6.1916319756657e-10)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (10) ((1 58))) -1.4319928088609582e-10)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (11) ((1 58))) -3.518141102137215e-11)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (12) ((1 58))) -9.084761919955079e-12)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (13) ((1 58))) -2.4461716726885985e-12)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (14) ((1 58))) -6.826083203213447e-13)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (15) ((1 58))) -1.9645799311949402e-13)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (16) ((1 58))) -5.808933227139693e-14)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (17) ((1 58))) -1.7590422495274421e-14)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (18) ((1 58))) -5.440902932714896e-15)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (19) ((1 58))) -1.7152474074868068e-15)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (20) ((1 58))) -5.500929233576992e-16)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (21) ((1 58))) -1.7918782877393175e-16)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (22) ((1 58))) -5.920372520086694e-17)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (23) ((1 58))) -1.9817130278764838e-17)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (24) ((1 58))) -6.713232347016354e-18)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (25) ((1 58))) -2.2994502436582814e-18)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (26) ((1 58))) -7.957300928236377e-19)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (27) ((1 58))) -2.7799940272917845e-19)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (28) ((1 58))) -9.798924361326984e-20)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (29) ((1 58))) -3.4827170060615736e-20)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (30) ((1 58))) -1.247489122558599e-20)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (31) ((1 58))) -4.501210041478228e-21)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (32) ((1 58))) -1.6353462440133518e-21)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (33) ((1 58))) -5.980102897780335e-22)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (34) ((1 58))) -2.2002462862861233e-22)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (35) ((1 58))) -8.142463073515086e-23)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (36) ((1 58))) -3.029924773660043e-23)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (37) ((1 58))) -1.1333900985746237e-23)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (38) ((1 58))) -4.2607660247492957e-24)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (39) ((1 58))) -1.6093633962781895e-24)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (40) ((1 58))) -6.106377190825025e-25)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (41) ((1 58))) -2.3269543180216937e-25)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (42) ((1 58))) -8.903987877472253e-26)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (43) ((1 58))) -3.4205585300056757e-26)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (44) ((1 58))) -1.3190267152572727e-26)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (45) ((1 58))) -5.104899493612044e-27)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (46) ((1 58))) -1.9825994784745476e-27)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (47) ((1 58))) -7.725702356880831e-28)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (48) ((1 58))) -3.02023473366468e-28)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (49) ((1 58))) -1.1843797390741699e-28)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (50) ((1 58))) -4.658430227922308e-29)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (51) ((1 58))) -1.8375541881003846e-29)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (52) ((1 58))) -7.26856689442799e-30)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (53) ((1 58))) -2.882863120391467e-30)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (54) ((1 58))) -1.146374629459906e-30)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (55) ((1 58))) -4.570031437748533e-31)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (56) ((1 58))) -1.8262766020453464e-31)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (57) ((1 58))) -7.315349993385253e-32)
  (f2cl-lib:fset (f2cl-lib:fref ath1cs (58) ((1 58))) -2.93692559997143e-32)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (1) ((1 74))) -0.015628444806253413)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (2) ((1 74))) 0.007783364452396813)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (3) ((1 74))) 8.670577704771896e-4)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (4) ((1 74))) 1.5696627315611372e-4)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (5) ((1 74))) 3.5639625714328654e-5)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (6) ((1 74))) 9.245983354250431e-6)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (7) ((1 74))) 2.621101618504224e-6)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (8) ((1 74))) 7.918822165160125e-7)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (9) ((1 74))) 2.510415279210118e-7)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (10) ((1 74))) 8.265223206654079e-8)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (11) ((1 74))) 2.805711662813052e-8)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (12) ((1 74))) 9.768210904846808e-9)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (13) ((1 74))) 3.4740792322771036e-9)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (14) ((1 74))) 1.258281321698369e-9)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (15) ((1 74))) 4.629882606418953e-10)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (16) ((1 74))) 1.7272825881360407e-10)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (17) ((1 74))) 6.523192001311543e-11)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (18) ((1 74))) 2.4904716852098202e-11)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (19) ((1 74))) 9.601568205537658e-12)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (20) ((1 74))) 3.7344800206772694e-12)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (21) ((1 74))) 1.464175650320534e-12)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (22) ((1 74))) 5.782654711685128e-13)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (23) ((1 74))) 2.2991540724470613e-13)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (24) ((1 74))) 9.197807112319973e-14)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (25) ((1 74))) 3.7006006881309006e-14)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (26) ((1 74))) 1.4967576169867303e-14)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (27) ((1 74))) 6.083611949384612e-15)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (28) ((1 74))) 2.484040871151214e-15)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (29) ((1 74))) 1.018624765267691e-15)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (30) ((1 74))) 4.1938385635275405e-16)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (31) ((1 74))) 1.7331890176293077e-16)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (32) ((1 74))) 7.188219023885085e-17)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (33) ((1 74))) 2.991236335984036e-17)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (34) ((1 74))) 1.2486899043323862e-17)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (35) ((1 74))) 5.228293446094837e-18)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (36) ((1 74))) 2.195329617247134e-18)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (37) ((1 74))) 9.242983252297773e-19)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (38) ((1 74))) 3.9015770823609147e-19)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (39) ((1 74))) 1.650938926938637e-19)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (40) ((1 74))) 7.002218157159944e-20)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (41) ((1 74))) 2.9765183361678693e-20)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (42) ((1 74))) 1.2679653908690208e-20)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (43) ((1 74))) 5.412434006970777e-21)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (44) ((1 74))) 2.3148735021815525e-21)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (45) ((1 74))) 9.919202883865665e-22)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (46) ((1 74))) 4.2580301532373227e-22)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (47) ((1 74))) 1.8310184297302448e-22)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (48) ((1 74))) 7.886787123110753e-23)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (49) ((1 74))) 3.402546073862299e-23)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (50) ((1 74))) 1.4702088140571257e-23)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (51) ((1 74))) 6.362110183249169e-24)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (52) ((1 74))) 2.757070506809807e-24)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (53) ((1 74))) 1.1964585809010406e-24)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (54) ((1 74))) 5.199125457292421e-25)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (55) ((1 74))) 2.2621767484710445e-25)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (56) ((1 74))) 9.855261137544319e-26)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (57) ((1 74))) 4.298706303325088e-26)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (58) ((1 74))) 1.8772364166158068e-26)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (59) ((1 74))) 8.207219417728422e-27)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (60) ((1 74))) 3.5921466560461557e-27)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (61) ((1 74))) 1.5739059461277333e-27)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (62) ((1 74))) 6.90329781039334e-28)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (63) ((1 74))) 3.030920790789685e-28)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (64) ((1 74))) 1.3320493416048124e-28)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (65) ((1 74))) 5.859788368515235e-29)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (66) ((1 74))) 2.580168684894878e-29)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (67) ((1 74))) 1.1371243363728367e-29)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (68) ((1 74))) 5.015925572260684e-30)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (69) ((1 74))) 2.2144582939550936e-30)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (70) ((1 74))) 9.784702838865073e-31)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (71) ((1 74))) 4.326954149341801e-31)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (72) ((1 74))) 1.9149728819399456e-31)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (73) ((1 74))) 8.481646224023924e-32)
  (f2cl-lib:fset (f2cl-lib:fref am22cs (74) ((1 74))) 3.7594706517395593e-32)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (1) ((1 72))) 0.0044052734587187795)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (2) ((1 72))) -0.030429194523184544)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (3) ((1 72))) -0.001385653283771794)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (4) ((1 72))) -1.8044439089549522e-4)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (5) ((1 72))) -3.380847108327309e-5)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (6) ((1 72))) -7.678183535229024e-6)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (7) ((1 72))) -1.9678394437160357e-6)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (8) ((1 72))) -5.4837271158777e-7)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (9) ((1 72))) -1.6254615505326125e-7)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (10) ((1 72))) -5.053049981268894e-8)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (11) ((1 72))) -1.6315807011240666e-8)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (12) ((1 72))) -5.434204112348517e-9)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (13) ((1 72))) -1.8573985564099002e-9)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (14) ((1 72))) -6.48951203332611e-10)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (15) ((1 72))) -2.310594885800945e-10)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (16) ((1 72))) -8.363282183204411e-11)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (17) ((1 72))) -3.0711968448901916e-11)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (18) ((1 72))) -1.1423671424327168e-11)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (19) ((1 72))) -4.298116066345803e-12)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (20) ((1 72))) -1.6338986995967153e-12)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (21) ((1 72))) -6.269328620016619e-13)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (22) ((1 72))) -2.4260526948162572e-13)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (23) ((1 72))) -9.461198321624039e-14)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (24) ((1 72))) -3.716060313411505e-14)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (25) ((1 72))) -1.4691556840975267e-14)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (26) ((1 72))) -5.843694726140912e-15)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (27) ((1 72))) -2.337502595591951e-15)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (28) ((1 72))) -9.399231371171437e-16)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (29) ((1 72))) -3.7980146693728944e-16)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (30) ((1 72))) -1.5417310439849724e-16)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (31) ((1 72))) -6.285287079535306e-17)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (32) ((1 72))) -2.5727318128114557e-17)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (33) ((1 72))) -1.0570981193540178e-17)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (34) ((1 72))) -4.359080267402697e-18)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (35) ((1 72))) -1.8036343159599783e-18)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (36) ((1 72))) -7.486838064380537e-19)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (37) ((1 72))) -3.1172613673476046e-19)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (38) ((1 72))) -1.301687980927701e-19)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (39) ((1 72))) -5.450527587519522e-20)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (40) ((1 72))) -2.2882934901142318e-20)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (41) ((1 72))) -9.631059503829539e-21)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (42) ((1 72))) -4.0632810015246135e-21)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (43) ((1 72))) -1.7182039809080266e-21)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (44) ((1 72))) -7.281574619892536e-22)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (45) ((1 72))) -3.0923526526806433e-22)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (46) ((1 72))) -1.3159178559654405e-22)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (47) ((1 72))) -5.610606786087056e-23)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (48) ((1 72))) -2.3966218940863554e-23)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (49) ((1 72))) -1.0255743323905815e-23)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (50) ((1 72))) -4.3962641381436557e-24)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (51) ((1 72))) -1.8876529983725773e-24)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (52) ((1 72))) -8.118140359576806e-25)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (53) ((1 72))) -3.4967342743662866e-25)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (54) ((1 72))) -1.508402925156873e-25)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (55) ((1 72))) -6.516268284778671e-26)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (56) ((1 72))) -2.8189457975292076e-26)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (57) ((1 72))) -1.2211275965122628e-26)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (58) ((1 72))) -5.296674341169868e-27)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (59) ((1 72))) -2.3003592707736736e-27)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (60) ((1 72))) -1.0002794823553676e-27)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (61) ((1 72))) -4.35476040418088e-28)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (62) ((1 72))) -1.8980561347414776e-28)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (63) ((1 72))) -8.282111868712975e-29)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (64) ((1 72))) -3.617815493066569e-29)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (65) ((1 72))) -1.5820188961780035e-29)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (66) ((1 72))) -6.925068597802269e-30)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (67) ((1 72))) -3.0343902397786293e-30)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (68) ((1 72))) -1.330889568166725e-30)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (69) ((1 72))) -5.84284852217309e-31)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (70) ((1 72))) -2.567488423238303e-31)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (71) ((1 72))) -1.1292323222688823e-31)
  (f2cl-lib:fset (f2cl-lib:fref ath2cs (72) ((1 72))) -4.970947029753337e-32)
  (setq first f2cl-lib:%true%)
  (defun d9aimp (x ampl theta)
    (declare (type double-float theta ampl x))
    (prog ((sqrtx 0.0) (z 0.0) (eta 0.0f0))
      (declare (type single-float eta) (type double-float z sqrtx))
      (cond
       (first (setf eta (* 0.1f0 (f2cl-lib:freal (f2cl-lib:d1mach 3))))
              (setf nam20 (initds am20cs 57 eta))
              (setf nath0 (initds ath0cs 53 eta))
              (setf nam21 (initds am21cs 60 eta))
              (setf nath1 (initds ath1cs 58 eta))
              (setf nam22 (initds am22cs 74 eta))
              (setf nath2 (initds ath2cs 72 eta))
              (setf xsml (/ -1.0 (expt (f2cl-lib:d1mach 3) 0.3333)))))
      (setf first f2cl-lib:%false%)
      (if (>= x -4.0) (go label20))
      (setf z 1.0)
      (if (> x xsml) (setf z (+ (/ 128.0 (expt x 3)) 1.0)))
      (setf ampl (+ 0.3125 (dcsevl z am20cs nam20)))
      (setf theta (- (dcsevl z ath0cs nath0) 0.625))
      (go label40)
     label20
      (if (>= x -2.0) (go label30))
      (setf z (/ (+ (/ 128.0 (expt x 3)) 9.0) 7.0))
      (setf ampl (+ 0.3125 (dcsevl z am21cs nam21)))
      (setf theta (- (dcsevl z ath1cs nath1) 0.625))
      (go label40)
     label30
      (if (>= x -1.0) (xermsg "SLATEC" "D9AIMP" "X MUST BE LE -1.0" 1 2))
      (setf z (/ (+ (/ 16.0 (expt x 3)) 9.0) 7.0))
      (setf ampl (+ 0.3125 (dcsevl z am22cs nam22)))
      (setf theta (- (dcsevl z ath2cs nath2) 0.625))
     label40
      (setf sqrtx (f2cl-lib:fsqrt (- x)))
      (setf ampl (f2cl-lib:fsqrt (/ ampl sqrtx)))
      (setf theta (+ pi4 (* (- x) sqrtx theta)))
      (go end_label)
     end_label
      (return (values nil ampl theta)))))

