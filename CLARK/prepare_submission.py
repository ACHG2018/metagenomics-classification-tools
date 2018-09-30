#!/usr/bin/env python3

# Create final submission files with abundance and confidence
# estimation for each reference based on CLARK result.

import csv
import sys

binSum = {}
abundance = []
confidence = []
readsSum = 0
DB_SIZE = 518


def sumGenus(inputFile):
    global readsSum
    with open(inputFile) as csvfile:
        abundanceFile = csv.reader(csvfile, delimiter="\t")
        next(abundanceFile)
        for row in abundanceFile:
            genus = row[2].split()[0]
            if not genus in binSum:
                binSum[genus] = int(row[0])
            else:
                binSum[genus] += int(row[0])
            readsSum += int(row[0])


def collectResults(inputFile):
    global abundance
    global confidence
    abundance = [0] * DB_SIZE
    confidence = [0] * DB_SIZE
    with open(inputFile) as csvfile:
        abundanceFile = csv.reader(csvfile, delimiter="\t")
        next(abundanceFile)
        for row in abundanceFile:
            genus = row[2].split()[0]
            abundance[int(row[1])] = float(row[0]) / readsSum
            confidence[int(row[1])] = float(row[0]) / binSum[genus]


def printResults(prefix):
    with open(prefix + ".confidence.tsv", "w") as confidenceOut:
        confidenceOut.write("Reference\tConfidence\n")
        for i in range(DB_SIZE):
            confidenceOut.write("CR_" + str(i) + "\t" +
                                str(confidence[i]) + "\n")
    confidenceOut.close()

    with open(prefix + ".abundance.tsv", "w") as abundanceOut:
        abundanceOut.write("Reference\tAbundance\n")
        for i in range(DB_SIZE):
            abundanceOut.write("CR_" + str(i) + "\t" +
                               str(abundance[i]) + "\n")


def main():
    if (len(sys.argv) != 3):
        print("Incorrect number of arguments")
        print("Usage: " + sys.argv[0] + "CLARK_abundance out_prefix")
        return
    sumGenus(sys.argv[1])
    collectResults(sys.argv[1])
    printResults(sys.argv[2])


if __name__ == '__main__':
    main()
