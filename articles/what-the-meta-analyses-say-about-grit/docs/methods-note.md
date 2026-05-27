# Methods Note

This article folder demonstrates basic meta-analytic concepts using synthetic study-level grit data.

A correlation can be transformed to Fisher's z:

\[
z_i = \frac{1}{2}\ln\left(\frac{1+r_i}{1-r_i}\right)
\]

The approximate sampling variance is:

\[
v_i = \frac{1}{n_i - 3}
\]

A random-effects weight can be written as:

\[
w_i = \frac{1}{v_i + \tau^2}
\]

A pooled transformed effect can be estimated as:

\[
\bar{z} = \frac{\sum_{i=1}^{k} w_i z_i}{\sum_{i=1}^{k} w_i}
\]

The workflows compare synthetic pooled associations for:

- total grit
- perseverance of effort
- consistency of interests

The purpose is to show why meta-analysis often leads to more modest and facet-sensitive interpretations of grit.
