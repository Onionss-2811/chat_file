%% @author tukna


-module(client).
-behaviour(gen_server).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1, get_user/1, get_message/1, send/3, m_receive/3]).
-export([init/1, handle_call/3, handle_cast/2]).



%% ====================================================================
%% Internal functions
%% ====================================================================

start(Name) ->
    Return = gen_server:start_link({global, Name}, client, [], []),
	net_adm:ping('server@Lenovo-TuKNA'),
	gen_server:call({global,server}, {send_user_name, Name}),
    io:format("~p is readly: ~p~n", [Name, Return]),
    Return.

get_user(Name) ->
	gen_server:call({global, server}, {get_user, Name}).

send(M_from, M_to, Mess) -> 
	gen_server:call({global,server}, {send,M_from, M_to, Mess}).

m_receive(M_from, M_to, Mess) ->
	gen_server:call({global,M_to}, {m_receive,M_from, M_to, Mess}).

get_message(Name) -> 
	gen_server:call({global,server}, {get_mess, Name}).

init([]) ->
    State = [],
    Return = {ok, State},
    io:format("init: ~p~n", [State]),
    Return.

handle_call({send,M_from, M_to, Mess}, _From, State) ->
	io:format("You send to ~p: ~p ~n",[M_to, Mess]),
	node2:m_receive(M_from, M_to, Mess),
    {reply, ok, State};

handle_call({m_receive,M_from, _M_to, Mess}, _From, State) ->
    io:format("Message from ~p: ~p ~n",[M_from, Mess]),
    {reply, ok, State};

handle_call({noti, M_from}, _From, State) -> 
	io:format("you have a message from: ~p ~n",[M_from]),
    {reply, ok, State};

handle_call({receive_user, Content}, _From, State) -> 
	io:format("~p ~n",[Content]),
    {reply, ok, State};

handle_call({receive_mess, Content}, _From, State) ->
    io:format("~p ~n",[Content]),
    {reply, ok, State}.

handle_cast({send,Mess}, State) ->
    io:format("Receive msg from handle_cast: ~p~n", [Mess]),
    {noreply, State}.




















