(*
 * Copyright (c) 2017 - present Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *)

open! IStd

val report_cycle :
  Tenv.t -> Typ.Procname.t -> Sil.hpred -> Prop.normal Prop.t option option -> unit
