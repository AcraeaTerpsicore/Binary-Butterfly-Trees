- Catalan substitution between the ordinary generating variable $z$ and the auxiliary parameter $u$:
  $$
  z = \frac{u}{(1+u)^2}, \qquad u = \frac{1-2z-\sqrt{1-4z}}{2z}.
  $$

- Classical binary tree generating function and its $u$-parametrisation:
  $$
  B(z) = \frac{1-\sqrt{1-4z}}{2z} = 1 + u.
  $$

- Survival generating function for Horton-Strahler numbers (register function) at threshold $p$:
  $$
  S_p(z) = \frac{1-u^2}{u} \cdot \frac{u^{2^p}}{1-u^{2^p}}.
  $$

- Marked right-spine generating function that encodes glued pairs of trees:
  $$
  A(z) = (B(z) - 1)\,B(z) = u(1+u).
  $$

- Closed form for the glued model survival generating function, valid for $p \ge 1$:
  $$
  T_p(z) = S_p(z)\left[(1+u)^2 + (1+u+u^2)\sum_{h=1}^{p-1} \frac{1-u^{2^h}}{1-u} \prod_{j=0}^{h-1} \frac{1-u^{2^j+1}}{1-u}\right]\prod_{j=0}^{p-1} \frac{1-u}{1-u^{2^j+1}}.
  $$

- Recurrence for $T_p(z)$ used for validation:
  $$
  T_p(z)\bigl(1 - z(B(z) - S_{p-1}(z))\bigr) = S_p(z)\bigl(1 + zA(z)\bigr) + z\bigl(S_{p-1}(z) - S_p(z)\bigr)T_{p-1}(z).
  $$
