# 4-Bus Power System Steady-State Power Flow Analysis

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![MATLAB](https://img.shields.io/badge/Language-MATLAB-orange.svg)
![PowerWorld](https://img.shields.io/badge/Simulation-PowerWorld%20Simulator-brightgreen.svg)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen.svg)

This repository contains the numerical solution and simulation model for the steady-state power flow analysis of a 4-bus electrical grid system. The project solves non-linear algebraic power flow equations using an iterative **Gauss-Seidel method** implemented in **MATLAB**, and validates the mathematical results using **PowerWorld Simulator**.

---

## 📌 Project Overview

Power flow (load flow) analysis is essential for determining bus voltage magnitudes, phase angles, active and reactive line power flows, and total system losses under steady-state operating conditions. 

### System Topology & Bus Specifications
The analyzed system consists of 4 buses:
* **Bus 1:** Slack / Swing Bus ($|V_1| = 1.0\text{ pu}$, $\theta_1 = 0.0^\circ$)
* **Bus 2:** Load (PQ) Bus ($P_2 = -2.3\text{ pu}$, $Q_2 = -1.3\text{ pu}$)
* **Bus 3:** Load (PQ) Bus ($P_3 = -2.0\text{ pu}$, $Q_3 = -1.2394\text{ pu}$)
* **Bus 4:** Generator (PV) Bus ($P_4 = 2.38\text{ pu}$, $|V_4| = 1.02\text{ pu}$)

---

## ⚡ Line Parameters & Admittances

All network transmission line impedances and admittance values are expressed in per-unit (pu):

| Line | Line Impedance ($Z_{ij}$) | Series Admittance ($Y_{ij}$) |
| :--- | :--- | :--- |
| **Line 1–2** | $0.010080 + j0.050400\text{ pu}$ | $3.816 - j19.082\text{ pu}$ |
| **Line 1–3** | $0.007440 + j0.037200\text{ pu}$ | $5.171 - j25.857\text{ pu}$ |
| **Line 2–4** | $0.007440 + j0.037200\text{ pu}$ | $5.171 - j25.857\text{ pu}$ |
| **Line 3–4** | $0.012720 + j0.063600\text{ pu}$ | $3.024 - j15.122\text{ pu}$ |

---

## 🔬 Mathematical Method: Gauss-Seidel

The bus admittance matrix ($Y_{\text{bus}}$) is constructed, and iteratively updated using the standard Gauss-Seidel formulation:

$$V_i^{(k)} = \frac{1}{Y_{ii}} \left( \frac{P_{i,\text{sch}} - jQ_{i,\text{sch}}}{V_i^{(k-1)*}} - \sum_{j \ne i} Y_{ij} V_j^{(k-1)} \right)$$

For the PV Bus (Bus 4), voltage magnitude is clamped at $|V_4| = 1.02\text{ pu}$, and its reactive power contribution ($Q_4$) is recomputed at every iteration step.

---

## 📊 Comparison of Analytical vs. Simulation Results

### Bus Voltages and Angles
The numerical results calculated via the MATLAB script show high convergence with PowerWorld Simulator outputs:

| Bus | MATLAB $|V|\ (\text{pu})$ | PowerWorld $|V|\ (\text{pu})$ | MATLAB $\theta\ (^\circ)$ | PowerWorld $\theta\ (^\circ)$ |
| :---: | :---: | :---: | :---: | :---: |
| **Bus 1** | $1.0000$ | $1.0000$ | $0.0000^\circ$ | $0.0000^\circ$ |
| **Bus 2** | $0.9717$ | $0.9715$ | $-2.2417^\circ$ | $-2.2329^\circ$ |
| **Bus 3** | $0.9667$ | $0.9667$ | $-2.2244^\circ$ | $-2.2224^\circ$ |
| **Bus 4** | $1.0200$ | $1.0200$ | $0.5248^\circ$ | $0.5299^\circ$ |

### Transmission Line Losses ($P_{\text{loss}} + jQ_{\text{loss}}$)

| Line | MATLAB Losses ($\text{MW} + j\text{MVar}$) | PowerWorld Losses ($\text{MW} + j\text{MVar}$) |
| :---: | :---: | :---: |
| **Line 1–2** | $0.8724 + j4.3619$ | $0.9306 + j4.3428$ |
| **Line 1–3** | $1.3275 + j6.6377$ | $1.3261 + j6.6305$ |
| **Line 2–4** | $2.3987 + j11.9936$ | $2.4084 + j12.0419$ |
| **Line 3–4** | $1.5464 + j7.7320$ | $1.5479 + j7.7393$ |

* **Generator Reactive Output at Bus 4:** 
  * MATLAB Calculated: $224.7545\text{ MVar}$
  * PowerWorld Measured: $225.4644\text{ MVar}$

---

## Key Takeaways

1. **Voltage Profile:** All system bus voltages remain within acceptable operational limits ($0.95\text{ pu} \le |V| \le 1.05\text{ pu}$). The lowest voltage occurs at Bus 3 ($\approx 0.9667\text{ pu}$).
2. **Reactive Power Support:** Generator 4 injects $\approx 225\text{ MVar}$ into the grid to maintain its terminal voltage at $1.02\text{ pu}$, supplying the heavy reactive demand of nearby load centers at Bus 2 and Bus 3.

---

## 📄 License

This repository is released under the [MIT License](LICENSE).
