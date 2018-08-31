from Bio import SeqIO
from config import *
import os
import re



class AssignTaxID:
    def __init__(self, fastaPath=None, taxPath=None, outPath=None):
        self.fastaPath = fastaPath
        self.taxPath = taxPath
        self.outPath = outPath
    def GenerateDict(self):
        taxDict = {}
        tax_file = open(self.taxPath, "r")
        for line in tax_file:
            tmp = line.split("\t")
            taxDict[tmp[0]] = tmp[1]
        return taxDict
    
    def main(self):
        taxDict = self.GenerateDict()
        fastaRecords = SeqIO.parse(self.fastaPath, "fasta")
        print("main")
        for records in fastaRecords:
            print("id:%s\tlength:%d"%(records.id, len(records.seq)))
if __name__ == '__main__':
    AssignTaxID(fastaPath=FASTA_REF, taxPath = TAX_REF, outPath=OUT).main()