# MPC Planner Workspace (VSCode Docker)
This repository provides a complete VSCode docker environment for running the `mpc_planner` (see `https://github.com/tud-amr/mpc_planner` for the planner documentation). The code is associated with the following publications:

O. de Groot, L. Ferranti, D. Gavrila, and J. Alonso-Mora, *Topology-Driven Parallel Trajectory Optimization in Dynamic Environments.* IEEE Transactions on Robotics 2024. Preprint: http://arxiv.org/abs/2401.06021


O. de Groot, L. Ferranti, D. Gavrila, and J. Alonso-Mora, *Globally Guided Trajectory Optimization in Dynamic Environments.* IEEE International Conference on Robotics and Automation (ICRA) 2023. Available: https://doi.org/10.1109/ICRA48891.2023.10160379


 Jackal Simulator | ROS Navigation Stack |
| ------------- | ------------- |
|<img src="docs/tmpc.gif" width="350"> | <img src="docs/rosnavigation.gif" width="650">|


---

## Table of Contents
1. [Features](#features) 
2. [Installation](#installation) 
3. [Usage](#usage) 
4. [Configuration](#configuration) 
5. [Examples](#examples) 
6. [License](#license) 
7. [Citing](#citing)

## Features
For features of the base planner, see `https://github.com/tud-amr/mpc_planner`. This repository combines other repositories for:

- Motion planning in 2D dynamic environments (`mpc_planner`)
- Simulating pedestrians with Social Forces (`pedestrian_simulator`)
- Defining reference paths (`roadmap`)
- Simulating the Clearpath Jackal (`jackal_simulator`)
<!-- - Computing free-space polygons from static obstacles -->

## Installation

### Container
In VSCode install these extensions:

- https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
- https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker

Clone this repository. In VSCode: `open_folder` -> open `mpc_planner_ws`. It will show a pop-up: click `Reopen in container`. It will build the container. This will take some time.

Then, in the VSCode terminal run:

```bash
chmod +x setup.sh
chmod +x build.sh
./setup.sh
```

Required repositories and dependencies will be installed.

The open-source **Acados** solver (`https://docs.acados.org/`) is installed by default. Dependencies of the solver generation are installed automatically with poetry in `setup.sh`. You will be prompted to install `poetry`.

For the licensed **Forces Pro** solver (`https://www.embotech.com/softwareproducts/forcespro/overview/`) used in the papers, installation instructions are included below. 

<details>
    <summary><h3  style="display:inline-block"> Forces Pro (optional)</h3></summary>
Note that a Floating license is required to run Forces Pro in the docker container.

You will need to set up both a regular and floating solver.

**Regular Solver:** Go to my.embotech.com, log in to your account. Assign a regular license to your computer. Then download the client to `~/forces_pro_client/` **outside of the container**. If you have the solver in a different location, add its path to `PYTHONPATH`.

**Floating Solver:**
Go to my.embotech.com, log in to your account. Click on a license -> Download `Floating Licenses Proxy Standalone (Linux 64-bit) - FORCES PRO v5.1.0 onwards` -> unzip. In the downloaded folder, `chmod +x forcespro_floating_licenses_proxy`. Then to start the solver proxy (necessary to run it), execute:
`./forcespro_floating_licenses_proxy`.

To use the floating license, set `solver_settings/floating_license` in `mpc_planner_<your_system>/config/settings.yaml` to `true`. 

With the Forces Pro solver set up, you have to generate a solver from **outside the VSCode container**. First you will need to set up the poetry environment from outside of the container. 
<!-- Add instructions on how to install poetry, etc. -->

With the poetry environment set up, a solver can be generated with:

```
poetry run python mpc_planner_jackalsimulator/scripts/generate_jackalsimulator_solver.py true
```

</details>

# Usage
VSCode tasks are available for common tasks. In VSCode, press `Ctrl + Shift + B`, the main tasks include:

- `JackalSimulator: Build` - Build `mpc_planner` for `JackalSimulator`
- `JackalSimulator: Build and Generate Solver` (only usable with `acados`) - Generate an Acados solver and build `mpc_planner` for `JackalSimulator`
- `JackalSimulator: Run Simulator` - Run the `JackalSimulator`

Similar commands are available for other systems. For more detail see `.vscode/tasks.json`.



<!-- <details open>
    <summary><b>Jackal Simulator</b></summary>

In VSCode, press Ctrl + Shift + B. Select `Run Simulator`.
</details>

<details>
    <summary><b>Jackal</b></summary>

You need to configure the following:

- *Your IP:*. Run `ip a`, copy the ip address of your ethernet connection into `connect_to_jackal.sh` at `ROS_IP`. 
- *Which Jackal:* See the last line in `connect_to_jackal.sh`.
- *The ROS_MASTER_URI and ROS_IP:* Run `source connect_to_jackal.sh`

Finally, run the planner: `roslaunch mpc_planner_jackal ros1_jackal.launch`.

To change the detected obstacles, see `ros1_jackal.launch`.
</details> -->

# Examples

### Jackal Simulator
Task: `JackalSimulator: Run Simulator`

The following example features 

- Topology-driven MPC (T-MPC++) for dynamic obstacle avoidance (using ellipsoidal obstacles) [1]
- Model Predictive Contouring Control (MPCC)

Applied to the Clearpath Jackal UGV (`mpc_planner_jackalsimulator`) with dynamic obstacles.

<img src="docs/tmpc.gif" width="400">


### ROS Navigation stack 
Task: `ROSNavigation: Run Simulator`

Navigation with static and dynamic obstacles. This example features
- Topology-Driven MPC for dynamic obstacle avoidance [1]
- Curvature-Aware MPC (https://ieeexplore.ieee.org/document/10161177)
- Decomp Util for static obstacle avoidance (https://arxiv.org/pdf/2406.11506)

<img src="docs/rosnavigation.gif" width="800">


## License
This project is licensed under the Apache 2.0 license - see the LICENSE file for details.

## Citing
This repository was developed at the Cognitive Robotics group of Delft University of Technology by [Oscar de Groot](https://github.com/oscardegroot) in partial collaboration with [Dennis Benders](https://github.com/dbenders1) and [Thijs Niesten](https://github.com/thijs83) and under supervision of Dr. Laura Ferranti, Dr. Javier Alonso-Mora and Prof. Dariu Gavrila.

If you found this repository useful, please cite the following paper:

- [1] **Topology-Driven Model Predictive Control (T-MPC)** O. de Groot, L. Ferranti, D. Gavrila, and J. Alonso-Mora, “Topology-Driven Parallel Trajectory Optimization in Dynamic Environments.” arXiv, Jan. 11, 2024. [Online]. Available: http://arxiv.org/abs/2401.06021
<!-- - **Safe Horizon Model Predictive Control (SH-MPC)** O. de Groot, L. Ferranti, D. Gavrila, and J. Alonso-Mora, “Scenario-Based Motion Planning with Bounded Probability of Collision.” arXiv, Jul. 03, 2023. [Online]. Available: https://arxiv.org/pdf/2307.01070.pdf
- **Scenario-based Model Predictive Contouring Control (S-MPCC)** O. de Groot, B. Brito, L. Ferranti, D. Gavrila, and J. Alonso-Mora, “Scenario-Based Trajectory Optimization in Uncertain Dynamic Environments,” IEEE RA-L, pp. 5389–5396, 2021. -->
