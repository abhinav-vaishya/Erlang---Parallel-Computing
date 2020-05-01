-module('2018121003_2').
-export([mergesort/2,merge/2,main/1,print/5]).

merge([], B) -> B;
merge(A, []) -> A;
merge([A|Ca], [B|Cb]) ->
	if
		A > B ->
			[B | merge([A|Ca], Cb)];
		true ->
			[A | merge(Ca, [B|Cb])]
	end.

mergesort([E], PID) -> PID ! [E];
mergesort([], PID) -> PID ! [];
mergesort(L, PID) ->
	{A, B} = lists:split(trunc(length(L)/2), L),
  	spawn('2018121003_2', mergesort, [A,self()]),
	receive S1 -> ok end,
  	spawn('2018121003_2', mergesort, [B,self()]),
	receive S2 -> ok end,
  	PID ! merge(S2, S1).


print(S, Out, 0, Num,_) ->
        [];
        print(S, Out, N, Num,Term) when N > 0 ->
        io:format(Out, "~w ", [lists:nth(Num-N+1, S)]),
        [Term|print(S, Out, N-1, Num, Term)].


main(Args) ->
    	{ok, Input} = file:open(lists:nth(1,Args), [read]),
	{ok, Output} = file:open(lists:nth(2, Args), [write]),
	{ok, Line} = file:read_line(Input),
	L = string:trim(Line),
	Numbers = [ element(1, string:to_integer(Substr)) || Substr <- string:tokens(L, ", ")],
	spawn(t, mergesort, [Numbers,self()]),
        receive S -> ok end,
	I = length(S),
	print(S,Output,I,I,1),
    	file:close(Input),
    	file:close(Output).


