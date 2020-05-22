type ast = Seq of string * ast list

let rec _indented_string_of_ast (indent : string) (t : ast) : string =
    match t with
    | Seq (s, [])   -> "Seq (\"" ^ s ^ "\", [])"
    | Seq (s, ts)   -> let new_indent = indent ^ "     " in
                       let inner_indent = new_indent ^ "  " in
                       "Seq (\"" ^ s ^ "\",\n" ^ new_indent ^ "[ " ^ (String.concat ("\n" ^ new_indent ^ "; ") (List.map (_indented_string_of_ast inner_indent) ts)) ^ "\n" ^ new_indent ^ "])"

let string_of_ast (t : ast) : string = _indented_string_of_ast "" t

let rec unindented_string_of_ast (t : ast) : string =
    match t with
    | Seq (s, [])   -> "Seq (\"" ^ s ^ "\", [])"
    | Seq (s, ts)   -> "Seq (\"" ^ s ^ "\", [ " ^ (String.concat "; " (List.map unindented_string_of_ast ts)) ^ " ])"

let rec flatten_binary_seqs' (n : int) (t : ast) : ast list =
    if n = 0
    then [t]
    else match t with
        | Seq (l, [t1; t2]) -> t1 :: (flatten_binary_seqs' (n - 1) t2)
        | _ -> failwith "Unexpected AST shape in flatten_seqs!"

let flatten_binary_seqs (n : int) (l : string) (t : ast) : ast =
    Seq (l, flatten_binary_seqs' n t)