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

handle_request(<<"POST">>, <<"login">>, _Args, [_, _, _, {qs_body, Vals}], _Req) ->
    Username = proplists:get_value(<<"username">>, Vals),
    Password = proplists:get_value(<<"password">>, Vals),
    
    io:format("Login: ~p, ~p~n", [Username, Password]),
    {redirect, "/"};

handle_request(_, _, _, _, _) ->
    {error, <<"Opps, Forbidden">>}.
    

