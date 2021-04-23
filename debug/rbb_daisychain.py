#!/usr/bin/python3

import sys
import socket

# https://github.com/ntfreak/openocd/blob/master/doc/manual/jtag/drivers/remote_bitbang.txt

class Tap(object):
    def __init__(self, port):
        self.port = port
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.connect(("localhost", port))

    def read_tdo(self):
        self.socket.send(b'R')
        return int(self.socket.recv(1))

    def write(self, tck, tms, tdi, read=False):
        command_value = ord('0')
        if tck:
            command_value += 4
        if tms:
            command_value += 2
        if tdi:
            command_value += 1
        command = bytes([command_value])
        if read:
            command += b'R'
        self.socket.send(command)
        if read:
            return int(self.socket.recv(1))
        else:
            return None

    def reset(self, command):
        self.socket.send(command)

tap_state_transitions = {
    "tlr": ("rti", "tlr"),
    "rti": ("rti", "select DR scan"),
    "select DR scan": ("capture DR", "select IR scan"),
    "capture DR": ("shift DR", "exit 1 DR"),
    "shift DR": ("shift DR", "exit 1 DR"),
    "exit 1 DR": ("pause DR", "update DR"),
    "pause DR": ("pause DR", "exit 2 DR"),
    "exit 2 DR": ("shift DR", "update DR"),
    "update DR": ("rti", "select DR scan"),
    "select IR scan": ("capture IR", "tlr"),
    "capture IR": ("shift IR", "exit 1 IR"),
    "shift IR": ("shift IR", "exit 1 IR"),
    "exit 1 IR": ("pause IR", "update IR"),
    "pause IR": ("pause IR", "exit 2 IR"),
    "exit 2 IR": ("shift IR", "update IR"),
    "update IR": ("rti", "select DR scan"),
}

class Chain(object):
    def __init__(self, debug=False):
        self.debug = debug
        self.state = "tlr"
        self.taps = []
        self.tck = 0
        self.dr_in = 0
        self.dr_out = 0
        self.dr_len = 0
        self.ir_in = 0
        self.ir_out = 0
        self.ir_len = 0

    def add_tap(self, tap):
        self.taps.append(tap)
        tap.write(0, 0, 0)

    def write(self, tck, tms, tdi):
        value = 0
        values = []
        for i, tap in enumerate(self.taps):
            do_read = self.debug or (i < len(self.taps) - 1)
            if i > 0:
                value = tap.write(tck, tms, value, read=do_read)
            else:
                value = tap.write(tck, tms, tdi, read=do_read)
            values.append(value)

        if self.debug:
            if not self.tck and tck:

                if self.state == "shift DR":
                    self.dr_out |= value << self.dr_len
                    self.dr_in |= tdi << self.dr_len
                    self.dr_len += 1
                elif self.state == "update DR":
                    sys.stdout.write("DR %db 0x%x -> 0x%x\n" % (self.dr_len, self.dr_in, self.dr_out))
                    self.dr_in = 0
                    self.dr_out = 0
                    self.dr_len = 0

                if self.state == "shift IR":
                    self.ir_out |= value << self.ir_len
                    self.ir_in |= tdi << self.ir_len
                    self.ir_len += 1
                elif self.state == "update IR":
                    sys.stdout.write("IR %db 0x%x -> 0x%x\n" % (self.ir_len, self.ir_in, self.ir_out))
                    self.ir_in = 0
                    self.ir_out = 0
                    self.ir_len = 0

                self.state = tap_state_transitions[self.state][tms]

            sys.stdout.write("%20ls write tck=%d tms=%d tdi=%d %s\n" % (
                self.state, tck, tms, tdi, " -> ".join(str(v) for v in values)))

        self.tck = tck

    def reset(self, command):
        for tap in self.taps:
            tap.reset(command)

    def read_tdo(self):
        value = self.taps[-1].read_tdo()
        if self.debug:
            print("read -> %d" % value)
        return value

def main():
    import argparse
    parser = argparse.ArgumentParser(
            description='Combine multiple remote_bitbang processes into a '
            'single scan-chain.')
    parser.add_argument("listen_port", type=int,
            help="port to listen on")
    parser.add_argument("tap_port", nargs="+", type=int,
            help="port of a remote_bitbang TAP to connect to")
    parser.add_argument("--quiet", action='store_true',
                        help="Don't print blink messages.")
    parser.add_argument("--debug", action='store_true',
                        help="Print out debug messages.")
    args = parser.parse_args()

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind(("localhost", args.listen_port))
    server.listen(1)

    chain = Chain(args.debug)
    for port in args.tap_port:
        chain.add_tap(Tap(port))

    sys.stdout.write("Listening on port %d.\n" % server.getsockname()[1])
    sys.stdout.flush()

    while True:
        (client, address) = server.accept()

        def read_command():
            value = chain.read_tdo()
            client.send(bytes([ord('0') + value]))

        commands = {
                b'B': lambda: print('blink on'),
                b'b': lambda: print('blink off'),
                b'R': read_command,
                b'0': lambda: chain.write(0, 0, 0),
                b'1': lambda: chain.write(0, 0, 1),
                b'2': lambda: chain.write(0, 1, 0),
                b'3': lambda: chain.write(0, 1, 1),
                b'4': lambda: chain.write(1, 0, 0),
                b'5': lambda: chain.write(1, 0, 1),
                b'6': lambda: chain.write(1, 1, 0),
                b'7': lambda: chain.write(1, 1, 1),
                b'r': lambda: chain.reset(b'r'),
                b's': lambda: chain.reset(b's'),
                b't': lambda: chain.reset(b't'),
                b'u': lambda: chain.reset(b'u'),
                b'\r': lambda: 0,
                b'\n': lambda: 0,
                }
        if args.quiet:
            commands[b'B'] = lambda: ()
            commands[b'b'] = lambda: ()

        while True:
            try:
                command = client.recv(1)
            except ConnectionResetError:
                print("Client disconnected.")
                break

            fn = commands.get(command)
            if fn:
                fn()
            else:
                client.close()
                print("Client disconnected.")
                break
        sys.stdout.flush()

if __name__ == '__main__':
    sys.exit(main())
