# python configuration
#
import atexit
import os
import readline
import rlcompleter


# Persist history across sessions
history_path = os.path.expanduser('~/.pyhistory')


def save_history(history_path=history_path):
    import readline
    readline.write_history_file(history_path)


if os.path.exists(history_path):
    readline.read_history_file(history_path)

atexit.register(save_history)

readline.parse_and_bind('tab: complete')

# Clear variables from REPL
del os, atexit, readline, rlcompleter, save_history, history_path
