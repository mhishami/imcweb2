-module (auth_controller).
-export ([handle_request/5]).
-export ([before_filter/2]).

before_filter(Params, _Req) ->
    %% do some checking
    % User = proplists:get_value(auth, Params, undefined),
    % case User of
    %     undefined ->
    %         {redirect, <<"/auth/login">>};
    %     _ ->
    %         {ok, proceed}
    % end.
    {ok, proceed}.

handle_request(<<"GET">>, <<"login">> = Action, _Args, _Params, _Req) ->    
    {Action, []};

handle_request(<<"POST">>, <<"contact">>, _Args, [_, _, _, {qs_body, Vals}], _Req) ->
    Name = proplists:get_value(<<"name">>, Vals),
    Email = proplists:get_value(<<"email">>, Vals),
    Subject = proplists:get_value(<<"subject">>, Vals),
    Message = proplists:get_value(<<"message">>, Vals),
    
    io:format("Message: ~p, ~p, ~p, ~p~n", [Name, Email, Subject, Message]),
    {redirect, "/"};

handle_request(_, _, _, _, _) ->
    {error, <<"Opps, Forbidden">>}.
    

