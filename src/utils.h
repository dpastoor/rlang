#define R_NO_REMAP
#include <stdbool.h>
#include <R.h>
#include <Rinternals.h>

bool is_lazy_load(SEXP x);
bool is_lang(SEXP x, const char* f);
bool is_formula(SEXP x);
bool is_fpromise(SEXP x);
SEXP f_rhs_(SEXP f);
SEXP f_lhs_(SEXP f);
SEXP f_env_(SEXP f);
SEXP last_cons(SEXP x);
SEXP make_formula1(SEXP rhs, SEXP env);
SEXP rlang_fun(SEXP sym);
int is_symbolic(SEXP x);
int is_true(SEXP x);
int is_sym(SEXP sym, const char* string);
int is_rlang_prefixed(SEXP x, int (*sym_predicate)(SEXP));
int is_any_call(SEXP x, int (*sym_predicate)(SEXP));
int is_prefixed_call(SEXP x, int (*sym_predicate)(SEXP));
int is_rlang_call(SEXP x, int (*sym_predicate)(SEXP));
bool is_character(SEXP x);
SEXP names(SEXP x);
bool has_name_at(SEXP x, R_len_t i);
bool is_str_empty(SEXP str);
bool is_object(SEXP x);
bool is_atomic(SEXP x);
bool is_list(SEXP x);
SEXP set_names(SEXP x, SEXP nms);
bool is_scalar_atomic(SEXP x);
const char* kind_c_str(SEXPTYPE kind);
bool is_empty(SEXP x);
bool is_vector(SEXP x);
bool is_null(SEXP x);
