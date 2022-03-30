%% @author tukna


-module(server).
-behaviour(gen_server).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).
-export([init/1, handle_call/3, handle_cast/2]).



%% ====================================================================
%% Internal functions
%% ====================================================================

start() ->
    Return = gen_server:start_link({global, server}, server, [], []),
    io:format("server is readly: ~p~n", [Return]),
    Return.

init([]) ->
    State = [],
    Return = {ok, State},
    io:format("init: ~p~n", [State]),
    Return.


handle_call({send_user_name, Name}, _From, State) ->
	A = " - ",
	Name_str = atom_to_list(Name),
	Content = string:concat(Name_str, A),
	file:write_file("user.dat", Content, [append]),
    {reply, ok, State};

handle_call({send,M_from, M_to, Mess}, _From, State) ->
	gen_server:call({global, M_to}, {noti, M_from}),
	B = ".dat",
	Name_file_str = atom_to_list(M_to),
	Name_file = string:concat(Name_file_str, B),
	
	Mess_str = atom_to_list(Mess),
	
	file:write_file(Name_file, Mess_str, [write]),
    {reply, ok, State};

handle_call({get_mess, Name}, _From, State) ->
	B = ".dat",
	Name_file_str = atom_to_list(Name),
	Name_file = string:concat(Name_file_str, B),
	{ok, Content} = file:read_file(Name_file),
	gen_server:call({global, Name}, {receive_mess, Content}),
    {reply, ok, State};

handle_call({get_user, Name}, _Form, State) -> 
	{ok, Content} = file:read_file("user.dat"),
	gen_server:call({global, Name}, {receive_user, Content}),
	{reply, ok, State}.

handle_cast({send,Mess}, State) ->
    io:format("Receive msg from handle_cast: ~p~n", [Mess]),
    {noreply, State}.



















