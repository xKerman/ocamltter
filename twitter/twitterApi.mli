(**
   Twitter APIs.
*)
open Util

exception TwErr of string

type status_id = int64
type tweet =
  | U of (Date.t * string * status_id * string * string * Json.t)
  | RT of
      (Date.t * string * status_id * string * string * string * Date.t *status_id * Json.t)
  | RE of
      (Date.t * string * status_id * string * string * string * status_id * Json.t)

type token = string * string * string

val date : tweet -> Util.Date.t
val sname : tweet -> string
val text : tweet -> string
val status_id : tweet -> status_id
val json : tweet -> Json.t

val show_tweet : tweet -> string
val tw_compare : tweet -> tweet -> int

(** {6 basic operations for twitter} *)

val twitter :
  token ->
  ?host:string -> Http.meth -> string -> (string * string) list -> Json.t
(** [twitter (tok,secret,verif) method path parameters] *)

val twitter_without_auth :
  ?host:string -> Http.meth -> string -> (string * string) list -> Json.t
(** [twitter_without_auth] *)

(** {6 APIs} *)

(** {7 Timeline Methods} *)

val home_timeline :
  ?since_id:string -> ?count:int -> token -> tweet list

val user_timeline :
  ?since_id:string ->
  ?count:int -> token -> string -> tweet list

val show : status_id -> tweet

val get_tweet : status_id -> tweet
(** same as [show] *)

val mentions : token -> int -> tweet list

(** {7 Status Methods} *)

val update :
  ?in_reply_to_status_id:string ->
  token -> string -> Json.t

val destroy : token -> status_id -> Json.t
val retweet : token -> string -> Json.t

(** {7 User Methods} *)

val users_lookup : token -> string -> Json.t
val users_lookup_uid : token -> string -> Json.t

(** {7 Friendship Methods} *)

val friendship_create : token -> string -> Json.t
val friendship_destroy : token -> string -> Json.t

(** {7 Social Graph Methods} *)

val friends : ?sname:string -> token -> Json.t
val followers : ?sname:string -> token -> Json.t

(** {7 Account Methods} *)

val rate_limit_status : unit -> Json.t

(** {7 Favorite Methods} *)

val favorites : ?sname:string -> token -> Json.t
val favorites_create : token -> status_id -> Json.t
val favorites_destroy : token -> status_id -> Json.t

(** {7 Spam Reporting Methods} *)

val report_spam : token -> string -> Json.t

(** {7 OAuth Methods} *)

val fetch_request_token : unit -> token
val fetch_access_token :
  string -> string -> string -> token

(** {7 Help Methods} *)

val help_test : unit -> Json.t

(** {7 Search API Methods} *)

val search : string -> tweet list