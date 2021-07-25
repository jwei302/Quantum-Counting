import cv2
import os
import matplotlib.pyplot as plt
 

def getImgs():
    trainImgs = []
    testImgs = []
    allImgs = []
    for i in range(1,6):
        trainImgs.append(cv2.imread(f'Images/beaver{i}.bmp'))
        trainImgs.append(cv2.imread(f'Images/airplane{i}.bmp'))
    testImgs.append(cv2.imread(f'Images/beaverT.bmp'))
    testImgs.append(cv2.imread(f'Images/airplaneT.bmp'))
    allImgs.append(trainImgs)
    allImgs.append(testImgs)
    return allImgs;


def getImgsGS():
    train = getImgs()[0]
    test = getImgs()[1]
    trainOut = []
    testOut = []
    for img in train:
        trainOut.append(cv2.cvtColor(img, cv2.COLOR_BGR2GRAY))
    for img2 in test:
        testOut.append(cv2.cvtColor(img, cv2.COLOR_BGR2GRAY))
    return [trainOut,testOut]