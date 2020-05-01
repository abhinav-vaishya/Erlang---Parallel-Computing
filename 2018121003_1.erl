-module('2018121003_1').
-export([main/1, roundrobin/4, process/2]).


roundrobin(Token, Out, Tot, Count) ->
    if 
    	Count >= Tot ->
       		io:format(Out, "Process 0 received token ~w from process ~w.\n",[Token, Count]);
    	true ->
        	_Id = spawn(fun() -> roundrobin(Token,Out,Tot, Count+1 ) end),
        	io:format(Out, "Process ~w received token ~w from process ~w.\n",[Count+1, Token, Count])
    end.
    


process(Input, Output) ->
    case file:read_line(Input) of
        {ok, Line1} ->
                    Line = string:trim(Line1),
                    Numbers = lists:map(fun(X) -> {Int, _} = string:to_integer(X),
                    Int end, string:tokens(string:trim(Line), " ")),
		    Procs = lists:nth(1, Numbers),
                    Token = lists:nth(2, Numbers),
                    Count = 0,
                    roundrobin(Token, Output, Procs-1, Count),
                    process(Input, Output);
        eof -> ok
    end.



main(Args) ->
    {ok, Input} = file:open(lists:nth(1,Args), [read]),
    {ok, Output} = file:open(lists:nth(2, Args), [write]),
    process(Input, Output),
    file:close(Input),
    file:close(Output).
