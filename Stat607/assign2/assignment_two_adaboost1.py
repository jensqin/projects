# Assignment 2, Part 3: Adaboost
#
# Version 0.1

import math
import numpy as np
from assignment_two_svm \
    import evaluate_classifier, print_evaluation_summary
# =============================================================================
# def weak_learner(instances, labels, dist):
# 
#     """ Returns the best 1-d threshold classifier.
# 
#     A 1-d threshold classifier is of the form
# 
#     lambda x: s*x[j] < threshold
# 
#     where s is +1/-1,
#           j is a dimension
#       and threshold is real number in [-1, 1].
# 
#     The best classifier is chosen to minimize the weighted misclassification
#     error using weights from the distribution dist.
# 
#     """
#     n, d = instances.shape
#     sort_mat = np.argsort(instances.T*dist).T
#     sort_labels = labels[sort_mat]
#     loop_mat = np.array([np.sign((i%n+i/n-n+0.5)*(i%n+i/n-2*n+0.5)) \
#                          for i in range(2*n*n)]).reshape(2*n,n).T
#     accuracy = sort_labels.T.dot(loop_mat)
#     posi = np.argmax(accuracy.T)
#     s = -np.sign(n + 0.5 -posi/d)
#     dimension = posi%d
#     if s == 1:
#         threshold = instances[sort_mat[(n-posi/d)%n, dimension], dimension]
#     elif (n-posi/d)%n==0:
#         threshold = - instances[sort_mat[(n-posi/d)%n, dimension], dimension]\
#         + 1e-10
#     else:
#         threshold = instances[sort_mat[(n-posi/d)%n-1, dimension], dimension]
#     return lambda x: s*x[dimension] < threshold
# =============================================================================

# TASK 3.1
# Complete the function definition below
# Remember to return a function, not the
# sign, feature, threshold triple
    
def weak_learner(instances, labels, dist):

    """ Returns the best 1-d threshold classifier.

    A 1-d threshold classifier is of the form

    lambda x: s*x[j] < threshold

    where s is +1/-1,
          j is a dimension
      and threshold is real number in [-1, 1].

    The best classifier is chosen to minimize the weighted misclassification
    error using weights from the distribution dist.

    """
    n,d = instances.shape
    def weak(X,s,threshold,dim):
        h_val = 1 if s*X[dim]<threshold else 0
        return h_val
    
    min_error = 1000
    s,dim,threshold = 1,0,0.0
    for J in range(d):
        for th in np.arange(-1.0, 1.01, 0.01):
            h_p = lambda x:weak(x,1,th,J)
            p_error = compute_error(h_p,instances,labels,dist)
            h_n = lambda x:weak(x,-1,th,J)
            n_error = compute_error(h_n,instances,labels,dist)
            if min(p_error,n_error)<min_error:
                min_error = min(p_error,n_error)
                dim,threshold = J,th
                s=1 if min(p_error,n_error)==p_error else -1
    return lambda x: s*x[dimension] < threshold

# TASK 3.2
# Complete the function definition below
def compute_error(h, instances, labels, dist):

    """ Returns the weighted misclassification error of h.

    Compute weights from the supplied distribution dist.
    """
    n,d = instances.shape
    clas_res = []
    for i in range(n):
        clas_res.append(h(instances[i]))
    clas_res = np.array(clas_res)
    error = sum(np.multiply(dist,np.where(clas_res==labels,0,1)))
    return error
    
# TASK 3.3
# Implement the Adaboost distribution update
# Make sure this function returns a probability distribution
def update_dist(h, instances, labels, dist, alpha):

    """ Implements the Adaboost distribution update. """
    n,d = instances.shape
    clas_res = []
    for i in range(n):
        clas_res.append(h(instances[i]))
    clas_res = np.array(clas_res)
    up_alp = np.where(clas_res==labels,math.exp(-alpha),math.exp(alpha))
    d_t1 = np.multiply(dist,up_alp)
    return d_t1/float(sum(d_t1))
    
def run_adaboost(instances, labels, weak_learner, num_iters=20):

    n, d = instances.shape
    n1 = labels.size

    if n1 != n:
        raise Exception('Expected same number of labels as no. of rows in \
                        instances')

    alpha_h = []

    dist = np.ones(n)/n

    for i in range(num_iters):

        print "Iteration: %d" % i
        h = weak_learner(instances, labels, dist)

        error = compute_error(h, instances, labels, dist)

        if error > 0.5:
            break

        alpha = 0.5 * math.log((1-error)/error)

        dist = update_dist(h, instances, labels, dist, alpha)

        alpha_h.append((alpha, h))

    # TASK 3.4
    # return a classifier whose output
    # is an alpha weighted linear combination of the weak
    # classifiers in the list alpha_h
    def classifier(point):
        """ Classifies point according to a classifier combination.

        The combination is stored in alpha_h.
        """
        cri_val = []
        for t in range(len(alpha_h)):
            temp = alpha_h[t][0]*(2*alpha_h[t][1](point)-1)
            cri_val.append(temp)
        
        return 1 if sum(cri_val)>0 else 0
            

    return classifier


def main():
    data_file = 'ionosphere.data'

    data = np.genfromtxt(data_file, delimiter=',', dtype='|S10')
    instances = np.array(data[:, :-1], dtype='float')
    labels = np.array(data[:, -1] == 'g', dtype='int')

    n, d = instances.shape
    nlabels = labels.size

    if n != nlabels:
        raise Exception('Expected same no. of feature vector as no. of labels')

    train_data = instances[:200]  # first 200 examples
    train_labels = labels[:200]  # first 200 labels

    test_data = instances[200:]  # example 201 onwards
    test_labels = labels[200:]  # label 201 onwards

    print 'Running Adaboost...'
    adaboost_classifier = run_adaboost(train_data, train_labels, weak_learner)
    print 'Done with Adaboost!\n'

    confusion_mat = evaluate_classifier(adaboost_classifier, test_data,
                                        test_labels)
    print_evaluation_summary(confusion_mat)

if __name__ == '__main__':
    main()
