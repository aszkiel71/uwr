import cv2
cap = cv2.VideoCapture(0)
ret, frame = cap.read()
cv2.imwrite("my_face.jpg", frame)
cap.release()
