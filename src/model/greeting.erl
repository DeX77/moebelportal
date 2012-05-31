-module(greeting, [Id, GreetingText]).
-compile(export_all).

validation_tests() ->
    [{fun() -> length(GreetingText) > 0 end, 
        "Greeting must be non-empty!"},
     {fun() -> length(GreetingText) =< 140 end,
        "Greeting must be tweetable"}].

after_create() ->
    boss_mq:push("new-greetings", THIS).