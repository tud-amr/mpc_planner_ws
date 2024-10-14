[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![CI](https://github.com/tud-amr/mpc_planner_ws/actions/workflows/main.yml/badge.svg)


# MPC Planner Workspace (VSCode Docker)
This repository provides a complete VSCode docker environment for running MPC planner `mpc_planner` (see https://github.com/tud-amr/mpc_planner) and global guidance planner `guidance_planner` (see https://github.com/tud-amr/guidance_planner) that together make up **Topology-Driven MPC** (**T-MPC++**). 

T-MPC computes multiple distinct trajectories in parallel, each passing dynamic obstacles differently. For a brief overview of the method, see the [paper website](https://autonomousrobots.nl/paper_websites/topology-driven-mpc). It also includes a simulation environment for a mobile robot navigating among pedestrians. The code is associated with the following publications:

**Journal Paper:** O. de Groot, L. Ferranti, D. M. Gavrila, and J. Alonso-Mora, *Topology-Driven Parallel Trajectory Optimization in Dynamic Environments.* **IEEE Transactions on Robotics (T-RO)** 2024. Available: https://doi.org/10.1109/TRO.2024.3475047


**Conference Paper:** O. de Groot, L. Ferranti, D. M. Gavrila, and J. Alonso-Mora, *Globally Guided Trajectory Optimization in Dynamic Environments.* **IEEE International Conference on Robotics and Automation (ICRA)** 2023. Available: https://doi.org/10.1109/ICRA48891.2023.10160379

---

 Jackal Simulator | ROS Navigation Stack |
| ------------- | ------------- |
|<img src="docs/tmpc.gif" width="100%"> | <img src="https://imgur.com/QgYDTRq.gif" width="100%">|


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
- Global guidance planning in 2D dynamic environments (`guidance_planner`)
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

> **Note:** For colleagues from CoR at the TU Delft using the Vicon, please uncomment in `setup.sh` the line `vcs import < lab.repos src --recursive` to clone lab packages for the Vicon system. 


Then, in the VSCode terminal run:

```bash
chmod +x setup.sh
chmod +x build.sh
./setup.sh
```

Required repositories and dependencies will be installed.

The open-source **Acados** solver (https://docs.acados.org/) is installed by default. Dependencies of the solver generation are installed automatically with poetry in `setup.sh`. You will be prompted to install `poetry`.

For the licensed **Forces Pro** solver (https://www.embotech.com/softwareproducts/forcespro/overview/) used in the papers, installation instructions are included below. 

> **Note:** To use Forces Pro in the containerized environment, both a floating and regular license is required. If you only have a regular license, you cannot use it in the containerized environment. Instead, you can try to install the planner outside of the container (see https://github.com/tud-amr/mpc_planner).

<details>
    <summary><h3  style="display:inline-block"> Forces Pro (optional)</h3></summary>

**Regular Solver:** Go to my.embotech.com, log in to your account. Assign a regular license to your computer. Then download the client to `~/forces_pro_client/` **outside of the container**. If you have the solver in a different location, add its path to `PYTHONPATH`.

**Floating Solver:**
Go to my.embotech.com, log in to your account. Click on a license -> Download `Floating Licenses Proxy Standalone (Linux 64-bit) - FORCES PRO v5.1.0 onwards` **outside of the container** -> unzip. In the downloaded folder, `chmod +x forcespro_floating_licenses_proxy`. Then to start the solver proxy (necessary to run it), execute:
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

The following example features **Topology-driven MPC (T-MPC++) [1]** with a reference tracking cost and dynamic obstacle avoidance (*using ellipsoidal obstacles*) 

Applied to the Clearpath Jackal mobile robot (`mpc_planner_jackalsimulator`) in an environment with pedestrians.

<img src="docs/tmpc.gif" width="60%">


### ROS Navigation stack 
Task: `ROSNavigation: Run Simulator`

Navigation with static and dynamic obstacles. This example features
- **Topology-Driven MPC** for dynamic obstacle avoidance [1]
- **Curvature-Aware MPC** for reference tracking (https://ieeexplore.ieee.org/document/10161177)
- **Decomp Util** for static obstacle avoidance (https://arxiv.org/pdf/2406.11506)

<img src="docs/rosnavigation.gif" width="100%">


## License
This project is licensed under the Apache 2.0 license - see the LICENSE file for details.

## Citing
This repository was developed at the Cognitive Robotics group of Delft University of Technology by [Oscar de Groot](https://github.com/oscardegroot) in partial collaboration with [Dennis Benders](https://github.com/dbenders1) and [Thijs Niesten](https://github.com/thijs83) and under supervision of Dr. Laura Ferranti, Dr. Javier Alonso-Mora and Prof. Dariu Gavrila.

If you found this repository useful, please cite our paper:

- [1] **Journal Paper:** O. de Groot, L. Ferranti, D. M. Gavrila, and J. Alonso-Mora, *Topology-Driven Parallel Trajectory Optimization in Dynamic Environments.* **IEEE Transactions on Robotics (T-RO)** 2024. Available: https://doi.org/10.1109/TRO.2024.3475047
<!-- - **Safe Horizon Model Predictive Control (SH-MPC)** O. de Groot, L. Ferranti, D. Gavrila, and J. Alonso-Mora, “Scenario-Based Motion Planning with Bounded Probability of Collision.” arXiv, Jul. 03, 2023. [Online]. Available: https://arxiv.org/pdf/2307.01070.pdf
- **Scenario-based Model Predictive Contouring Control (S-MPCC)** O. de Groot, B. Brito, L. Ferranti, D. Gavrila, and J. Alonso-Mora, “Scenario-Based Trajectory Optimization in Uncertain Dynamic Environments,” IEEE RA-L, pp. 5389–5396, 2021. -->
