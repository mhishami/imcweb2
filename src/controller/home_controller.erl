-module (home_controller).
-export ([handle_request/5]).
-export ([before_filter/2]).

-define (ME, <<"mhishami@gmail.com">>).
-define (OPTS, [
    {relay, "smtp.gmail.com"}, 
    {username, "mhishami@gmail.com"}, 
    {password, "sh4mh4s123"},
    {ssl, true}
]).

-define (SUBJECT, <<"Subject: [IMC Contact Form] ">>).
-define (FROM, <<"From: ">>).
-define (LT, <<" <">>).
-define (GT, <<"> ">>).
-define (CRLF, <<"\r\n">>).
-define (TO, <<"To: Hisham Ismail <hisham@iridianmedia.com>">>).

before_filter(_Params, _Req) ->
    %% do some checking
    % User = proplists:get_value(auth, Params, undefined),
    % case User of
    %     undefined ->
    %         {redirect, <<"/auth/login">>};
    %     _ ->
    %         {ok, proceed}
    % end.
    {ok, proceed}.

handle_request(<<"GET">>, _Action, _Args, _Params, _Req) ->    
    %% / will render home.dtl
    {ok, []};

handle_request(<<"POST">>, <<"contact">>, _Args, [_, _, _, {qs_body, Vals}], _Req) ->
    Name = proplists:get_value(<<"name">>, Vals),
    Email = proplists:get_value(<<"email">>, Vals),
    Subject = proplists:get_value(<<"subject">>, Vals),
    Message = proplists:get_value(<<"message">>, Vals),
    
    io:format("Vals: ~p~n", [Vals]),
    
    % gen_smtp_client:send({
    %     ?ME, ["hisham@iridianmedia.com"],
    %     "Subject: Testing\r\nFrom: Hisham <mhishami@gmail.com> \r\nTo: Hisham <hisham@iridianmedia.com> \r\n\r\nThis is the email body"}, ?OPTS).
    
    % send the email out
    gen_smtp_client:send({
        Email, ["hisham@iridianmedia.com"],
        <<?SUBJECT/binary, Subject/binary, ?CRLF/binary,
        ?FROM/binary, Name/binary, ?LT/binary, Email/binary, ?GT/binary, ?CRLF/binary,
        ?TO/binary, ?CRLF/binary, ?CRLF/binary,

        ?FROM/binary, Name/binary, ?LT/binary, Email/binary, ?GT/binary, 
        ?CRLF/binary, ?CRLF/binary,

        Message/binary>>}, ?OPTS),
    
    {json, [{result, <<"OK">>}]};
    
handle_request(_, _, _, _, _) ->
    {error, <<"Opps, Forbidden">>}.
    

