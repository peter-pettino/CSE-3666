from myhdl import Signal, block, always_comb, instances

#tag: c2a892c9d735551150ae8bc1f1b97744

@block
def ALU1bit(a, b, carryin, binvert, operation, result, carryout):

    """ 1-bit ALU

    result and carryout are output

    all other signals are input

    operation, the select signal to 4-input Mux, has two bits.
    We can compare operation directly integers, for example, 
        if operation == 0:

    """

    # internal signals
    notb = Signal(bool(0))
    mux1_out, and_out, or_out, adder_sum = (Signal(bool(0)), 
                            Signal(bool(0)), Signal(bool(0)), Signal(bool(0)))

    # we can read/set these signals (input, output, and internal) in submodules

    # the 'always_comb' decorator indicates a combinational circuit 
    # funciton name is not important. we could name it 'a_circuit' 
    # MyHDL analyzes code and adds Signals (of MyHDL Signal type) that appear
    # on the right hand side of any statements to a sentitivity list. 
    # In this example, if b's value changed, this function com_not is called
    # and notb will get a new value, which will trigger other submodules.
    @always_comb
    def comb_not():
        # We will use 'and', 'or', 'not' operators on single-bit values
        notb.next = not b

    # the 2-1 MUX that generates mux1_out
    @always_comb
    def comb_mux_2_1():
        # Use if-else 
        # Remember to use mux1_out.next = ...
        # TODO
        if binvert == 0:
            mux1_out.next = b
        else:
            mux1_out.next = notb

    # the AND gate
    @always_comb
    def comb_and():
        # TODO
        and_out.next = a and mux1_out

    # the OR gate
    @always_comb
    def comb_or():
        # TODO
        or_out.next = a or mux1_out

    # adder.
    @always_comb
    def comb_adder():
        # Generate adder_sum and carryout
        # The lecture slides have the logic expressions.
        # They are short enough so we use one line for adder_sum and 
        # one line for carrout. Remember ".next".
        # TODO
        adder_sum.next = a ^ mux1_out ^ carryin
        carryout.next = (a and mux1_out) or (mux1_out and carryin) or (a and carryin)

    # 4-1 mux to generate result
    @always_comb
    def comb_mux_4_1():
        # Use if-elif-elif-else. Remember to do "result.next = ..."
        # TODO
        if operation == 0:
            result.next = and_out
        elif operation == 1:
            result.next = or_out
        elif operation == 2:
            result.next = adder_sum
        else:
            result.next = 0 

    # return all the functions/submodules 
    # we could list them explicitly, like
    #     return comb_not, comb_and, ...
    return instances()

if __name__ == "__main__":
    from myhdl import intbv, delay, instance, StopSimulation, bin
    import argparse

    # testbench itself is a block
    @block
    def test_comb(args):

        # create signals
        result = Signal(bool(0))
        carryout = Signal(bool(0))

        a, b, carryin, binvert = [Signal(bool(0)) for i in range(4)]

        # operation has two bits
        operation = Signal(intbv(0)[2:])

        # instantiating a block
        alu1 = ALU1bit(a, b, carryin, binvert, operation, result, carryout)

        @instance
        def stimulus():
            print("op a b cin bneg | cout res")
            for op in args.op:
                assert 0 <= op <= 3
                for i in range(16):
                    # use MyHDL intbv to split bits, instead of shift and AND
                    binvert.next, carryin.next, b.next, a.next = intbv(i)[4:]
                    operation.next = op
                    yield delay(10)
                    print("{} {} {} {}   {}    | {}    {}".format(
                        bin(op, 2), 
                        int(a), int(b), int(carryin), int(binvert), 
                        int(carryout), int(result)))

            # stop simulation
            raise StopSimulation()

        return alu1, stimulus

    parser = argparse.ArgumentParser(description='Testing 1-bit ALU. Feb 2024.')
    parser.add_argument('op', type=int, nargs='*', 
            default=[2], help='operations')
    parser.add_argument('--trace', action='store_true', help='generate trace')
    parser.add_argument('--verbose', '-v', action='store_true', help='verbose')

    args = parser.parse_args()
    if args.verbose:
        print(args)

    tb = test_comb(args)
    tb.config_sim(trace=args.trace)
    tb.run_sim()