# Modular K-Profile Parameterization

```math
\newcommand{\c}         {\, ,}
\newcommand{\p}         {\, .}
\newcommand{\d}         {\partial}
\newcommand{\r}[1]      {\mathrm{#1}}
\newcommand{\b}[1]      {\boldsymbol{#1}}
\newcommand{\ee}        {\mathrm{e}}
\newcommand{\di}        {\, \mathrm{d}}
\newcommand{\ep}        {\epsilon}

\newcommand{\beq}       {\begin{equation}}
\newcommand{\eeq}       {\end{equation}}
\newcommand{\beqs}      {\begin{gather}}
\newcommand{\eeqs}      {\end{gather}}

% Non-dimensional numbers
\newcommand{\Ri}        {\mathrm{Ri}}
\newcommand{\Ek}        {\mathrm{Ek}}
\newcommand{\SL}        {\mathrm{SL}}
\newcommand{\K}         {\mathcal{E}}

\newcommand{\btau}      {\b{\tau}} % wind stress vector

% Model functions and constants
\renewcommand{\F}[2]      {\Upsilon^{#1}_{#2}}
\renewcommand{\C}[2]      {C^{#1}_{#2}}

\newcommand{\uwind}     {\omega_{\tau}}
\newcommand{\ubuoy}     {\omega_b}

\newcommand{\NL}        {NL}
```

In `ModularKPP` module, horizontally-averaged vertical turbulent
fluxes are modeled with the combination of a local diffusive flux and a non-local
non-diffusive flux:


```math
\beq
\overline{w \phi} = - K_\Phi \d_z \Phi + \NL_\Phi \c
\eeq
```

where the depth dependence of the eddy diffusivity ``K_\Phi`` is modeled
with a shape or 'profile' function, which gives rise to the name
``K``-profile parameterization.
The non-local flux term ``\NL_\Phi`` models the effects of convective
plumes.

``K``-profile schemes with a non-local flux term thus have three basic components:

1. A model for the mixing layer depth ``h``, over which ``K_\Phi > 0``.
2. A model for the diffusivity ``K``, which includes the ``K``-profile as well as its magnitude.
3. A model for the non-local flux, ``\NL_\Phi``.

## Mixing depth models

### CVMix mixing depth model

