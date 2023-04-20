from myhdl import * 

from hardware.register import RegisterE
from hardware.memory import Ram, Rom
from hardware.mux import Mux2
from hardware.gates import And2
from hardware.alu import ALU
from hardware.adder import Adder
from hardware.registerfile import RegisterFile

from sc_signals import RISCVSignals
from immgen import ImmGen 
from maincontrol import MainControl
from alucontrol import ALUControl

@block
def     RISCVCore(imem_data, dmem_data, rf, clock, reset, env):
    """
    All signals are input

    imem_data:   instruction memory. A Python dictionary
    dmem_data:   data memory. A Python dictionary
    rf:     register file. A list of 32 integers
    clock:  clock 
    reset:  reset
    env:    additonal info, mainly for controlling print

    env.done:   asserted when simulation is done
    """

    # find max and min of instruction addresses
    # always start from the first instruction in the instruction memory
    max_pc = max(imem_data.keys()) 
    init_pc = min(imem_data.keys()) 

    # signals
    sig = RISCVSignals(init_pc)

    #TODO
    adder1 = Adder(sig.PC4, sig.PC, sig.Const4)

    adder2 = Adder(sig.BranchTarget, sig.PC, sig.immediate)

    mux1 = Mux2(sig.ALUInput2, sig.ReadData2, sig.immediate, sig.ALUSrc)

    mux2 = Mux2(sig.WriteData, sig.ALUResult, sig.MemReadData, sig.MemtoReg)

    mux3 = Mux2(sig.NextPC, sig.PC4, sig.BranchTarget, sig.PCSrc)

    regPC = RegisterE(sig.PC, sig.NextPC, sig.signal1, clock, reset)

    pcSrc = And2(sig.PCSrc, sig.Branch, sig.Zero)

    immGen = ImmGen(sig.immediate, sig.instruction)

    alu1 = ALU(sig.ALUResult, sig.Zero, sig.ReadData1, sig.ALUInput2, sig.ALUOperation)

    aluControl = ALUControl(sig.ALUOp, sig.instr30, sig.funct3, sig.ALUOperation)

    mainControl = MainControl(sig.opcode, sig.ALUOp, sig.ALUSrc, sig.Branch, sig.MemRead, sig.MemWrite, sig.MemtoReg, sig.RegWrite)

    regFile = RegisterFile(sig.ReadData1, sig.ReadData2, sig.rs1, sig.rs2, sig.rd, sig.WriteData, sig.RegWrite, rf, clock, posedge = True)

    insMemory = Rom(sig.instruction, sig.PC, imem_data)

    dataMemory = Ram(sig.MemReadData, sig.ReadData2, sig.ALUResult, sig.MemRead, sig.MemWrite, dmem_data, clock)
    
    u_PC = RegisterE(sig.PC, sig.NextPC, sig.signal1, clock, reset)

    ##### Do NOT change the lines below
    @always_comb
    def set_done():
        env.done.next = sig.PC > max_pc  

    # print at the negative edge. for simulation only 
    @always(clock.negedge)
    def print_logic():
        if env.print_enable:
            sig.print(env.cycle_number, env.print_option)

    return instances()

if __name__ == "__main__" :
    print("Error: Please start the simulation with rvsim.py")
    exit(1)