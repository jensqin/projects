from pyspark import SparkConf, SparkContext
import sys

if len(sys.argv) != 3:
    print('Usage: ' + sys.argv[0] + ' <in> <out>')
    sys.exit(1)
iloc = sys.argv[1]
oloc = sys.argv[2]

conf = SparkConf().setAppName('CountTriangles')
sc = SparkContext(conf = conf)

da = sc.textFile(iloc)
da = da.map(lambda line: line.split())
da = da.map(lambda l: [int(k) for k in l])
da = da.flatMap(lambda l: [sorted((l[0], l[i], l[j])) for i in range(1, len(l)) for j in range(1, len(l)) if i < j])
da = da.map(lambda l: (tuple(l), 1))
da = da.reduceByKey(lambda x, y: x + y)
da = da.filter(lambda l: l[1] >= 2)
da = da.map(lambda l: l[0])
da = da.map(lambda l: str(l[0]) + ' ' +str(l[1]) + ' ' + str(l[2]))

da.saveAsTextFile(oloc)
sc.stop()