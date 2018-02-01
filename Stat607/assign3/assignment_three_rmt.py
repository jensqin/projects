# Assignment 3, Part 1: Random Matrix Theory

import numpy as np
import scipy.linalg as LA
import matplotlib.pyplot as plt

n = 100  # size of matrices
t = 5000  # number of samples
v = np.empty((t, n))  # eigenvalue samples
v1 = np.empty(t)  # max eigenvalue samples
delta = 0.2  # histogram bin width

for i in range(t):

    # TASK 1.1.1
    # sample from GOE
    a = np.random.randn(n,n)
    s = (a+a.T)/2

    # TASK 1.1.2
    # compute eigenvalues
    evals = LA.eigvalsh(s)

    # store eigenvalues
    v[i, :] = evals

    # TASK 1.2.1
    # sample from GUE
    a = np.random.randn(n,n)+np.random.randn(n,n)*1j
    s = (a+np.matrix(a).H)/2
    s = np.array(s)

    # TASK 1.2.2
    # compute eigenvalues
    evals = LA.eigvalsh(s)

    # store maximum eigenvalue
    v1[i] = np.amax(evals)


# TASK 1.3
# normalize v
v = v/(np.sqrt(n*1.0/2))

# TASK 1.4.1
# set histogram bin values to a numpy array containing [-2, -2+delta,
# -2+2*delta, ..., 2]
# Note: both 2 and -2 are to be included
bins = np.arange(-2,2+delta,delta)

# compute histogram
hist, bin_edges = np.histogram(v, bins=bins)

# TASK 1.4.2
# plot bar chart
plt.bar(bin_edges[:-1], hist/(t*n*delta), width=delta, facecolor='y')

# plot theoretical prediction, i.e., the semicircle law
plt.plot(bin_edges, np.sqrt(4-bin_edges**2)/(2*np.pi), linewidth=2)

# set axes and save to pdf
plt.ylim([0, .5])
plt.xlim([-2.5, 2.5])
plt.savefig('Semicircle.pdf')
plt.close()

# TASK 1.5
# normalize v1
v1 = np.power(n,1.0/6)*(v1-2*np.sqrt(n))

# TASK 1.6.1
# set histogram bin values to a numpy array containing [-5, -5+delta,
# -5+2*delta, ..., 2]
# Note: both -5 and 2 are to be included
bins = np.arange(-5,2+delta,delta)

# compute histogram
hist, bin_edges = np.histogram(v1, bins=bins)

# TASK 1.6.2
# plot bar chart
plt.bar(bin_edges[:-1], hist/(t*delta), width=delta, facecolor='y')

# load theoretical prediction, i.e., the Tracy-Widom law, from file
prediction = np.loadtxt('tracy-widom.csv', delimiter=',')

# plot Tracy-Widom law
plt.plot(prediction[:, 0], prediction[:, 1], linewidth=2)

# set axes and save to pdf
plt.ylim([0, .5])
plt.xlim([-5, 2])
plt.savefig('Tracy-Widom.pdf')
plt.close()
