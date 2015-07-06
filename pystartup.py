import os
import atexit
import readline

""" save history - not necessary with bpython """
if os.path.basename(os.environ['_']) != 'bpython':
    def save_history(path, readline):
        readline.write_history_file(path)

    history = os.path.expanduser('~/.pythonhist')
    atexit.register(save_history, history, readline)

    if os.path.exists(history):
        readline.read_history_file(history)

    readline.parse_and_bind("tab: complete")

del os, atexit, readline
