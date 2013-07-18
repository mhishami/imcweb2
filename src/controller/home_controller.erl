-module (home_controller).
-export ([handle_request/5]).
-export ([before_filter/2]).

-define (ME, "noreply@iridianmedia.com").
-define (TO, "hisham@iridianmedia.com").
-define (OPTS, [
    {relay, "smtp.gmail.com"}, 
    {username, "noreply@iridianmedia.com"}, 
    {password, "n0r3ply123"},
    {ssl, true}
]).


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
    Name = binary_to_list(proplists:get_value(<<"name">>, Vals)),
    Email = binary_to_list(proplists:get_value(<<"email">>, Vals)),
    Subject = binary_to_list(proplists:get_value(<<"subject">>, Vals)),
    Message = binary_to_list(proplists:get_value(<<"message">>, Vals)),
    
    io:format("Vals: ~p~n", [Vals]),
    
    % gen_smtp_client:send({
    %     ?ME, ["hisham@iridianmedia.com"],
    %     "Subject: Testing\r\nFrom: Hisham <mhishami@gmail.com> \r\nTo: Hisham <hisham@iridianmedia.com> \r\n\r\nThis is the email body"}, ?OPTS).
    
    % send the email out
    % M = "Subject: [IMC WebForm] " ++ Subject ++ "\r\n" ++
    %     "From: " ++ Name ++ "<" ++ Email ++ ">" ++ "\r\n" ++
    %     "To: Hisham Ismail <hisham@iridianmedia.com>" ++
    %     "\r\n\r\n" ++
    %     "From: " ++ Name ++ "<" ++ Email ++ ">" ++ "\r\n\r\n" ++
    %     Message,
        
    % M = "Subject: " ++ Subject ++ "\r\n" ++
    %     "From: " ++ Name ++ " <" ++ Email ++ "> \r\n" ++ 
    %     "To: Hisham <hisham@iridianmedia.com> \r\n\r\n" ++ 
    %     Message,
        
    M = "Subject: [ContactForm] " ++ Subject ++ "\r\n" ++
        "From: NoReply <noreply@iridianmedia.com> \r\n" ++
        "To: Info <info@iridianmedia.com> \r\n\r\n" ++ 
        "Sender: " ++ Name ++ " <" ++ Email ++ ">\r\n\r\n" ++
        Message,
    io:format("~p~n", [M]),

    gen_smtp_client:send({?ME, [?TO], M}, ?OPTS),    
    {json, [{result, <<"OK">>}]};
    
handle_request(_, _, _, _, _) ->
    {error, <<"Opps, Forbidden">>}.
    