The
[CVMix](https://github.com/CVMix/CVMix-description/raw/master/cvmix.pdf)
mixing depth model uses the 'bulk Richardson number' criterion proposed by
[Large et al (1994)](https://agupubs.onlinelibrary.wiley.com/doi/abs/10.1029/94rg01872).
This model is described in [Mixing depth model in CVMix KPP](@ref).

### ROMS mixing depth model

The mixing depth model used by the [Regional Ocean Modeling System (ROMS)](https://www.myroms.org)
is described in appendix B of
[McWilliams et al (2009)](https://journals.ametsoc.org/doi/full/10.1175/2009JPO4130.1).
The model introduces a 'mixing function' ``\mathbb{M}``, which is increased
by shear and convection and decreased by stable stratification and rotation.
The stabilization function is defined as

```math
\beq \label{stabilization}
\mathbb M(z) = \int_z^0 \F{\SL}{}(z') \left [
      \left ( \d_z \b{U} \right )^2 - \frac{\d_z B}{\C{\Ri}{}} - \C{\Ek}{} f^2
    \right ] \, \mathrm{d} z'
    - \C{\K}{} \omega_b^\dagger N^\dagger \c
\eeq
```
where

```math
\beq
\omega_b^\dagger(z) \equiv \max \left (0, -z F_b \right )^{1/3} \c
  \quad \mathrm{and} \quad
N^\dagger(z) \equiv \max \left (0, \d_z B \right )^{1/2} \p
\eeq
```
Typically, the mixing function ``\mathbb M(z)`` increases from 0 at ``z=0``
into the well-mixed region immediately below the surface due to
``\left ( \d_z \b{U} \right )^2`` and ``\omega_b^\dagger N^\dagger``
during convection, and decreases to negative values in the stratified
region below the mixing layer due to the stabilizing action of ``-\d_z B / \C{\Ri}{}``.
The boundary layer depth is defined as the first nonzero depth where ``\mathbb M(z) = 0``.

Finally, the 'surface layer exclusion' function,

```math
\beq \label{exclusion}
\F{\SL}{} \equiv - \frac{z}{\C{\SL}{} h - z} \c
\eeq
```
acts to exclude the values of
``\left ( \d_z \b{U} \right )^2`` and ``\d_z B`` at the top of the boundary
layer from influencing the diagnosed boundary layer depth.

[McWilliams et al (2009)](https://journals.ametsoc.org/doi/full/10.1175/2009JPO4130.1)
suggests
``\C{\SL}{} = 0.1``, ``\C{\K}{} = 5.07``, ``\C{\Ri}{} = 0.3``, and ``\C{\Ek}{} = 211``
for the free parameters in \eqref{stabilization}.

## Diffusivity models

### [Large et al (1994)](https://agupubs.onlinelibrary.wiley.com/doi/abs/10.1029/94rg01872)

The diffusivity model proposed by 
[Large et al (1994)](https://agupubs.onlinelibrary.wiley.com/doi/abs/10.1029/94rg01872)
is described in [``K``-Profile model in CVMix KPP](@ref).


### Holtslag (1998)

The diffusivity model proposed by Holtslag in 1998 and described in 
[Siebesma et al (2007)](https://journals.ametsoc.org/doi/full/10.1175/JAS3888.1)
uses a cubic shape function and simple stability formulation:
```math
\beq
K_\phi = \C{\tau}{} h \omega_b \left [ \left ( \frac{\omega_\tau}{\omega_b} \right )^3 
    + \C{\tau b}{} d \right ]^{1/3} d \left ( 1 - d \right )^2
\eeq
```
where ``d = -z/h``. [Siebesma et al (2007)](https://journals.ametsoc.org/doi/full/10.1175/JAS3888.1) use 
``\C{\tau}{} = 0.4`` and ``\C{\tau b}{} = 15.6``.

## Non-local flux models

### 'Countergradient flux' model

As described in 
['Countergradient' non-local flux model in CVMix KPP](@ref),
the non-local countergradient flux is defined only for ``T`` and ``S``, and is

```math
\beq
NL_\phi = \C{\NL}{} F_\phi d (1 - d)^2 \c
\eeq
```
where ``d = -z/h`` is a non-dimensional depth coordinate and ``\C{\NL}{} = 6.33``.

### Diagnostic plume model

The diagnostic plume model proposed by
[Siebesma et al (2007)](https://journals.ametsoc.org/doi/full/10.1175/JAS3888.1)
integrates equations that describe the quasi-equilibrium vertical momentum and 
tracer budgets for plumes that plunge downwards from the ocean surface
due to destabilizing buoyancy flux. 

In the diagnostic plume model, the non-local flux of a tracer ``\Phi`` is parameterized as
```math
\beq
    NL_\phi = \C{a}{} \breve W \left ( \Phi - \breve \Phi \right ) \, ,
\eeq
```
where ``\C{a}{} = 0.1`` is the plume area fraction, ``\breve W`` is the plume
vertical velocity, and ``\breve \Phi`` is plume-averaged concentration of the 
tracer ``\phi``, while ``\Phi`` acquires the interpretation as the average 
concentration of ``\phi`` in the environment, excluding plume regions.

The plume-averaged temperature and salinity budgets are
```math
\begin{gather}
    \d_z \breve T = - \epsilon \left ( \breve T - T \right ) \, , \\
    \d_z \breve S = - \epsilon \left ( \breve S - S \right ) \, ,
\end{gather}
```
where ``\breve T`` and ``\breve S`` are the plume-averaged temperature and salinity, 
and ``T`` and ``S`` are the environment-averaged temperature and salinity and 
``\epsilon(z, h)`` is the parameterized entrainment rate, 
```math
\beq
\epsilon(z) = \C{\epsilon}{} 
    \left [ \frac{1}{\Delta c(z) - z} + \frac{1}{\Delta c(z) + \left ( z + h \right )} \right ] \, ,
\eeq
```
where ``\C{\epsilon}{} = 0.4``, ``\Delta c(z)`` is the spacing between cell interfaces at 
``z``, and ``h`` is the mixing depth determined via the chosen mixing depth model.

The budget for plume vertical momentum is

```math
\beq
    \d_z \breve W^2 = \C{w}{} \left ( \breve B - B - \C{\epsilon}{w} \epsilon \, \breve W^2 \right ) 
\eeq
```
where ``\breve B = \alpha \breve T - \beta \breve S`` is the plume-averaged buoyancy and 
``B = \alpha T - \beta S`` is the environment-averaged buoyancy, ``\C{w}{} = 2.86``, 
and ``\C{\epsilon}{w} = 0.2``.

The plume equations require boundary conditions at ``z=0``. 
The plume-averaged tracer concentration, which is defined at cell centers, is parameterized in terms
of the tracer flux across the boundary, ``Q_\phi``, as
```math
\beq
    \breve \Phi(z=z_N) = \Phi(z=z_N) - \C{\alpha}{} \frac{Q_\phi}{\sigma_w(z_N)} \, ,
\eeq
```
where ``\C{\alpha}{} - 1.0``, and ``\sigma_w(z)`` is an empirical expression for the 
vertical velocity standard deviation,
```math
\beq
    \sigma_w = \left ( \C{\sigma \tau}{} \omega_\tau^3 + \C{\sigma b}{} d \omega_b^3 \right )^{1/3} \left ( 1 - d \right )^{1/2} \, ,
\eeq
```
with ``\C{\sigma \tau}{} = 2.2`` and ``\C{\sigma b}{} = 1.32``.

We also assume that the plume vertical velocity, which is defined at cell centers, is 
zero in the first cell:
```math
\beq
    \breve W(z=z_N) = 0 \, .
\eeq
```

The diagnostic plume equations are discretized with an upwind scheme that integrates from
the surface downward, such that the plume-averaged temperature is determined via
```math
\beq
    \breve T_i = \breve T_{i+1} + \Delta c_{i+1} \epsilon \left ( z_{c, i+1} \right ) 
        \left ( \breve T_{i+1} - T_{i+1} \right )
\eeq
```
The plume vertical velocity is integrated with an upwind scheme such that
```math
\beq
\breve W^2_{i} = \breve W^2_{i+1} - \C{w}{} \Delta c_i 
    \left ( \breve B_{i+1} - B_{i+1} - \C{\epsilon}{w} \epsilon(z_{c, i+1}) \breve W^2_{i+1} \right )
\eeq
```
[Siebesma et al (2007)](https://journals.ametsoc.org/doi/full/10.1175/JAS3888.1)
recommend 


* [Large et al (1994)](https://agupubs.onlinelibrary.wiley.com/doi/abs/10.1029/94rg01872)
* [CVMix documentation](https://github.com/CVMix/CVMix-description/raw/master/cvmix.pdf)
* [McWilliams et al (2009)](https://journals.ametsoc.org/doi/full/10.1175/2009JPO4130.1)
* [Regional Ocean Modeling System (ROMS)](https://www.myroms.org)