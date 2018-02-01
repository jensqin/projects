## STAT 607 - Assignment 3

#### Name: Zhen Qin, Uniqname: qinzhen

#### 1.1

According to reference guide, we can use scipy.linalg to solve Eigenvalue Problems by these functions.

| [`eig`](https://docs.scipy.org/doc/scipy/reference/generated/scipy.linalg.eig.html#scipy.linalg.eig)(a[, b, left, right, overwrite_a, ...]) | Solve an ordinary or generalized eigenvalue problem of a square matrix. |
| ---------------------------------------- | ---------------------------------------- |
| [`eigvals`](https://docs.scipy.org/doc/scipy/reference/generated/scipy.linalg.eigvals.html#scipy.linalg.eigvals)(a[, b, overwrite_a, check_finite, ...]) | Compute eigenvalues from an ordinary or generalized eigenvalue problem. |
| [`eigh`](https://docs.scipy.org/doc/scipy/reference/generated/scipy.linalg.eigh.html#scipy.linalg.eigh)(a[, b, lower, eigvals_only, ...]) | Solve an ordinary or generalized eigenvalue problem for a complex Hermitian or real symmetric matrix. |
| [`eigvalsh`](https://docs.scipy.org/doc/scipy/reference/generated/scipy.linalg.eigvalsh.html#scipy.linalg.eigvalsh)(a[, b, lower, overwrite_a, ...]) | Solve an ordinary or generalized eigenvalue problem for a complex Hermitian or real symmetric matrix. |

If I need eigenvalues and eigenvectors, I will use `eig` and `eigh`. If I need only eigenvalues, I will use `eigvals` and `eigvalsh`. I choose `eigvalsh` in order to save time since I do not need eigenvectors. If I solve for a complex Hermitian or real symmetric matrix, I will use `eigh` and `eigvalsh`, otherwise I will use `eig` and `eigvals`.  Here I choose  `eigvalsh` because it is more applicable to the problem.

#### 1.2

Yes, I still got the same plots.



#### 2.1

Yes, it find one such separator.

####2.2

 The final classifier misclassify 8 points.  If we keep running the algorithm by cycling through the data, it will not eventually classify everything correctly because data is non linearly-separable data.



#### 3.1

Yes, the number of rows in `df` is the same as `nresults`.

#### 3.2

5 fuel types are available in Ann Arbor: ELEC, E85, BD, CNG and LPG. ELEC  is most common among Ann Arbor.