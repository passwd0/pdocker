#!/usr/bin/python
from pwn import *

HOST, PORT = 'xxx', 1337
target = os.path.abspath("/ctf/FILENAME")
libc_target = os.path.abspath("/lib/x86_64-linux-gnu/libc-2.23.so")
env = {'LD_PRELOAD' : "{}".format(libc_target)}

binary = ELF(target)
libc = ELF(libc_target)

context(arch='amd64', os='linux', endian='little')
context.terminal = ['tmux', 'splitw']
context.log_level = 'debug'


def start():
    if not args.REMOTE:
        print "LOCAL PROCESS"
        return process(target, env=env)
    else:
        print "REMOTE PROCESS"
        return remote(HOST, PORT)

def get_base_address(proc):
    return int(open("/proc/{}/maps".format(proc.pid), 'rb').readlines()[1].split('-')[0], 16)

def debug(breakpoints):
    script = "handle SIGALRM ignore\n"
    PIE = get_base_address(p)
    print('PIE: {}'.format(hex(PIE)))
    script += "set $_base = 0x{:x}\n".format(PIE)
    for bp in breakpoints:
        script += "b *0x%x\n"%(PIE+bp)
    gdb.attach(p, gdbscript=script)

p = start()
if args.GDB:
    debug([])




p.interactive()
