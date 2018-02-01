# -*- coding: utf-8 -*-
"""
Created on Mon Sep 25 21:46:11 2017

@author: qinzh
"""

'''
import random

def read_data(filename):
    """ Reads instances and labels from a file. """

    f = open(filename, 'r')
    instances = []
    labels = []

    for line in f:

        # read both feature values and label
        instance_and_label = [float(x) for x in line.split()]

        # TASK 1.1.1
        # Remove label (last item) from instance_and_label and append it
        # to labels
        labels.append(instance_and_label.pop())        
        pass

        # TASK 1.1.2
        # Append the instance to instances
        instances.append(instance_and_label)
        pass

    return instances, labels

def num_unique_labels(labels):
    """ Return number of unique elements in the list labels. """
    return len(set([str(v) for v in labels]))
    pass

def kmeans_plus_plus(instances, K):
    """ Choose K centers from instances using the kmeans++ initialization. """
    k_centers = []
    n = len(instances)
    k_centers.append(random.choice(instances))
    distances = [euclidean_squared(k_centers[0], instances[j]) for j in range(n)]
    for i in range(K-1):
        randsum = random.uniform(0, sum(distances))
        for j in range(0, len(instances)):
            randsum = randsum - distances[j]
            if randsum < 0:
                k_centers.append(instances[j])
                break
        if len(k_centers) < K:
            distances = [min(euclidean_squared(k_centers[i+1], instances[j]), distances[j]) for j in range(n)]
    return k_centers
    pass

def euclidean_squared(p1, p2):
    """ Return squared Euclidean distance between two points p1 and p2. """

    return sum([abs(x-y)**2 for (x, y) in zip(p1, p2)])

def assign_cluster_ids(instances, centers):
    """ Assigns each instance the id of the center closest to it. """

    n = len(instances)
    cluster_ids = n*[0]  # create list of zeros

    for i in range(n):

        # TASK 1.4.1
        # Compute distances of instances[i] to each of the centers using a list
        # comprehension. Make use of the euclidean_squared function defined
        # above.
        distances = [euclidean_squared(instances[i], v) for v in centers]

        # Find the minimum distance.
        min_distance = min(distances)

        # TASK 1.4.2
        # Set the cluster id to be the index at which min_distance
        # is found in the list distances.
        cluster_ids[i] = distances.index(min_distance)

    return cluster_ids

def recompute_centers(instances, cluster_ids, centers):
    """ Compute centers (means) given cluster ids. """

    K = len(centers)
    n = len(cluster_ids)

    for i in range(K):

        # TASK 1.5.1
        # Find indices of of those instances whose cluster id is i.
        # Use a single list comprehension.
        one_cluster = [v for v in range(n) if cluster_ids[v] == i]
        cluster_size = len(one_cluster)
        if cluster_size == 0:  # empty cluster
            raise Exception("kmeans: empty cluster created.")

        # TASK 1.5.2
        # Suppose one_cluster is [i1, i2, i3, ... ]
        # Compute the mean of the points instances[i1], instances[i2], ...
        # using a call to reduce().
        # Supply the right 1st arg: a lambda function (this should take two
        # points [represented as lists] as arguments and return their sum) and
        # the right 2nd arg: a list (computed using a list comprehension)
        sum_cluster = reduce(lambda x, y: map(lambda (a,b):a+b, zip(x,y)), [instances[v] for v in one_cluster])
        centers[i] = [x/cluster_size for x in sum_cluster]

'''
def main():
    data_file = 'seeds_dataset.txt'
    instances, labels = read_data(data_file)
    centers = kmeans_plus_plus(instances, 3)
    cluster_ids = assign_cluster_ids(instances, centers)
    print centers
    recompute_centers(instances, cluster_ids, centers)
    print centers
