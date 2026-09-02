import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

async def pulse(dut, sig):
    dut.uio_in.value = int(dut.uio_in.value) | sig
    await RisingEdge(dut.clk)
    dut.uio_in.value = int(dut.uio_in.value) & ~sig
    await RisingEdge(dut.clk)

@cocotb.test()
async def test_mac(dut):
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())  # 50 MHz, within 66MHz spec

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # load A = 3
    dut.ui_in.value = 3
    await pulse(dut, 0b00000001)   # load_a

    # load B = 5
    dut.ui_in.value = 5
    await pulse(dut, 0b00000010)   # load_b

    # mac_en -> acc += 15
    await pulse(dut, 0b00000100)

    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 15, f"expected 15, got {dut.uo_out.value}"
