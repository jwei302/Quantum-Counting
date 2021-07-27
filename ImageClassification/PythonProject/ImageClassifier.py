from ImageHandler import getImgsHSB
from ImageHandler import getImgsGS
import numpy as np

training, testing = getImgsHSB()
trainingGS, testingGs = getImgsGS()

### Begin step 1 of algorithm: Extract color and texture features of training images ###

## MAIN STEP 1 ALGORITHMS ##
def getTrainingFeatures():
	features = []
	colors = ExtractColor(training)
	textures = ExtractTexture(trainingGS)

	for i in range(0, len(features)):
		features[i] = textures[i] + colors[i]

	return features

# NOTE: If using only one testing image, wrap testing in list using []
def getTestingFeatures():
	c = ExtractColor(testing)
	t = ExtractTexture(testingGS)
	return c + t 

# Helper for step 1.1 and 1.2 of algorithm
# Normalizes a list
def normalize(lst):
	return [float(i) /  sum(lst) for i in lst]

# Step 1.1 of algorithm
# Extract color features of training and test images
def ExtractColor(images):
	Qh = 9
	Qs = 3

	GVals = []
	ColorFeatures = []

	for image in images:
		for pixel in image:
			H = pixel[0] * 2
			S = pixel[1] / 255
			B = pixel[2] / 255
			
			h, s, b = Quantize(H, S, B)

			G = Qh * h + Qs * s + b
			GVals.append(G)

		c = CalcHistogram(GVals, 0, 71)
		ColorFeatures.append(normalize(c))
		Gvals = []
	return ColorFeatures

# Helper for ExtractColor
# Gets the histogram for the G values as the final processing step
def CalcHistogram(vector, min, max):
	hist = np.zeros(max - min + 1, dtype=int)

	for val in vector:
		hist[val] += 1

	return hist.tolist()

# Helper for ExtractColor
# Quantizes H, S, B values into buckets
# 8 buckets for H, 3 for S, 3 for B
def Quantize(H, S, B):
	h = 0
	s = 0
	b = 0

	if(0 <= H <= 20 or 316 <= H <= 359):
		h = 0
	elif(21 <= H <= 40):
		h = 1
	elif(41 <= H <= 75):
		h = 2
	elif(76 <= H <= 155):
		h = 3
	elif(156 <= H <= 190):
		h = 3
	elif(191 <= H <= 270):
		h = 4
	elif(271 <= H <= 295):
		h = 5
	elif(296 <= H <= 315):
		h = 5

	if(0 <= S <= 0.2):
		s = 0
	elif(0.2 < S <= 0.7):
		s = 1
	elif(0.7 < S <= 1.0):
		s = 2
			
	if(0 <= B <= 0.2):
		s = 0
	elif(0.2 < B <= 0.7):
		s = 1
	elif(0.7 < B <= 1.0):
		b = 2

	return (h, s, b)

# Step 1.2 of algorithm
def ExtractTexture(imagesGS):
	textures = []
	for image in imagesGS:
		textures.append(GetTexture(image))
	return textures

# Extract texture features using the gray level co-occurence matrix
def GetTexture(imageGS):
	contrasts, correlations, energys, entropys = GLCM(imageGS)
	textures = [mean(contrasts), variance(contrasts), mean(correlations), variance(correlations), mean(energys), variance(energys), mean(entropys), variance(entropys)]
	return normalize(textures)

# Helper for step 1.2
# Finds the mean of a list
def mean(lst):
	return sum(lst) / len(lst)

# Helper for step 1.2
# Finds the variance of a list
def variance(lst):
	return sum((i - mean(lst)) ** 2 for i in lst) / len(lst)

### End step 1 of algorithm ###