'''
def cluster_using_kmeans(instances, K, init='random'):
    """ Cluster instances using the K-means algorithm.

    The init argument controls the initial clustering.
    """

    err_message = 'Expected init to be "random" or "kmeans++", got %s'
    if init != 'random' and init != 'kmeans++':
        raise Exception(err_message % init)

    if init == 'random':
        # Choose initial centers at random from the given instances
        centers = random.sample(instances, K)
    else:
        # Assign clusters using the kmeans++ enhancement.
        centers = kmeans_plus_plus(instances, K)

    # create initial cluster ids
    cluster_ids = assign_cluster_ids(instances, centers)

    converged = False
    while not converged:

        # recompute centers; note function returns None, modifies centers
        # directly
        recompute_centers(instances, cluster_ids, centers)

        # re-assign cluster ids
        new_cluster_ids = assign_cluster_ids(instances, centers)

        if new_cluster_ids == cluster_ids:  # no change in clustering
            converged = True
        else:
            cluster_ids = new_cluster_ids

    return cluster_ids, centers


def main():

    data_file = 'seeds_dataset.txt'
    instances, labels = read_data(data_file)
    print 'Read %d instances and %d labels from file %s.' \
        % (len(instances), len(labels), data_file)

    if len(instances) != len(labels):
        raise Exception('Expected equal number of instances and labels.')
    else:
        n = len(instances)

    # Find number of clusters by finding out how many unique elements are there
    # in labels.
    K = num_unique_labels(labels)
    print 'Found %d unique labels.' % K

    # Run k-means clustering to cluster the instances.
    cluster_ids, centers = cluster_using_kmeans(instances, K)

    # Print the provided labels and the found clustering
    print "Done with kmeans.\nPrinting instance_id, label, cluster_id."
    for i in range(n):
        print '%3d %2d %2d' % (i, labels[i], cluster_ids[i])

    # Now run k-means using kmeans++ initialization
    cluster_ids, centers = cluster_using_kmeans(instances, K, 'kmeans++')

    # Print the provided labels and the found clustering
    print "Done with kmeans++.\nPrinting instance_id, label, cluster_id."
    for i in range(n):
        print '%3d %2d %2d' % (i, labels[i], cluster_ids[i])
    
if __name__ == '__main__':
    main()
'''

import math
import random
import time
import losses


def gradient_descent(func_grad, init_point, step_size, num_iters):
    """ Run num_iters iterations of gradient descent.

    func_grad is the user supplied gradient.
    init_point is the initial point to start the optimization.
    step_size is the step size parameter.
    """

    curr_iter = init_point  # initialize iterate
    dim = len(init_point)  # remember dimension

    for i in range(num_iters):

        # get current gradient
        curr_gradient = func_grad(curr_iter)

        # check whether gradient is of correct dimension
        if len(curr_gradient) != dim:
            raise Exception("Expected argument func_grad to return \
                            gradient of dimension %d, got %d."
                            % (dim, len(curr_gradient)))

        # TASK 2.1.1
        # multiply gradient by step size
        scaled_gradient = step_size * curr_gradient

        # TASK 2.1.2
        # subtract scaled gradient from current iterate
        curr_iter = curr_iter - scaled_gradient

    return curr_iter

def coordinate_descent(func_grad_1d, init_point, step_size, num_iters,
                       choice='cyclic'):
    """ Run num_iters iterations of coordinate descent.

    func_grad_1d(point, j) should return the jth partial derivative at point x.
    init_point is the initial point to start the optimization.
    step_size is the step size parameter.
    choice is one of:
        'cyclic' - cycle through the coordinate
        'random' - pick coordinates at random
    """

    curr_iter = init_point  # initialize iterate
    dim = len(init_point)  # remember dimension

    for i in range(num_iters):

        # figure out coordinates to go over
        if choice == 'cyclic':
            # TASK 2.2.1
            # choose integers 0 thru dim-1
            coordinates = range(dim)
        elif choice == 'random':
            # TASK 2.2.2
            # choose dim random integers in {0,...,dim-1}
            # (with replacement)
            for i in range(dim):
                coordinates.append(random.randint(0,dim-1))
        else:
            raise Exception("Expected argument choice to be either 'cyclic' \
                            or 'random', got %s." % choice)

        # TASK 2.2.3
        # update each of the chosen coordinates
        for j in coordinates:
            curr_iter[j] = curr_iter[j] - step_size * func_grad_1d(curr_iter,j)

    return curr_iter

def main():

    n, d = 1000, 10  # sample size and dimension
    
if __name__ == '__main__':
    main()