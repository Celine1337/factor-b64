USING: base64 command-line combinators io kernel namespaces sequences ;
IN: scratchpad

: arg-input ( -- s ) command-line get rest " " join ;

: run ( -- )
  command-line get dup empty?
  [ drop "usage: factor-b64 encode|decode <text>" print ]
  [ first
    {
      { "encode" [ arg-input >base64 print ] }
      { "decode" [ arg-input base64> print ] }
      [ drop "usage: factor-b64 encode|decode <text>" print ]
    } case ]
  if ;

run