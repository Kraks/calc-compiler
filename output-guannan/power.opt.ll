WARNING: You're attempting to print out a bitcode file.
This is inadvisable as it may cause display problems. If
you REALLY want to taste LLVM bitcode first-hand, you
can force output with the `-f' option.

*** IR Dump After Module Verifier ***
define i64 @f(i64, i64, i64, i64, i64, i64) {
entry:
  %m0 = alloca i64
  store i64 0, i64* %m0
  %m1 = alloca i64
  store i64 0, i64* %m1
  %m2 = alloca i64
  store i64 0, i64* %m2
  %m3 = alloca i64
  store i64 0, i64* %m3
  %m4 = alloca i64
  store i64 0, i64* %m4
  %m5 = alloca i64
  store i64 0, i64* %m5
  %m6 = alloca i64
  store i64 0, i64* %m6
  %m7 = alloca i64
  store i64 0, i64* %m7
  %m8 = alloca i64
  store i64 0, i64* %m8
  %m9 = alloca i64
  store i64 0, i64* %m9
  store i64 %0, i64* %m0
  store i64 %1, i64* %m1
  %m11 = load i64, i64* %m1
  %neq = icmp ne i64 %m11, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m02 = load i64, i64* %m0
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m02, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %m010, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %add = phi i64 [ %fst, %of ], [ %fst, %body ]
  store i64 %add, i64* %m0
  %m13 = load i64, i64* %m1
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m13, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %add9 = phi i64 [ %fst7, %of4 ], [ %fst7, %normal ]
  store i64 %add9, i64* %m1
  %m010 = load i64, i64* %m0
  %m111 = load i64, i64* %m1
  %neq12 = icmp ne i64 %m111, 1
  br i1 %neq12, label %body, label %cont
}
*** IR Dump After Simplify the CFG ***
define i64 @f(i64, i64, i64, i64, i64, i64) {
entry:
  %m0 = alloca i64
  store i64 0, i64* %m0
  %m1 = alloca i64
  store i64 0, i64* %m1
  %m2 = alloca i64
  store i64 0, i64* %m2
  %m3 = alloca i64
  store i64 0, i64* %m3
  %m4 = alloca i64
  store i64 0, i64* %m4
  %m5 = alloca i64
  store i64 0, i64* %m5
  %m6 = alloca i64
  store i64 0, i64* %m6
  %m7 = alloca i64
  store i64 0, i64* %m7
  %m8 = alloca i64
  store i64 0, i64* %m8
  %m9 = alloca i64
  store i64 0, i64* %m9
  store i64 %0, i64* %m0
  store i64 %1, i64* %m1
  %m11 = load i64, i64* %m1
  %neq = icmp ne i64 %m11, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m02 = load i64, i64* %m0
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m02, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %m010, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  store i64 %fst, i64* %m0
  %m13 = load i64, i64* %m1
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m13, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  store i64 %fst7, i64* %m1
  %m010 = load i64, i64* %m0
  %m111 = load i64, i64* %m1
  %neq12 = icmp ne i64 %m111, 1
  br i1 %neq12, label %body, label %cont
}
*** IR Dump After SROA ***
define i64 @f(i64, i64, i64, i64, i64, i64) {
entry:
  %neq = icmp ne i64 %1, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp ne i64 %fst7, 1
  br i1 %neq12, label %body, label %cont
}
*** IR Dump After Early CSE ***
define i64 @f(i64, i64, i64, i64, i64, i64) {
entry:
  %neq = icmp ne i64 %1, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp ne i64 %fst7, 1
  br i1 %neq12, label %body, label %cont
}
*** IR Dump After Early GVN Hoisting of Expressions ***
define i64 @f(i64, i64, i64, i64, i64, i64) {
entry:
  %neq = icmp ne i64 %1, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp ne i64 %fst7, 1
  br i1 %neq12, label %body, label %cont
}
*** IR Dump After Lower 'expect' Intrinsics ***
define i64 @f(i64, i64, i64, i64, i64, i64) {
entry:
  %neq = icmp ne i64 %1, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp ne i64 %fst7, 1
  br i1 %neq12, label %body, label %cont
}
*** IR Dump After Force set function attributes ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32)

define i64 @f(i64, i64, i64, i64, i64, i64) {
entry:
  %neq = icmp ne i64 %1, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp ne i64 %fst7, 1
  br i1 %neq12, label %body, label %cont
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Infer set function attributes ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32)

define i64 @f(i64, i64, i64, i64, i64, i64) {
entry:
  %neq = icmp ne i64 %1, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp ne i64 %fst7, 1
  br i1 %neq12, label %body, label %cont
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Interprocedural Sparse Conditional Constant Propagation ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32)

define i64 @f(i64, i64, i64, i64, i64, i64) {
entry:
  %neq = icmp ne i64 %1, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp ne i64 %fst7, 1
  br i1 %neq12, label %body, label %cont
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Global Variable Optimizer ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32) local_unnamed_addr

define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp ne i64 %1, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp ne i64 %fst7, 1
  br i1 %neq12, label %body, label %cont
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Promote Memory to Register ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp ne i64 %1, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp ne i64 %fst7, 1
  br i1 %neq12, label %body, label %cont
}
*** IR Dump After Dead Argument Elimination ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32) local_unnamed_addr

define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp ne i64 %1, 1
  br i1 %neq, label %body, label %cont

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp ne i64 %fst7, 1
  br i1 %neq12, label %body, label %cont
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Combine redundant instructions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Simplify the CFG ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After PGOIndirectCallPromotion ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32) local_unnamed_addr

define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Remove unused exception handling info ***
Printing <null> Function
*** IR Dump After Function Integration/Inlining ***
Printing <null> Function
*** IR Dump After Deduce function attributes ***
Printing <null> Function
*** IR Dump After Remove unused exception handling info ***
declare void @overflow_fail(i32) local_unnamed_addr
*** IR Dump After Function Integration/Inlining ***
declare void @overflow_fail(i32) local_unnamed_addr
*** IR Dump After Deduce function attributes ***
declare void @overflow_fail(i32) local_unnamed_addr
*** IR Dump After Remove unused exception handling info ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Function Integration/Inlining ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Deduce function attributes ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After SROA ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Early CSE ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Speculatively execute instructions if target has divergent branches ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Jump Threading ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Value Propagation ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Simplify the CFG ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Combine redundant instructions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Conditionally eliminate dead library calls ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Tail Call Elimination ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Simplify the CFG ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Reassociate expressions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %normal5, %entry
  %m1.0 = phi i64 [ %1, %entry ], [ %fst7, %normal5 ]
  %m0.0 = phi i64 [ %0, %entry ], [ %fst, %normal5 ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Canonicalize natural loops ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop-Closed SSA Form Pass ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Rotate Loops ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After Loop Invariant Code Motion ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After Unswitch loops ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After Simplify the CFG ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Combine redundant instructions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Canonicalize natural loops ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop-Closed SSA Form Pass ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Induction Variable Simplification ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After Recognize loop idioms ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After Delete dead loops ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After Unroll loops ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After MergedLoadStoreMotion ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Global Value Numbering ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After MemCpy Optimization ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Sparse Conditional Constant Propagation ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Demanded bits analysis ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Bit-Tracking Dead Code Elimination ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Combine redundant instructions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Jump Threading ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Value Propagation ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Dead Store Elimination ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Canonicalize natural loops ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop-Closed SSA Form Pass ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop Invariant Code Motion ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After Aggressive Dead Code Elimination ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Simplify the CFG ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Combine redundant instructions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Remove unused exception handling info ***
; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0
*** IR Dump After Function Integration/Inlining ***
; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0
*** IR Dump After Deduce function attributes ***
; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0
*** IR Dump After Remove unused exception handling info ***
; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0
*** IR Dump After Function Integration/Inlining ***
; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0
*** IR Dump After Deduce function attributes ***
; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0
*** IR Dump After Remove unused exception handling info ***
Printing <null> Function
*** IR Dump After Function Integration/Inlining ***
Printing <null> Function
*** IR Dump After Deduce function attributes ***
Printing <null> Function
*** IR Dump After A No-Op Barrier Pass ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32) local_unnamed_addr

define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Eliminate Available Externally Globals ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32) local_unnamed_addr

define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Deduce function attributes in RPO ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32) local_unnamed_addr

define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Float to int ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Canonicalize natural loops ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop-Closed SSA Form Pass ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Rotate Loops ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After Loop Distribution ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Canonicalize natural loops ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop-Closed SSA Form Pass ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Demanded bits analysis ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop Vectorization ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Canonicalize natural loops ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop Load Elimination ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Combine redundant instructions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Demanded bits analysis ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After SLP Vectorizer ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Simplify the CFG ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Combine redundant instructions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body

body:                                             ; preds = %entry, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %entry ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %entry ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont:                                             ; preds = %normal5, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %normal5 ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont, label %body
}
*** IR Dump After Canonicalize natural loops ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop-Closed SSA Form Pass ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Unroll loops ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After Combine redundant instructions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Canonicalize natural loops ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop-Closed SSA Form Pass ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  %fst.lcssa = phi i64 [ %fst, %normal5 ]
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst.lcssa, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Loop Invariant Code Motion ***
body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
*** IR Dump After Remove redundant instructions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Alignment from assumptions ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
*** IR Dump After Strip Unused Function Prototypes ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32) local_unnamed_addr

define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Dead Global Elimination ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32) local_unnamed_addr

define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Merge Duplicate Global Constants ***; ModuleID = 'power.ll'
source_filename = "calc"
target triple = "x86_64-unknown-linux-gnu"

declare void @overflow_fail(i32) local_unnamed_addr

define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #0

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #0

attributes #0 = { nounwind readnone }
*** IR Dump After Module Verifier ***
define i64 @f(i64, i64, i64, i64, i64, i64) local_unnamed_addr {
entry:
  %neq = icmp eq i64 %1, 1
  br i1 %neq, label %cont, label %body.preheader

body.preheader:                                   ; preds = %entry
  br label %body

body:                                             ; preds = %body.preheader, %normal5
  %m1.0 = phi i64 [ %fst7, %normal5 ], [ %1, %body.preheader ]
  %m0.0 = phi i64 [ %fst, %normal5 ], [ %0, %body.preheader ]
  %result = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %m0.0, i64 %0)
  %fst = extractvalue { i64, i1 } %result, 0
  %snd = extractvalue { i64, i1 } %result, 1
  br i1 %snd, label %of, label %normal

cont.loopexit:                                    ; preds = %normal5
  br label %cont

cont:                                             ; preds = %cont.loopexit, %entry
  %tmp = phi i64 [ 0, %entry ], [ %fst, %cont.loopexit ]
  ret i64 %tmp

of:                                               ; preds = %body
  tail call void @overflow_fail(i32 120)
  br label %normal

normal:                                           ; preds = %of, %body
  %result6 = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %m1.0, i64 1)
  %fst7 = extractvalue { i64, i1 } %result6, 0
  %snd8 = extractvalue { i64, i1 } %result6, 1
  br i1 %snd8, label %of4, label %normal5

of4:                                              ; preds = %normal
  tail call void @overflow_fail(i32 166)
  br label %normal5

normal5:                                          ; preds = %of4, %normal
  %neq12 = icmp eq i64 %fst7, 1
  br i1 %neq12, label %cont.loopexit, label %body
}
