## TestCpu

#### XUPT 计科22课设

##### 项目基于MIPS架构下的五级流水线CPU设计

##### 运行环境:

**仿真**:Modelsim 10.4

**硬件**:Vivado 2019.2

##### 本仓库由四部分组成，约为5700行代码:

1.**SingleCycleCPU**:单周期CPU设计 完成20条基础指令，12条扩展指令，6条中断相关指令，并在Modelsim中完成测试

2.**SingleCycleCPU-PhysicalTest**:单周期CPU硬件测试，在Modelsim中完成仿真测试，并使用Vivado工具在basys3开发板上完成下板测试

3.**Five-levelCPU**:五级流水线CPU设计在单周期CPU设计基础上进行优化，实现取指，译码，执行，访存,回写五级流水设计,并在Modelsim中完成测试

4.**Five-levelCPU-PhysicalTest**:五级流水线CPU硬件测试，在Modelsim中完成仿真测试，并使用Vivado工具在basys3开发板上完成流水灯下板测试