# cuba-tech-slack-bot
A extensible Slack bot for our private chat CubaTech implemented in *PERL* (yeah, you got that right, *PERL* :-) )

It's implemented with the idea of making it easy to add new commands and functionality to the bot. Commands are implemented totally decoupled from the messaging logic. The idea is to even make it possible to make them asynchronous so in theory, long tasks can be performed without blocking the bot.

# For Developers

## How to install

(Not sure for now haha, perl doesn't make this easy, if you find an error during installing please report :-) )

    git clone https://github.com/pbu88/cuba-tech-slack-bot.git
    cd cuba-tech-slack-bot
    cpanm --installdeps .   # install the dependencies
    prove -l -r             # run the tests
    
In order to run it, you will need change the values `config.json` file on the root directory with the actual values you want. The most important one is the `token` inside the `bot` section. It's needed to connect to a real Slack chat.
