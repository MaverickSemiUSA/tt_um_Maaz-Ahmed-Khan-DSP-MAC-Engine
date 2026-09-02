# DSP MAC Engine

**Tiny Tapeout project:** `tt_um_mac_engine`  
**Author:** Maaz Ahmed Khan  
**Technology:** IHP SG13G2 (`ihp-sg13g2`)  
**Tile size:** 1 × 1  

## Project Description

DSP MAC Engine is an 8-bit signed multiply-accumulate hardware block. Two 8-bit signed operands are loaded through the 8-bit `ui_in` bus using control strobes on `uio_in`. A signed 8 × 8 multiplication generates a 16-bit product, which is sign-extended into a 24-bit accumulator. The accumulator can be cleared and read a byte at a time through `uo_out`.

The design was developed as a compact Tiny Tapeout DSP datapath suitable for demonstrating arithmetic acceleration and serial/byte-oriented result readout.

## Architecture

![Architecture diagram](docs/architecture.svg)

The top-level module is **`tt_um_mac_engine`**, defined in `src/rtl/project.v`.

## Specifications

| Parameter | Value |
|---|---|
| Technology | IHP SG13G2 |
| Design type | Sequential |
| Input data width | 8 bits |
| Output width | 8 bits |
| Internal accumulator | 24 bits |
| Multiplier | Signed 8 × 8 |
| Clock | 50 MHz (20 ns period) |
| Tiles | 1 × 1 |
| Final instances | 2191 |
| Standard-cell instances | 817 |
| Final core area | 23770.5 µm² |
| Final die area | 31318.4 µm² |
| Final utilization | 43.94% |
| Total power | 1.322 mW |
| Setup worst slack | 11.7616 ns |
| Hold worst slack | 0.1227 ns |

## Pin Usage

- `ui_in[7:0]`: operand data bus.
- `uo_out[7:0]`: selected byte of the 24-bit accumulator.
- `uio_in[0]`: `load_a`.
- `uio_in[1]`: `load_b`.
- `uio_in[2]`: `mac_en`.
- `uio_in[3]`: `clr_acc`.
- `uio_in[4]`: `rd_next`.
- `uio_in[7:5]`: unused inputs.

## Verification

The cocotb test applies reset, loads A = 3 and B = 5, performs one MAC operation, and checks that the output is 15. The recorded test result is stored in `sim/results.xml`; the waveform is stored in `sim/tb.vcd`.

## Physical Design / Hardening

The project was hardened using the LibreLane/Tiny Tapeout flow on IHP SG13G2. The curated repository keeps the major physical-design stages requested by the submission format: floorplan, PDN, global/detailed placement, CTS, global/detailed routing, metal fill, STA, sign-off, and final GDS.

### Final sign-off evidence

| Check | Result |
|---|---:|
| Magic DRC errors | 0 |
| KLayout DRC errors | 0 |
| XOR differences | 0 |
| LVS errors | 0 |
| LVS unmatched devices | 0 |
| LVS unmatched nets | 0 |
| LVS unmatched pins | 0 |
| Antenna violating nets | 0 |
| Antenna violating pins | 0 |
| Route DRC errors | 0 |
| Setup violations | 0 |
| Hold violations | 0 |
| Max slew violations | 0 |
| Max cap violations | 0 |
| Power-grid violations | 0 |

The recorded manufacturability report states that **Antenna, LVS, and DRC passed**. See `signoff/manufacturability.rpt`.

## Evidence Screenshots

The `evidence/` directory contains screenshots generated from the recorded flow outputs, including simulation, synthesis, final metrics, STA, DRC, LVS, IR drop, manufacturability, and the final hardened layout.

![Final layout](evidence/final_layout_record.png)

## Repository Structure

```text
Maaz-Ahmed-Khan-DSP-MAC-Engine/
├── README.md
├── info.yaml
├── src/
│   ├── rtl/
│   │   └── project.v
│   └── sim/
│       ├── tb.v
│       ├── test.py
│       └── Makefile
├── sim/
│   ├── results.xml
│   └── tb.vcd
├── synth/
├── postsynth/
├── floorplan/
├── pdn/
├── placement/
├── cts/
├── routing/
├── fill/
├── sta/
├── signoff/
├── gds/
├── config/
├── docs/
└── evidence/
```

## Important Files

- RTL: `src/rtl/project.v`
- Cocotb verification: `src/sim/test.py`
- Final GDS: `gds/tt_um_mac_engine.gds`
- Final LEF: `gds/tt_um_mac_engine.lef`
- Final DEF: `gds/tt_um_mac_engine.def`
- Final ODB: `gds/tt_um_mac_engine.odb`
- STA summary: `sta/summary.rpt`
- Manufacturability: `signoff/manufacturability.rpt`
- Metrics: `signoff/metrics.csv`
