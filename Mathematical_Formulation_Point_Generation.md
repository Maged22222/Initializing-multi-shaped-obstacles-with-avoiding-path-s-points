# Unified Mathematical Model for 3D Dynamic Obstacle Avoidance Waypoint Generation

## 1. Global Mathematical Formulation

The generation of candidate avoidance waypoints on the safety shell surrounding any 3D dynamic obstacle is governed by the following unified vector equation:

$$\mathbf{P}_i(\theta, \phi, t) = \mathbf{C}_i(t) + \Big[ R_i(\theta, \phi) + d_{\text{safe}} \Big] \cdot \hat{\mathbf{u}}(\theta, \phi)$$

---

## 2. Nomenclature & Definition of Variables

| Variable | Mathematical Domain | Description |
| :--- | :--- | :--- |
| $\mathbf{P}_i(\theta, \phi, t)$ | $\mathbb{R}^3$ | 3D coordinate of the candidate avoidance waypoint for obstacle $i$ at time $t$ |
| $\mathbf{C}_i(t)$ | $\mathbb{R}^3$ | Center position of obstacle $i$ at time $t$ ($\mathbf{C}_i(t) = \mathbf{C}_{i,0} + \mathbf{v}_i \cdot t$) |
| $R_i(\theta, \phi)$ | $\mathbb{R}^+$ | **Radial boundary function** defining the distance from the center to the obstacle surface in direction $(\theta, \phi)$ |
| $d_{\text{safe}}$ | $\mathbb{R}^+$ | Safety buffer distance (`Safty_Distance`) |
| $\hat{\mathbf{u}}(\theta, \phi)$ | $\mathbb{S}^2$ | **Unit direction vector** in spherical coordinates |
| $\theta$ | $[0, 2\pi]$ | Azimuth angle |
| $\phi$ | $[0, \pi]$ | Polar / elevation angle |

The unit directional ray $\hat{\mathbf{u}}(\theta, \phi)$ is given by:

$$\hat{\mathbf{u}}(\theta, \phi) = \begin{bmatrix} \sin\phi \cos\theta \\ \sin\phi \sin\theta \\ \cos\phi \end{bmatrix}$$

---

## 3. Shape-Specific Radial Boundary Functions $R_i(\theta, \phi)$

The geometric shape of the obstacle is entirely defined by the radial function $R_i(\theta, \phi)$:

### 3.1. Sphere
With constant nominal radius $R_0$:
$$R_i(\theta, \phi) = R_0$$

### 3.2. Complex Shape (Irregular / Asteroid Surface)
Using radial harmonic surface perturbation:
$$R_i(\theta, \phi) = R_0 \cdot \Big(1 + \Delta R(\theta, \phi)\Big)$$

Where $\Delta R(\theta, \phi)$ is modulated by $\sin\phi$ to preserve continuity at the poles:
$$\Delta R(\theta, \phi) = \sin\phi \sum_{k=1}^{K} a_k \cos(m_k \theta + \alpha_k) \sin(n_k \phi + \beta_k)$$

### 3.3. Ellipsoid
With principal semi-axes $a, b, c$ along the $X, Y, Z$ axes:
$$R_i(\theta, \phi) = \frac{1}{\sqrt{\left(\frac{\sin\phi \cos\theta}{a}\right)^2 + \left(\frac{\sin\phi \sin\theta}{b}\right)^2 + \left(\frac{\cos\phi}{c}\right)^2}}$$

### 3.4. Rectangular Box (Cuboid)
With half-dimensions $(L, W, H)$ centered at the origin:
$$R_i(\theta, \phi) = \min\left(\frac{L}{|\sin\phi \cos\theta|}, \; \frac{W}{|\sin\phi \sin\theta|}, \; \frac{H}{|\cos\phi|}\right)$$

### 3.5. Cylinder
With radius $r$ and half-height $H$ aligned along the $Z$-axis:
$$R_i(\theta, \phi) = \min\left(\frac{r}{\sin\phi}, \; \frac{H}{|\cos\phi|}\right)$$

---

## 4. Discrete Grid Implementation (Algorithm Representation)

Continuous angles $(\theta, \phi)$ are discretized on an $N_\theta \times N_\phi$ grid:

$$\theta_j = \frac{2\pi \cdot j}{N_\theta - 1}, \quad j \in \{0, 1, \dots, N_\theta - 1\}$$

$$\phi_k = \frac{\pi \cdot k}{N_\phi - 1}, \quad k \in \{0, 1, \dots, N_\phi - 1\}$$

The discrete 3D waypoint coordinates are computed as:

$$\mathbf{P}_{i, j, k}(t) = \mathbf{C}_i(t) + \Big[ R_i(\theta_j, \phi_k) + d_{\text{safe}} \Big] \begin{bmatrix} \sin\phi_k \cos\theta_j \\ \sin\phi_k \sin\theta_j \\ \cos\phi_k \end{bmatrix}$$

---

## 5. Duplicate Filtering & Boolean Mask

Due to spherical coordinate parameterization, coordinate degeneracies occur at the poles ($\phi_0 = 0$ and $\phi_{N_\phi - 1} = \pi$) where all $\theta_j$ collapse to identical Cartesian points:

$$\mathbf{P}_{i, j, 0} = \mathbf{C}_i(t) + \Big[ R_i(\cdot, 0) + d_{\text{safe}} \Big] \begin{bmatrix} 0 \\ 0 \\ 1 \end{bmatrix}$$

To prevent duplicate waypoints from entering graph search or Genetic Algorithm populations, a boolean mask vector $\mathbf{B} \in \{0, 1\}^M$ is constructed:

$$\mathbf{B}_m = \begin{cases} 0 & \text{if } \mathbf{P}_m \text{ is a unique, valid waypoint} \\ 1 & \text{if } \mathbf{P}_m \text{ is a duplicate or redundant point} \end{cases}$$

The final set of collision-avoidance waypoints $\mathcal{W}(t)$ used by the path planner is:

$$\mathcal{W}(t) = \left\{ \mathbf{P}_m(t) \;\middle|\; \mathbf{B}_m = 0 \right\}$$
