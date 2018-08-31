from Bio import SeqIO
from config import *
import os
import _pickle as pickle
import bz2
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
            taxDict[tmp[0]] = {
                'taxID': tmp[1],
                'sciName': tmp[2],
                'evalue': tmp[5]
            }
            taxDict[tmp[0]]['taxID'] = tmp[1]
            taxDict[tmp[0]]['sciName'] = tmp[2]
            taxDict[tmp[0]]['evalue'] = tmp[5]
        return taxDict
    def ConstructDB(self, taxDict=None, fastaObj=None):
        db = {}
        db['taxonomy'] = {}
        db['markers'] = {}
        for records in fastaObj:
            print("doing %s"%(records.id))
            if records.id in taxDict:
                db['taxonomy'][taxDict[records.id]['sciName']] = len(records.seq)
                db['markers'][taxDict[records.id]['sciName']] = {
                                                                'clade': '',
                                                                'ext': {},
                                                                'len':len(records.seq),
                                                                'score': taxDict[records.id]['evalue'],
                                                                'taxon': taxDict[records.id]['taxID']
                                                                }
            else:
                continue    
        return db
    def main(self):
        taxDict = self.GenerateDict()
        fastaRecords = SeqIO.parse(self.fastaPath, "fasta")
        # db = pickle.load(bz2.BZ2File(DATABASE_PATH))
        db = self.ConstructDB(taxDict=taxDict, fastaObj=fastaRecords)
        # print("main")
        # for records in fastaRecords:
        #     print("id:%s\tlength:%d"%(records.id, len(records.seq)))
if __name__ == '__main__':
    print(TAX_REF)
    AssignTaxID(fastaPath=FASTA_REF, taxPath = TAX_REF, outPath=OUT).main()