import cv2
import os
import matplotlib.pyplot as plt
from math import *
import math
from ImageHandler import *
import numpy as np


def GLCM(img):
    numQuantize = 8
    width = img.shape[0]
    height = img.shape[1]
    img = quantize(img,numQuantize)
    directions = ([0,1],[-1,1], [-1,0],[-1,-1])
    Mats = []
    for d in directions:
        Mat = blankImgGS((numQuantize,numQuantize))
        for i in range (width):
            for j in range (height):
                pval = img[i][j]
                x2 = i+d[0]
                y2 = j+d[1]
                if(x2 < width and y2 < height and x2 >= 0 and y2 >= 0):
                    pval2 = img[x2][y2]
                    Mat[pval][pval2] = Mat[pval][pval2] + 1
        Mats.append(Mat)
    Mats = np.array(Mats)
    contrasts = []
    correlations = []
    energys = []
    entropys = []
    for P in Mats:
        Q = P
        np.transpose(Q)
        P = P+Q
        normalize(P)
        mu = calcMu(P)
        var = calcVariance(P)
        con = 0
        cor = 0
        ene = 0
        ent = 0
        for i in range (P.shape[0]):
            for j in range (P.shape[1]):
                pval = P[i][j]
                con += pval*pow((i-j),2)
                cor += pval*(i-mu)*(j-mu)/var
                ene += pow(pval,2)
                ent += -math.log(pval)*pval
        contrasts.append(con)
        correlations.append(cor)
        energys.append(ene)
        entropys.append(ent)
    return [contrasts, correlations, energys, entropys]
def quantize(img, num):
    for i in range (img.shape[0]):
        for j in range (img.shape[1]):
            img[i][j] = floor(img[i][j]/(img.shape[0]/num))
    return img

def blankImgGS(dim):
    blank_image = np.zeros((dim[0],dim[1],))
    return blank_image

def normalize(mat):
    sum = 0
    for i in range (mat.shape[0]):
        for j in range (mat.shape[1]):
            sum = sum +  mat[i][j]
    for i in range (mat.shape[0]):
        for j in range (mat.shape[1]):
            mat[i][j] = 256*mat[i][j]/sum
def calcMu(mat):
    out = 0
    for i in range (mat.shape[0]):
        for j in range (mat.shape[1]):
            out += mat[i][j]*i
    return out
def calcVariance(mat):
    mu = calcMu(mat)
    out = 0
    for i in range (mat.shape[0]):
        for j in range (mat.shape[1]):
            out += mat[i][j]*pow((i-mu),2)
    return out

out = GLCM(getImgsGS()[0][0])  
print(out)


