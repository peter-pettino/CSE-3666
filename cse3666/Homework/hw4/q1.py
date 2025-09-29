from myhdl import block, always_comb, always_seq, Signal, intbv, instances

@block 
def Register(dout, din, clock, reset):
    """ 
    A register that always saves din to dout on positive edges
    """

    @always_seq(clock.posedge, reset=reset)
    def seq_reg():
        dout.next = din

    return seq_reg

@block
def Detect3x(z, b, clock, reset):
    """ 
    Input:  b
    Output: z

    b is the input
    z is the output
    """
    # 2 bits are enough to encode 3 states
    # initial state is 0
    state = Signal(intbv(0)[2:])
    next_state = Signal(intbv(0)[2:])

    # instantiate a register for the state
    # next_state is the input and state is the output
    reg_state = Register(state, next_state, clock, reset)

    # generate next_state, based on state and b
    @always_comb
    def next_state_logic():
        # TODO
        # Two statements to set two bits in next_state
        # Use only logic operators `not`, `and`, and `or`.
        # next_state.next[1] = ...
        # next_state.next[0] = ... 
        s1, s0 = state[1], state[0]
        next_state.next[1] = (not s1 and s0 and not b) or (s1 and not s0 and b)
        next_state.next[0] = (not s1 and not s0 and b) or (s1 and not s0 and not b) or (s1 and s0 and b)

    # generate output
    @always_comb
    def output_logic():
        # TODO
        # generate z from state and b
        # Use only logic operators `not`, `and`, and `or`.
        s1, s0 = state[1], state[0]
        z.next = ((not s1) and (not s0) and (not b)) or ((not s1) and s0 and b) or (s0 and s1 and (not b))

    # monitor that prints the values at the negative edge
    @instance
    def monitor():
        # v is only for debugging
        v = 0
        while True:
            yield clock.negedge     # wait for negative edge
            v = (v << 1) | b
            print("{:3}   {} | {}  {} {}".format(int(state), int(b), int(next_state), int(z), v))

    # return all logic  
    return instances()

if __name__ == "__main__":
    from myhdl import delay, instance, ResetSignal, always, StopSimulation
    import argparse, re

    # testbench itself is a block
    @block
    def test_comb(args):

        # reset signal level
        ACTIVE_LOW, INACTIVE_HIGH = 0, 1
        # create reset signal
        reset = ResetSignal(0, active=ACTIVE_LOW, isasync=True)

        HALF_PERIOD = delay(10)
        # create clock signal
        clock  = Signal(bool(1))

        # driving the clock
        @always(HALF_PERIOD)
        def clockGen():
            clock.next = not clock

        # create signals
        b, z = Signal(bool(0)), Signal(bool(0))

        # instantiating a block and connect to signals
        tut = Detect3x(z, b, clock, reset)

        @instance
        def stimulus():
            print("state b | ns z v")
            # release reset after a short delay
            delay1 = delay(1)
            yield delay1
            reset.next = INACTIVE_HIGH

            for s in args.bits:
                b.next = s == '1'
                yield clock.posedge
                # set b's value, 1ns after the positive edge
                yield delay1

            yield clock.negedge
            yield delay1        # wait for monitor to print
            raise StopSimulation()

        return tut, clockGen, stimulus

    parser = argparse.ArgumentParser(description='A state machine detecting 3x')
    parser.add_argument('bits', nargs='?', default="1001", help='bits to be shifted in')
    parser.add_argument('--trace', action='store_true', help='generate trace file')

    args = parser.parse_args()

    if not re.match(r"[01]+$", args.bits):
        print("Error: bits can only be 0 or 1")
        exit(1)

    tb = test_comb(args)
    tb.config_sim(trace=args.trace)
    tb.run_sim()
