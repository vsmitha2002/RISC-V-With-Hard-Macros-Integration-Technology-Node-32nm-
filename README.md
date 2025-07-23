🔧 Design and Implementation of RISC-V with Hard Macro Creation and Integration  
📌 Objective  
To design and implement a RISC-V-based which focus on Hard Macro Creation and Integration, optimizing for area, power, and performance at a 32nm technology node.  

🔍 Key Focus Areas  
✅ Hard Macro Design: Developed and implemented two hard macros for critical RISC-V sub-modules (e.g., ALU and Machine Counter) with strict area and performance targets.  
✅ Integration into Top-Level: Seamlessly integrated hard macros into the SoC-level design using optimized floorplanning, placement, and routing strategies.  
✅ Timing & Power Optimization: Achieved timing closure and power targets through multiple optimization loops and thorough static timing analysis (STA).  

📐 Design Specifications
Role: Synthesis, Place & Route (P&R), Timing Analysis  
Technology Node: 32nm  
Metal Layers: 8  
Hard Macros: 2  
Instance Count: ~25k  
Number of Clocks: 1  

| Stage                  | Tool                  | Vendor   |
| ---------------------- | --------------------- | -------- |
| Synthesis              | Design Compiler       | Synopsys |
| Place & Route          | IC Compiler II (ICC2) | Synopsys |
| Static Timing Analysis | PrimeTime             | Synopsys |

Creating Macros
Here we have 30 Verilog files. Among those files, two blocks, ALU and Machine Counter, were converted into hard macros using the following tools:
Design Compiler
ICC2
LM Shell (Library Manager)

:

🔄 Design Flow and Implementation Steps
The following steps were followed to implement and sign off the RISC-V IP with hard macro integration:

📚 Library & Technology Setup  
Created the design library.  
Imported NDM files, technology files, and parasitic models required for synthesis and physical design.
Imported RTL files and verified logical correctness.

⏱️ Timing Constraint Definition  
Defined MCMM (Multi-Corner Multi-Mode) constraints using SDC.  
Loaded timing constraints into the tools for accurate analysis.

🔧 Synthesis  
Performed RTL synthesis using Design Compiler.  
Optimized the netlist for area, power, and timing.
Exported synthesized Netlist, SDC.  

📐 Floorplanning  
Defined core and die area.  
Placed pins, I/Os, and hard macros.  
Created block shapes and reserved regions.  

⚡ Power Planning
Implemented power rings, power straps, and power rails.

🧠 Clock and Control Logic  
Performed CCD (Clock Constraint-Driven) optimization.  
Inserted ICGs (Integrated Clock Gating cells) to reduce dynamic power.  

📍 Placement & Routing  
Completed standard cell placement and legalized the design.  
Executed global and detailed routing. 
Checked and resolved DRC (Design Rule Check) violations.

📋Checks  
Ran pre-layout and post-layout checks (setup/hold, IR, DRC, LVS).  
Ensured design meets foundry requirements before tape-out.  

📈 Static Timing Analysis (STA)

Analyzed timing using PrimeTime across corners and modes.  
Generated setup, hold, and path delay reports.  
Resolved violations by:  
Cell sizing  
Buffer insertion/deletion  
Cell swapping  
Net rewiring  



