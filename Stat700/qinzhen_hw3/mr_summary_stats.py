from mrjob.job import MRJob
from mrjob.step import MRStep

class MRNWord(MRJob):

    def steps(self):
        return [
            MRStep(mapper=self.mapper_get,
                   reducer=self.reducer_sum),
            MRStep(reducer=self.reducer_compute)
        ]

    def mapper_get(self, _, line):
        pair = line.split()
        yield int(pair[0]), (1, float(pair[1]), float(pair[1])**2)

    def reducer_sum(self, word, values):
        yield word, reduce(lambda x,y: (x[0]+y[0], x[1]+y[1], x[2]+y[2]), values)

    def reducer_compute(self, word, values):
        yield word, map(lambda x: (x[0], x[1]/x[0], x[2]/x[0]-(x[1]/x[0])**2), values)[0]

if __name__ == '__main__':
    MRNWord.run()